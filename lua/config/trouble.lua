local M = {}

function M.setup()
	local present, trouble = pcall(require, "trouble")
	if not present then
		return
	end

	local map = vim.keymap.set
	local default_opts = { noremap = true, silent = true }

	map("n", "<leader>xx", "<cmd>TroubleToggle<CR>", default_opts)
	map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", default_opts)
	map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", default_opts)
	map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", default_opts)
	map("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>", default_opts)
	map("n", "gR", "<cmd>TroubleToggle lsp_references<CR>", default_opts)
end

return M
