{
  description = "nix ml shell";
  inputs = {
    nixpkgs.url = "github:lizelive/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs
    ,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
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

            # open3d # not int nixos
            pyrender
            # tensorrt
            # protobuf cant have both without doing rewrite.
            # onnxconverter-common
            # onnxruntime
            # onnxruntime-tools

            ray
          ] ++ p.ray.optional-dependencies.air-deps);

        app = python.pkgs.buildPythonApplication {
          src = ./.;
        };
        runtimeInputs = [ python pkgs.clang ];
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
        weights = (pkgs.callPackage ./weights.nix { });
      in
      {
        # packages.ide = ide;
        # packages.depth2img = pkgs.writeShellApplication {
        #   name = "depth2img";
        #   inherit runtimeInputs;
        #   text = ''
        #     ${./depth2img.py}
        #   '';
        # };
        # packages.text-to-image = pkgs.writeShellApplication {
        #   name = "text-to-image";
        #   inherit runtimeInputs;
        #   text = "${./text-to-image.py}";
        # };
        # packages.image-to-image = pkgs.writeShellApplication {
        #   name = "image-to-image";
        #   inherit runtimeInputs;
        #   text = "${./image-to-image.py}";
        # };

        packages.default = weights.combined;
        devShells.default = pkgs.mkShell {
          packages = [ python pkgs.clang pkgs.gtk4 pkgs.egl-wayland pkgs.black ];
        };
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
# python -c 'import torch; assert torch.cuda.is_available(), "cuda not available"'

