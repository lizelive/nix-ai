{
  description = "nix ml shell";

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
            enableOptimizations = true;
          };
          overlays = import ./overlays;
        };
        vscode = pkgs.vscode-with-extensions.override {
          # vscode = pkgs.vscode.fhsWithPackages (_: [ python ] ++ bevyDeps.nativeBuildInputs ++ bevyDeps.buildInputs);
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
      in
      {
        legacyPackages = pkgs;
        packages.vscode = vscode;
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
# python -c 'import torch; assert torch.cuda.is_available(), "cuda not available"'

