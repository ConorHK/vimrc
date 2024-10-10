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
				"folke/neodev.nvim",
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				"mfussenegger/nvim-lint",
				"RRethy/vim-illuminate",
				"stevearc/conform.nvim",
				"b0o/schemastore.nvim",
				"j-hui/fidget.nvim",
				"ray-x/lsp_signature.nvim",
			},
			config = function()
				require("config.lsp").setup()
			end,
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
				"nvim-treesitter/nvim-treesitter-context",
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
			"saghen/blink.cmp",
			lazy = false,
			version = "v0.*",
			opts = {
				highlight = {
					use_nvim_cmp_as_default = true,
				}
			},
		},

		-- Snippets
		{ "L3MON4D3/LuaSnip" },


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
			config = true,
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
			config = function()
				require("config.telescope").setup()
			end,
		},

		-- Harpoon file pinning
		{
			"ThePrimeagen/harpoon",
			branch="harpoon2",
			priority = 2000,
			dependencies = {
				"nvim-lua/plenary.nvim" ,
				"nvim-telescope/telescope.nvim",
			},
			config = function()
				require("config.harpoon").setup()
			end,
		},

		-- Seamless pane swapping
		{
			"numToStr/Navigator.nvim",
			config = function()
				require("config.tmux").setup()
			end
		},

		-- Heuristically set buffer options
		{
			"tpope/vim-sleuth",
		},

		-- Startup screen
		{
			"goolord/alpha-nvim",
			config = function()
				require("config.alpha").setup()
			end,
		},

		-- surround
		{
			"kylechui/nvim-surround",
			config = true,
		},

		-- Smartyank
		{
			"ibhagwan/smartyank.nvim",
			config = true,
		},

		-- Project working directory discovery
		{
			"ahmedkhalf/project.nvim",
			config = function()
				require("project_nvim").setup()
			end
		},

		-- Filesystem interaction
		{
			"stevearc/oil.nvim",
			opts = {},
			-- Optional dependencies
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("config.oil").setup()
			end
		},

		-- Trouble diagnostics
		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
			config = function()
				require("config.trouble").setup()
			end
		},

		-- Git
		{
			"tpope/vim-fugitive",
		},


		-- codewindow
		{
			"gorbit99/codewindow.nvim",
			config = function()
				local codewindow = require("codewindow")
				codewindow.setup({
					auto_enable = false,
					window_border = "none",
				})
				codewindow.apply_default_keybinds()
			end,
		},
		{
			"refractalize/oil-git-status.nvim",

			dependencies = {
				"stevearc/oil.nvim",
			},

			config = true,
		},


		-- kanagawa colorscheme
		{
			"rebelot/kanagawa.nvim",
			config = function()
				require("config.autocomplete").setup()
			end
		},

		-- flash movement
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			config = function() 
				require("config.flash").setup()
			end,
		},

	}

	-- Init and start lazy
	lazy_init()
	local lazy = require("lazy")
	local opts = {
		defaults = {
			lazy = true,
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
