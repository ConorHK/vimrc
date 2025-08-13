local M = {}
function M.setup()
	local smartyank = require("smartyank")

	smartyank.setup({})
	vim.api.nvim_create_user_command("CopyFilePath", function()
		-- Create a temporary buffer
		local buf = vim.api.nvim_create_buf(false, true)

		-- Put the filepath in the temporary buffer
		local path = vim.fn.expand("%:p")
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { path })

		-- Switch to the buffer, yank its content, and delete it
		local win = vim.api.nvim_get_current_win()
		local cur_buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_win_set_buf(win, buf)
		vim.cmd("normal! ggVGy")
		vim.api.nvim_win_set_buf(win, cur_buf)
		vim.api.nvim_buf_delete(buf, { force = true })

		print("File path copied: " .. path)
	end, {})
	vim.keymap.set("n", "<leader>cp", ":CopyFilePath<CR>", { silent = true, noremap = true })
end
return M
