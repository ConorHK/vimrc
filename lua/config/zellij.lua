local M = {}

function M.setup()
	local _, zellij = pcall(require, "zellij-nav")

	vim.g.zellij_nav_default_mappings = false
	zellij.setup({})
	vim.keymap.set("n", "<c-h>", "<CMD>ZellijNavigateLeft<CR>")
	vim.keymap.set("n", "<c-l>", "<CMD>ZellijNavigateRight<CR>")
	vim.keymap.set("n", "<c-k>", "<CMD>ZellijNavigateUp<CR>")
	vim.keymap.set("n", "<c-j>", "<CMD>ZellijNavigateDown<CR>")
	vim.keymap.set("n", "<c-Left>", "<CMD>ZellijNavigateLeft<CR>")
	vim.keymap.set("n", "<c-Right>", "<CMD>ZellijNavigateRight<CR>")
	vim.keymap.set("n", "<c-Up>", "<CMD>ZellijNavigateUp<CR>")
	vim.keymap.set("n", "<c-Down>", "<CMD>ZellijNavigateDown<CR>")
end

return M
