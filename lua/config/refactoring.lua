local present, refactoring = pcall(require, "refactoring")
local present2, telescope = pcall(require, "telescope")
if not (present or present2) then
	return
end

refactoring.setup({})

telescope.load_extension("refactoring")

vim.api.nvim_set_keymap(
	"v",
	"<leader>rr",
	"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
	{ noremap = true }
)
vim.api.nvim_set_keymap("v", "<leader>rp", ":lua require('refactoring').debug.print_var({})<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>", { noremap = true })
