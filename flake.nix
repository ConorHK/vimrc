# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license

# This is an empty nixCats config.
# you may import this template directly into your nvim folder
# and then add plugins to categories here,
# and call the plugins with their default functions
# within your lua, rather than through the nvim package manager's method.
# Use the help, and the example repository https://github.com/BirdeeHub/nixCats-nvim

# It allows for easy adoption of nix,
# while still providing all the extra nix features immediately.
# Configure in lua, check for a few categories, set a few settings,
# output packages with combinations of those categories and settings.

# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.

{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim?dir=nix";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    plugins-blink = {
      url = "github:saghen/blink.cmp";
      flake = true;
    };
    plugins-oil-git-status = {
      url = "github:refractalize/oil-git-status.nvim";
      flake = false;
    };
    plugins-alduin = {
      url = "github:bakageddy/alduin.nvim";
      flake = false;
    };

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, nixCats, ... }@inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      allowUnfree = true;
    };
    # sometimes our overlays require a ${system} to access the overlay.
    # management of this variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.

    # First, we will define just our overlays per system.
    # later we will pass them into the builder, and the resulting pkgs set
    # will get passed to the categoryDefinitions and packageDefinitions
    # which follow this section.

    # this allows you to use ${pkgs.system} whenever you want in those sections
    # without fear.
    inherit (forEachSystem (system: let
      # see :help nixCats.flake.outputs.overlays
      dependencyOverlays = /* (import ./overlays inputs) ++ */ [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (utils.standardPluginOverlay inputs)
        # add any flake overlays here.
      ];
      # these overlays will be wrapped with ${system}
      # and we will call the same utils.eachSystem function
      # later on to access them.
    in { inherit dependencyOverlays; })) dependencyOverlays;
    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {
      # to define and use a new category, simply add a new list to a set here, 
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # propagatedBuildInputs:
      # this section is for dependencies that should be available
      # at BUILD TIME for plugins. WILL NOT be available to PATH
      # However, they WILL be available to the shell 
      # and neovim path when using nix develop
      propagatedBuildInputs = {
        general = with pkgs; [
        ];
      };

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          universal-ctags
          ripgrep
          fd
        ];
        lsp = with pkgs; [
          lua-language-server
          nixd
          pyright
          ruff-lsp
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {

        autocomplete = {
          gitPlugins = with pkgs.neovimPlugins; [ 
            blink
          ];
        };

        lsp = with pkgs.vimPlugins; [
          nvim-lspconfig # provides basic, default Nvim LSP client configurations
          neodev-nvim
          vim-illuminate # highlights other occurances of variable under cursor
          fidget-nvim
          lsp_signature-nvim
        ];

        treesitter = with pkgs.vimPlugins; [
          (nvim-treesitter.withPlugins (
            plugins: with plugins; [
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
            ]
          ))
          nvim-treesitter-context # shows function context
          nvim-treesitter-textobjects # adds additional textobjects such as function
        ];

        indent = with pkgs.vimPlugins; [
          indent-blankline-nvim # shows visible indentation
        ];

        snippets = with pkgs.vimPlugins; [
          luasnip
        ];

        git = with pkgs.vimPlugins; [
          gitsigns-nvim
          fugitive
        ];

        commenting = with pkgs.vimPlugins; [
          comment-nvim
        ];

        telescope = with pkgs.vimPlugins; [
          telescope-nvim
          telescope-fzf-native-nvim
          nvim-web-devicons
          telescope-undo-nvim
        ];

        tmux = with pkgs.vimPlugins; [
          tmuxNavigator
        ];

        startup = with pkgs.vimPlugins; [
          alpha-nvim
        ];

        surround = with pkgs.vimPlugins; [
          surround-nvim # enables the surround key functionality
        ];

        yank = with pkgs.vimPlugins; [
          smartyank-nvim  # yanks to osc52
        ];

        filesystem = {
          nixPlugins = with pkgs.vimPlugins; [
            oil-nvim # work with filesystem in buffer
            harpoon2 # file pinning
            project-nvim # discovers root directory of project and auto cds
          ];
          gitPlugins = with pkgs.neovimPlugins; [ 
            oil-git-status
          ];
        };

        diagnostics = with pkgs.vimPlugins; [
          trouble-nvim # populate quickfix list
        ];

        colorscheme = {
	  nixPlugins = with pkgs.vimPlugins; [
            kanagawa-nvim
	  ];
	  gitPlugins = with pkgs.neovimPlugins; [
            alduin
	  ];
        };

        movement = with pkgs.vimPlugins; [
          flash-nvim
        ];

        general = with pkgs.vimPlugins; [
          plenary-nvim
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      optionalPlugins = {
        gitPlugins = with pkgs.neovimPlugins; [ ];
        general = with pkgs.vimPlugins; [ ];
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          '' --set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      extraPython3Packages = {
        test = (_:[]);
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        test = [ (_:[]) ];
      };
    };



    # And then build a package with specific categories from above here:
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # These are the names of your packages
      # you can include as many as you wish.
      nvim = {pkgs , ... }: {
        # they contain a settings set defined above
        # see :help nixCats.flake.outputs.settings
        settings = {
          wrapRc = true;
          # IMPORTANT:
          # your alias may not conflict with your other packages.
          aliases = [ "vim" ];
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        };
        # and a set of categories that you want
        # (and other information to pass to lua)
        categories = {
          general = true;
          lsp = true;
          autocomplete = true;
          treesitter = true;
          indent = true;
          snippets = true;
          git = true;
          commenting = true;
          telescope = true;
          tmux = true;
          startup = true;
          surround = true;
          yank = true;
          filesystem = true;
          diagnostics = true;
          colorscheme = true;
          movement = true;
          test = true;
        };
      };
    };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "nvim";
  in


  # see :help nixCats.flake.outputs.exports
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

  }) // {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModules.default = utils.mkNixosModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    inherit utils;
    inherit (utils) templates;
  };

}