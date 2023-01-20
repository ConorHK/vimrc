local M = {}
function M.setup()
	-- Check if lazy.nvim is installed
	local function lazy_init()
		local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
		if not vim.loop.fs_stat(lazypath) then
		  vim.fn.system({
		    "git",
		    "clone",
		    "--filter=blob:none",
		    "https://github.com/folke/lazy.nvim.git",
		    "--branch=stable", -- latest stable release
		    lazypath,
		  })
		end
		vim.opt.rtp:prepend(lazypath)
	end

	local plugins = {

		-- Load only when require
		{
			"nvim-lua/plenary.nvim",
		},

		-- LSP
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				"folke/neodev.nvim",
				"RRethy/vim-illuminate",
				"jose-elias-alvarez/null-ls.nvim",
				"b0o/schemastore.nvim",
				"David-Kunz/markid",
				"j-hui/fidget.nvim",
				"theHamsta/nvim-semantic-tokens",
			},
			config = function()
				require("config.lsp").setup()
			end,
		},
		{
			"j-hui/fidget.nvim",
			config = true,
		},
		{
			"theHamsta/nvim-semantic-tokens",
			config = function()
				require("config.lsp.semantictokens").setup()
			end,
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
			config = function()
				require("config.treesitter").setup()
			end,
		},

		{
			"lukas-reineke/indent-blankline.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("config.indent").setup()
			end,
		},

		-- Completion
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
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
				require("config.cmp").setup()
			end,
		},

		-- Gutter git signs
		{
			"lewis6991/gitsigns.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("config.gitsigns").setup()
			end,
		},

		-- Commenting
		{
			"numToStr/Comment.nvim",
			keys = { "gc", "gcc", "gbc" },
			config = true,
		},

		-- Git integration
		{
			"tpope/vim-fugitive",
			cmd = "Git" ,
		},

		-- Shell commands
		{
			"conorhk/vim-eunuch",
			cmd = {
				"Cfd",
				"Lfd",
				"Move",
				"Rename",
				"Cfind",
				"Chmod",
				"Clocate",
				"Lfind",
				"Llocate",
				"Mkdir",
				"Delete",
				"Unlink",
				"Wall",
				"SudoWrite",
				"SudoEdit",
			},
		},

		-- Telescope
		{
			"nvim-telescope/telescope.nvim",
			cmd = "Telescope",
			keys = { "<leader>t", "<leader>g" },
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				"kyazdani42/nvim-web-devicons",
			},
			config = function()
				require("config.telescope").setup()
			end,
		},

		-- Harpoon file pinning
		{
			"ThePrimeagen/harpoon",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("config.harpoon").setup()
			end,
		},

		-- Seamless pane swapping
		{
			"numToStr/Navigator.nvim",
			config = function()
				require("config.tmux").setup()
			end,
		},

		-- Heuristically set buffer options
		{
			"tpope/vim-sleuth"
		},

		-- Startup screen
		{
			"goolord/alpha-nvim",
			config = function()
				require("config.alpha").setup()
			end,
		},

		{
			"vimwiki/vimwiki",
			config = function()
				require("config.vimwiki").setup()
			end,
		},
	}

	-- Init and start lazy
	lazy_init()
	local lazy = require("lazy")

	local opts = {
		defaults = {
			lazy = true
		},
		 performance = {
		    cache = {
		      enabled = true,
		    },
		},
	},

	lazy.setup(plugins, opts)
end

return M
