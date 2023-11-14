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
            ms-python.python
            ms-toolsai.jupyter
            jnoortheen.nix-ide
            james-yu.latex-workshop
            github.copilot-chat
            github.copilot
            ms-python.vscode-pylance
            ms-toolsai.jupyter-renderers
            ms-toolsai.jupyter-keymap
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
          ]);

        pythonShell = pkgs.mkShell {
          nativeBuildInputs = [
            aiPython
            pkgs.black
          ];
        };
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
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ vulkan-loader ];
          };
      in
      {
        legacyPackages = pkgs;
        packages.vscode = vscode;
        formatter = pkgs.nixpkgs-fmt;

        devShells.python = pythonShell;

        devShells.bevy = bevyShell;

        devShells.aio = pkgs.mkShell {
          inputsFrom = [
            pythonShell
            bevyShell
            vscode
          ];
          # inherit (bevyShell) LD_LIBRARY_PATH;
        };
      }
    );
}
# python -c 'import torch; assert torch.cuda.is_available(), "cuda not available"'

