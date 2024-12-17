local M = {}

function M.setup()
	local present, telescope = pcall(require, "telescope")
	if not present then
		return
	end

	local map = vim.keymap.set
	local default_opts = { noremap = true, silent = true }
	local actions = require("telescope.actions")

	map("n", "<leader>t", "<cmd>Telescope find_files<CR>", default_opts)
	map("n", "<leader>g", "<cmd>lua require('telescope.builtin').live_grep()<CR>", default_opts)
	map("n", "<leader>u", "<cmd>Telescope undo<CR>", default_opts)

	telescope.load_extension("harpoon")
	telescope.load_extension("undo")
	telescope.setup({
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			prompt_prefix = "➜  ",
			selection_caret = " > ",
			entry_prefix = "  ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
					results_width = 0.8,
				},
				vertical = {
					mirror = false,
				},
				width = 0.87,
				height = 0.80,
				preview_cutoff = 120,
			},
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			file_ignore_patterns = {},
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
			path_display = { "absolute" },
			winblend = 0,
			border = {},
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			color_devicons = true,
			use_less = true,
			set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			-- Developer configurations: Not meant for general override
			buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
			mappings = {
				i = {
					["<esc>"] = actions.close,
				},
			},
		},
		pickers = {
			find_files = {
				theme = "ivy",
			},
			live_grep = {
				theme = "ivy",
			},
			harpoon = {
				theme = "ivy",
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		},
	})
end

return M
