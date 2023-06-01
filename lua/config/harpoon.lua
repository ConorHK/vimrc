local M = {}

function M.setup()
	local present, harpoon = pcall(require, "harpoon")
	if not present then
		return
	end

	local map = vim.api.nvim_set_keymap
	local default_opts = { noremap = true, silent = true }

	map("n", "<leader>a", ":lua require('harpoon.mark').add_file()<CR>", default_opts)
	map("n", "<leader>s", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", default_opts)
	map("n", "<leader>n", ":lua require('harpoon.ui').nav_file(1)<CR>", default_opts)
	map("n", "<leader>e", ":lua require('harpoon.ui').nav_file(2)<CR>", default_opts)
	map("n", "<leader>i", ":lua require('harpoon.ui').nav_file(3)<CR>", default_opts)
	map("n", "<leader>o", ":lua require('harpoon.ui').nav_file(4)<CR>", default_opts)

	harpoon.setup({
		nav_first_in_list = true,
	})
end

return M
