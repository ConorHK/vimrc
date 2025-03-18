# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    plugins-alduin = {
      url = "github:conorhk/alduin.nvim";
      flake = false;
    };
    plugins-smear-cursor = {
      url = "github:sphamba/smear-cursor.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixCats, ... }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = { allowUnfree = true; };
      inherit (forEachSystem (system:
        let dependencyOverlays = [ (utils.standardPluginOverlay inputs) ];
        in { inherit dependencyOverlays; }))
        dependencyOverlays;

      categoryDefinitions =
        { pkgs, settings, categories, name, ... }@packageDef: {
          lspsAndRuntimeDeps = {
            general = with pkgs; [ universal-ctags ripgrep fd sqlite ];
            lsp = with pkgs; [
              lua-language-server
              nixd
              pyright
              ruff
              bash-language-server
              jdt-language-server
              jdk21_headless
            ];
          };

          startupPlugins = {
            autocomplete = {
              standard = with pkgs.vimPlugins; [
                blink-cmp
                blink-cmp-spell
              ];
            };

            lsp = with pkgs.vimPlugins; [
              nvim-lspconfig # provides basic, default Nvim LSP client configurations
              lazydev-nvim
              vim-illuminate # highlights other occurances of variable under cursor
              inc-rename-nvim
            ];

            java = with pkgs.vimPlugins; [
              nvim-jdtls
            ];

            treesitter = with pkgs.vimPlugins; [
              (nvim-treesitter.withPlugins (plugins:
                with plugins; [
                  bash
                  c
                  cmake
                  comment
                  csv
                  diff
                  dockerfile
                  editorconfig
                  gitattributes
                  gitcommit
                  git_config
                  gitignore
                  git_rebase
                  gpg
                  haskell
                  html
                  http
                  java
                  javascript
                  jq
                  json
                  json5
                  latex
                  lua
                  luadoc
                  luap
                  make
                  markdown
                  markdown-inline
                  nginx
                  nix
                  passwd
                  powershell
                  printf
                  properties
                  puppet
                  python
                  regex
                  requirements
                  ruby
                  sql
                  ssh-config
                  sxhkdrc
                  tmux
                  toml
                  typescript
                  unison
                  vim
                  vimdoc
                  xml
                  yaml
                  yang
                  zathurarc
                ]))
              nvim-treesitter-context # shows function context
              nvim-treesitter-textobjects # adds additional textobjects such as function
            ];

            indent = with pkgs.vimPlugins;
              [
                indent-blankline-nvim # shows visible indentation
              ];

            snippets = with pkgs.vimPlugins; [ luasnip ];

            git = with pkgs.vimPlugins; [ gitsigns-nvim fugitive ];

            commenting = with pkgs.vimPlugins; [ comment-nvim ];

            telescope = with pkgs.vimPlugins; [
              telescope-nvim
              telescope-fzf-native-nvim
              nvim-web-devicons
              telescope-undo-nvim
              sqlite-lua
            ];

            tmux = with pkgs.vimPlugins; [ Navigator-nvim ];

            zellij = with pkgs.vimPlugins; [ zellij-nav-nvim ];

            startup = with pkgs.vimPlugins; [ alpha-nvim ];

            surround = with pkgs.vimPlugins;
              [
                surround-nvim # enables the surround key functionality
              ];

            yank = with pkgs.vimPlugins;
              [
                smartyank-nvim # yanks to osc52
              ];

            filesystem = {
              nixPlugins = with pkgs.vimPlugins; [
                oil-nvim # work with filesystem in buffer
                harpoon2 # file pinning
                project-nvim # discovers root directory of project and auto cds
              ];
            };

            diagnostics = with pkgs.vimPlugins;
              [
                trouble-nvim # populate quickfix list
              ];

            colorscheme = { gitPlugins = with pkgs.neovimPlugins; [ alduin ]; };

            movement = {
              gitPlugins = with pkgs.neovimPlugins; [ smear-cursor ];
              standard = with pkgs.vimPlugins; [
                flash-nvim
                mini-ai
                mini-surround
                mini-operators
              ];
            };

            display = with pkgs.vimPlugins; [ noice-nvim nui-nvim ];
            python = with pkgs.vimPlugins; [ vim-python-pep8-indent ];

            general = with pkgs.vimPlugins; [ plenary-nvim ];
          };
        };

      packageDefinitions = {
        cnvim = { pkgs, ... }: {
          settings = {
            wrapRc = true;
            neovim-unwrapped =
              inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };
          categories = {
            autocomplete = true;
            colorscheme = true;
            commenting = true;
            diagnostics = true;
            display = true;
            filesystem = true;
            general = true;
            git = true;
            indent = true;
            java = true;
            lsp = true;
            movement = true;
            python = true;
            snippets = true;
            startup = false;
            surround = true;
            telescope = true;
            # tmux = true;
            treesitter = true;
            yank = true;
            zellij = true;
          };
        };
      };
      defaultPackageName = "cnvim";

    in forEachSystem (system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
      in {
        packages = utils.mkAllWithDefault defaultPackage;
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = "";
          };
        };

      }) // {

        formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = utils.mkNixosModules {
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
        homeModule = utils.mkHomeModules {
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
        inherit utils;
        inherit (utils) templates;
      };
}
