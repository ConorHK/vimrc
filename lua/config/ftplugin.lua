local M = {}

function M.setup()
	-- Nix filetype settings
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "nix",
		callback = function()
			vim.cmd("setlocal shiftwidth=2")
			vim.cmd("setlocal expandtab")
			vim.cmd("setlocal tabstop=8")
			vim.cmd("setlocal softtabstop=0")
		end,
	})

	-- Java filetype settings
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "java",
		callback = function()
			vim.cmd("setlocal shiftwidth=4")
			vim.cmd("setlocal expandtab")
			vim.cmd("setlocal tabstop=4")
			vim.cmd("setlocal softtabstop=0")
		end,
	})

	-- Python filetype settings
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "python",
		callback = function()
			vim.wo.colorcolumn = "120"
		end,
	})
end

return M
