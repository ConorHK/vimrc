local M = {}

function M.setup()
	local map = vim.keymap.set
	local default_opts = { noremap = true, silent = true }
	local telescope = require("telescope")
	local pickers = require("telescope.pickers")
	local actions = require("telescope.actions")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values
	local sorters = require("telescope.sorters")
	local themes = require("telescope.themes")

	local live_multigrep = function(opts)
		opts = opts or {}
		opts.cwd = opts.cwd or vim.uv.cwd()
		local finder = finders.new_async_job({
			command_generator = function(prompt)
				if not prompt or prompt == "" then
					return nil
				end
				local pieces = vim.split(prompt, "  ")
				local args = { "rg" }
				if pieces[1] then
					table.insert(args, "-e")
					table.insert(args, pieces[1])
				end
				if pieces[2] then
					table.insert(args, "-g")
					table.insert(args, pieces[2])
				end

				---@diagnostic disable-next-line deprecated
				return vim.tbl_flatten({
					args,
					{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
				})
			end,
			entry_maker = make_entry.gen_from_vimgrep(opts),
			cwd = opts.cwd,
		})
		pickers
			.new(opts, {
				debounce = 100,
				prompt_title = "Multigrep",
				theme = themes.ivy,
				finder = finder,
				previewer = conf.grep_previewer(opts),
				sorter = sorters.empty(),
			})
			:find()
	end

	map("n", "<leader>t", "<cmd>Telescope find_files<CR>", default_opts)
	map("n", "<leader>g", live_multigrep, default_opts)
	map("n", "<leader>u", "<cmd>Telescope undo<CR>", default_opts)

	telescope.load_extension("harpoon")
	telescope.load_extension("undo")
	telescope.setup({
		defaults = {
			prompt_prefix = "➜  ",
			selection_caret = " > ",
			entry_prefix = "  ",
			initial_mode = "insert",
			color_devicons = true,
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
