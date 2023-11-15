{
  description = "nix ml shell";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions/c6080604ecf7c35da91d96ee0fb2601b20c1f5a1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    # nixpkgs.follows = "nix-vscode-extensions/nixpkgs";

  };

  # inputs = "github:nix-community/nix-vscode-extensions/c6080604ecf7c35da91d96ee0fb2601b20c1f5a1";
  outputs =
    { self
    , flake-utils
    , nixpkgs
    , nix-vscode-extensions
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = (import ./overlays) ++ [
          (pkgs: _: {
            vscode-extensions = (nix-vscode-extensions.extensions.${system}.forVSCodeVersion pkgs.vscode.version).vscode-marketplace;
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
            cudaSupport = true;
            enableOptimizations = true;
          };
        };

        vscode = pkgs.vscode-with-extensions.override {
          vscodeExtensions = with pkgs.vscode-extensions; [
            vadimcn.vscode-lldb
            timonwong.shellcheck
            tamasfe.even-better-toml
            serayuzgur.crates
            rust-lang.rust-analyzer
            redhat.vscode-yaml
            ms-toolsai.jupyter-renderers
            ms-toolsai.jupyter-keymap
            ms-toolsai.jupyter
            ms-python.vscode-pylance
            ms-python.python
            ms-python.black-formatter
            jnoortheen.nix-ide
            james-yu.latex-workshop
            github.copilot-chat
            github.copilot
          ];
        };

        aiPython = pkgs.python3.withPackages
          (p: with p;[
            trimesh
            pyrender
            torch
            transformers
            accelerate
            optimum
            diffusers
            safetensors
            pydantic
            gradio
            datasets
            fsspec

            scikit-learn
            scikit-image

            # testing
            pip
            notebook
            ipykernel
          ]
          #  ++ (with trimesh.optional-dependencies;  easy ++ recommend)
          );
        WEIGHTS = import ./weights pkgs;

        pythonShell = pkgs.mkShell {
          nativeBuildInputs = [
            aiPython
            pkgs.black
          ];
          inherit WEIGHTS;
        };
        LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
          addOpenGLRunpath.driverLink
          vulkan-loader
        ];
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
        bevyShell = with pkgs; mkShell
          {
            nativeBuildInputs = [
              cargo
              pkg-config
              rustfmt
              clippy
              rustc
            ];
            buildInputs = [
              openssl
              openssl.dev

              zlib

              udev
              alsa-lib
              vulkan-loader
              xorg.libX11
              xorg.libXcursor
              xorg.libXi
              xorg.libXrandr # To use the x11 feature
              libxkbcommon
              wayland # To use the wayland feature
            ];
            propagatedBuildInputs = [ vulkan-loader ];
            inherit LD_LIBRARY_PATH RUST_SRC_PATH;
          };

      in
      {
        legacyPackages = pkgs;
        packages.ide = vscode;
        packages.weights = WEIGHTS;
        packages.aiPython = aiPython;

        packages.pyembree = pkgs.python310Packages.pyembree;

        formatter = pkgs.nixpkgs-fmt;

        devShells.python = pythonShell;

        devShells.bevy = bevyShell;

        devShells.aio = pkgs.mkShell {
          packages = [ pkgs.bashInteractive pkgs.cuda-voxelizer ];
          inputsFrom = [
            pythonShell
            bevyShell
            vscode
          ];

          inherit LD_LIBRARY_PATH WEIGHTS RUST_SRC_PATH;
        };
      }
    );
}
# python -c 'import torch; assert torch.cuda.is_available(), "cuda not available"'

