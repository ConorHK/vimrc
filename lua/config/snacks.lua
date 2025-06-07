local M = {}
function M.setup()
	local map = vim.keymap.set
	local default_opts = { noremap = true, silent = true }
	require("snacks").setup({
		opts = {
			quickfile = {},
		},
		picker = {
			enabled = true,
			layout = {
				preset = "ivy",
			},
		}

	})
	map("n", "<leader>t", function()
		Snacks.picker.files()
	end, default_opts)
	map("n", "<leader>g", function()
		Snacks.picker.grep()
	end, default_opts)
end
return M
