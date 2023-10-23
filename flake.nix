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
            timm
            
            diffusers
            ipykernel
            jupyter
            notebook

            trimesh
            safetensors
            # protobuf cant have both without doing rewrite.
            # onnxconverter-common
~
            # onnxruntime
            # onnxruntime-tools
          ]);

        app = python.pkgs.buildPythonApplication {
          src = ./.;
        };
        runtimeInputs = [python pkgs.clang];
        ide = with pkgs;
          vscode-with-extensions.override {
            vscode = vscodium;
            vscodeExtensions = with vscode-extensions; [
              jnoortheen.nix-ide
              mkhl.direnv
              ms-python.python
              github.copilot-chat
              github.copilot
              vadimcn.vscode-lldb
            ];
          };
      in {
        packages.ide = ide;
        packages.depth2img = pkgs.writeShellApplication {
          name = "depth2img";
          inherit runtimeInputs;
          text = ''
            ${./depth2img.py}
          '';
        };
        packages.text-to-image = pkgs.writeShellApplication {
          name = "text-to-image";
          inherit runtimeInputs;
          text = "${./text-to-image.py}";
        };
        devShells.default = pkgs.mkShell {
          packages = [python pkgs.clang];
        };
        formatter = pkgs.alejandra;
      }
    );
}
# python -c 'import torch; assert torch.cuda.is_available(), "cuda not available"'

