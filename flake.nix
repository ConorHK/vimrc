{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plugins-alduin = {
      url = "github:conorhk/alduin.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          self',
          pkgs,
          system,
          ...
        }:
        let
          commonArgs = {
            neovimPlugins = {
              alduin = pkgs.vimUtils.buildVimPlugin {
                name = "alduin";
                src = inputs.plugins-alduin;
              };
            };
          };
        in
        {
          packages = {
            default = pkgs.callPackage ./default.nix commonArgs;

            nightly = pkgs.callPackage ./default.nix (
              commonArgs
              // {
                neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${system}.neovim;
              }
            );
          };

          devShells.default = pkgs.mkShell {
            packages = [
              (pkgs.writeShellScriptBin "nvim-dev" ''
                export NVIM_APPNAME=nvim-dev
                exec ${self'.packages.default}/bin/nvim \
                  -u "$PWD/init.lua" \
                  --cmd "set runtimepath^=$PWD" \
                  "$@"
              '')
            ];
            shellHook = ''
              echo "Development shell loaded!"
              echo "Use 'nvim-dev' to run neovim with live config from current directory"
              echo "Uses the same neovim build as the package but with hot-reloadable config"
            '';
          };

          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              stylua.enable = true;
            };
          };
        };
    };
}
