local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup(function(use)
	-- Let packer manage itself
	use({
		"wbthomason/packer.nvim",
		event = "VimEnter",
	})

	use("nathom/filetype.nvim")
	use("lewis6991/impatient.nvim")

	use({
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/nvim-lsp-installer",
		},
		config = function()
			require("plugin_settings.lspconfig")
		end,
	})
	use({
		"onsails/diaglist.nvim",
		requires = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("diaglist").init({})
		end,
		cmd = { "lopen" },
	})
	use({
		"kevinhwang91/nvim-bqf",
		cmd = { "copen" },
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("plugin_settings.treesitter")
		end,
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugin_settings.indent")
		end,
	})

	use({
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
	})

	use({
		"L3MON4D3/LuaSnip",
		-- wants = {
		--       "rafamadriz/friendly-snippets",
		-- },
		config = function()
			require("plugin_settings/luasnip")
		end,
	})
	-- use({ "rafamadriz/friendly-snippets" })

	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("plugin_settings.gitsigns")
		end,
	})

	use({
		"mhartington/formatter.nvim",
		config = function()
			require("plugin_settings.formatter")
		end,
	})

	use({
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup()
		end,
	})

	use({
		"tpope/vim-fugitive",
		cmd = { "Git" },
	})
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
	use({
		"junegunn/gv.vim",
		cmd = { "GV" },
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
			},
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("plugin_settings.telescope")
		end,
	})

	use({
		"ThePrimeagen/harpoon",
		config = function()
			require("plugin_settings.harpoon")
		end,
	})

	use({
		"jghauser/mkdir.nvim",
		config = function()
			require("mkdir")
		end,
	})

	use("christoomey/vim-tmux-navigator")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
