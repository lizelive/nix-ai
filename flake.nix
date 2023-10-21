{
  description = "nix ml shell";
  inputs = {
    nixpkgs.url = "github:lizelive/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
        python = pkgs.python310.withPackages (p:
          with p; [
            # diffusers
            torch
            # pytorch-bin
            transformers
            # diffusers
            accelerate
            # scipy
            optimum
            faiss
            datasets
            scikit-learn
            gradio

            diffusers
            ipykernel
            jupyter
            notebook

            trimesh
            # safetensors
            # onnxconverter-common

            # onnxruntime
            # onnxruntime-tools
          ]);

        app = python.pkgs.buildPythonApplication {
          src = ./.;
        };
        runtimeInputs = [ python pkgs.clang ];
      in {
        defaultPackage = pkgs.writeShellApplication {
          name = "depth2img";
          inherit runtimeInputs;
          text = ''
            ${./depth2img.py}
          '';
        };
        devShells.default = pkgs.mkShell {
          packages = [python pkgs.clang ];
        };
        formatter = pkgs.alejandra;
      }
    );
}
# python -c 'import torch; assert torch.cuda.is_available(), "cuda not available"'

