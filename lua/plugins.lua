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
				"folke/lazydev.nvim",
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				"mfussenegger/nvim-lint",
				"RRethy/vim-illuminate",
				"stevearc/conform.nvim",
				"b0o/schemastore.nvim",
				"j-hui/fidget.nvim",
			},
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
				"nvim-treesitter/nvim-treesitter-context",
			},
		},

		-- Completion
		{
			"saghen/blink.cmp",
			lazy = false,
			version = "v0.*",
		},

		-- Snippets
		{ "L3MON4D3/LuaSnip" },

		-- Gutter git signs
		{
			"lewis6991/gitsigns.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},

		-- Commenting
		{
			"numToStr/Comment.nvim",
		},

		-- Telescope
		{
			"nvim-telescope/telescope.nvim",
			cmd = "Telescope",
			keys = { "<leader>t", "<leader>g" },
			priority = 1000,
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				"nvim-tree/nvim-web-devicons",
				"debugloop/telescope-undo.nvim",
			},
		},

		-- Harpoon file pinning
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			priority = 2000,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
			},
		},

		-- Seamless pane swapping
		{
			"numToStr/Navigator.nvim",
		},

		-- Heuristically set buffer options
		{
			"tpope/vim-sleuth",
		},

		-- Startup screen
		{
			"goolord/alpha-nvim",
		},

		-- surround
		{
			"kylechui/nvim-surround",
		},

		-- Smartyank
		{
			"ibhagwan/smartyank.nvim",
		},

		-- Project working directory discovery
		{
			"ahmedkhalf/project.nvim",
		},

		-- Filesystem interaction
		{
			"stevearc/oil.nvim",
			opts = {},
			-- Optional dependencies
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},

		-- Trouble diagnostics
		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
		},

		-- Git
		{
			"tpope/vim-fugitive",
		},

		{
			"refractalize/oil-git-status.nvim",

			dependencies = {
				"stevearc/oil.nvim",
			},
		},

		-- kanagawa colorscheme
		{
			"rebelot/kanagawa.nvim",
		},

		-- flash movement
		{
			"folke/flash.nvim",
			event = "VeryLazy",
		},
	}

	-- Init and start lazy
	lazy_init()
	local lazy = require("lazy")
	local opts =
		{
			defaults = {
				lazy = true,
			},
			performance = {
				cache = {
					enabled = true,
				},
			},
		}, lazy.setup(plugins, opts)
end

return M
