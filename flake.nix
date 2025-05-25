# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    plugins-alduin = {
      url = "github:conorhk/alduin.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixCats, ... }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = { allowUnfree = true; };
      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];

      categoryDefinitions =
        { pkgs, settings, categories, name, ... }@packageDef: {
          lspsAndRuntimeDeps = {
            general = with pkgs; [ universal-ctags ripgrep fd sqlite ];
            lua = with pkgs; [
              lua-language-server
            ];
            nix = with pkgs; [
              nixd
            ];
            python = with pkgs; [
              pyright
              ruff
            ];
            bash = with pkgs; [
              bash-language-server
            ];
            java = with pkgs; [
              jdt-language-server
              jdk21_headless
            ];
            typescript = with pkgs; [
              typescript-language-server
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
              standard = with pkgs.vimPlugins; [
                smear-cursor-nvim
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
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };
          categories = {
            autocomplete = true;
            bash = true;
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
            lua = true;
            movement = true;
            nix = true;
            python = true;
            snippets = true;
            startup = false;
            surround = true;
            telescope = true;
            treesitter = true;
            typescript = true;
            yank = true;
            zellij = true;
          };
        };
      };
      defaultPackageName = "cnvim";

    in
    forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # these outputs will be wrapped with ${system} by utils.eachSystem

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one passed in here.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

  }) // (let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });
}
