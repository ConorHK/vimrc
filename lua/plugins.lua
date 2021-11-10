local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  -- Let packer manage itself
  use {
    'wbthomason/packer.nvim',
    event = "VimEnter",
  }

  use {
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/nvim-lsp-installer",
    },
    config = function()
      require "plugin_settings.lspconfig"
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require "plugin_settings.treesitter"
    end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
        require("plugin_settings.indent")
    end,
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "tamago324/cmp-zsh",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      require("plugin_settings.cmp")
    end,
  }
  use {
    "tzachar/cmp-tabnine",
    run="./install.sh",
    requires = "hrsh7th/nvim-cmp"
  }

  use {
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("plugin_settings.gitsigns")
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
