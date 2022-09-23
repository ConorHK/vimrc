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
		config = function()
			require("plugin_settings.lspconfig")
		end,
	})

	use({
		"williamboman/mason.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"jayp0521/mason-null-ls.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-lspconfig").setup_handlers {
			        -- The first entry (without a key) will be the default handler
				-- and willbe called for each installed server that doesn't have
			        -- a dedicated handler.
			        function (server_name) -- default handler (optional)
			            require("lspconfig")[server_name].setup {}
			        end,
			    }
			require("mason-null-ls").setup()
			require("mason-null-ls").setup_handlers {
				function(source_name)
					-- all sources with no handler get passed here
				end,
			}
			require("plugin_settings.null-ls")
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
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("plugin_settings.textobjects")
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
			require("plugin_settings.luasnip")
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
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		requires = { "tami5/sqlite.lua" },
	})

	use({
		"ThePrimeagen/harpoon",
		config = function()
			require("plugin_settings.harpoon")
		end,
	})
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("plugin_settings.refactoring")
		end,
	})

	use({
		"jghauser/mkdir.nvim",
		config = function()
			require("mkdir")
		end,
	})

	use("christoomey/vim-tmux-navigator")

	use("tpope/vim-sleuth")

	use({
		"goolord/alpha-nvim",
		config = function()
			require("plugin_settings.alpha")
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
