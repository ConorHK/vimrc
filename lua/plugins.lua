local M = {}
function M.setup()
	-- Indicate first time installation
	local packer_bootstrap = false

	-- packer.nvim configuration
	local conf = {
		profile = {
			enable = true,
			threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},

		display = {
			open_fn = function()
				return require("packer.util").float { border = "rounded" }
			end,
		},
	}

	-- Check if packer.nvim is installed
	-- Run PackerCompile if there are changes in this file
	local function packer_init()
		local fn = vim.fn
		local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			packer_bootstrap = fn.system {
				"git",
				"clone",
				"--depth",
				"1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
			}
			vim.cmd [[packadd packer.nvim]]
		end

		-- Run PackerCompile if there are changes in this file
		-- vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
		local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
		vim.api.nvim_create_autocmd(
			{ "BufWritePost" },
			{ pattern = "init.lua", command = "source <afile> | PackerCompile", group = packer_grp }
		)
	end


	local function plugins(use)
		use{"wbthomason/packer.nvim"}

		-- Performance
		use("lewis6991/impatient.nvim")
		use("nathom/filetype.nvim")


		-- Load only when require
		use { "nvim-lua/plenary.nvim", module = "plenary" }

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			requires = {
				"williamboman/nvim-lsp-installer",
			},
			config = function()
				require("config.lspconfig")
			end,
		})

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			requires = {
				{ "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPre" },
			},
			config = function()
				require("config.treesitter")
			end,
		})

		use({
			"lukas-reineke/indent-blankline.nvim",
			wants = { "nvim-treesitter" },
			config = function()
				require("config.indent")
			end,
		})

		-- Completion
		use({
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			opt = true,
			wants = { "LuaSnip", "lspkind-nvim" },
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
				require("config.cmp")
			end,
		})

		-- Gutter git signs
		use({
			"lewis6991/gitsigns.nvim",
			event = "BufReadPre",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("config.gitsigns")
			end,
		})

		-- Formatter TODO: swap for null-ls
		use({
			"mhartington/formatter.nvim",
			config = function()
				require("config.formatter")
			end,
		})

		-- Commenting
		use {
			"numToStr/Comment.nvim",
			keys = { "gc", "gcc", "gbc" },
			config = function()
				require("Comment").setup()
			end,
			disable = false,
		}

		-- Git integration
		use({
			"tpope/vim-fugitive",
			cmd = { "Git" },
		})

		-- Shell commands
		use({
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
		})

		-- Telescope
		use({
			"nvim-telescope/telescope.nvim",
			opt = true,
			cmd = { "Telescope" },
			module = { "telescope", "telescope.builtin" },
			keys = { "<leader>t", "<leader>g",},
			wants = {"harpoon",},
			requires = {
				"nvim-lua/plenary.nvim",
				{"nvim-telescope/telescope-fzf-native.nvim", run = "make", },
				"kyazdani42/nvim-web-devicons",
			},
			config = function()
				require("config.telescope")
			end,
		})

		-- Harpoon file pinning
		use({
			"ThePrimeagen/harpoon",
			module = { "harpoon", "harpoon.cmd-ui", "harpoon.mark", "harpoon.ui", "harpoon.term" },
			wants = { "telescope.nvim" },
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("config.harpoon")
			end,
		})

		-- Seamless pane swapping
		use("christoomey/vim-tmux-navigator")

		-- Heuristically set buffer options
		use("tpope/vim-sleuth")

		-- Startup screen
		use({
			"goolord/alpha-nvim",
			config = function()
				require("config.alpha")
			end,
		})

		-- Bootstrap Neovim
		if packer_bootstrap then
			print "Neovim restart is required after installation!"
			require("packer").sync()
		end
	end

	-- Init and start packer
	packer_init()
	local packer = require "packer"

	-- Performance
	pcall(require, "impatient")
	-- pcall(require, "packer_compiled")

	packer.init(conf)
	packer.startup(plugins)
end

return M
