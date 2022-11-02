local M = {}

function M.setup()
	local present, tmux = pcall(require, "Navigator")
	if not present then
		return
	end
	require('Navigator').setup({disable_on_zoom=true})
	vim.keymap.set('n', "<c-h>", '<CMD>NavigatorLeft<CR>')
	vim.keymap.set('n', "<c-l>", '<CMD>NavigatorRight<CR>')
	vim.keymap.set('n', "<c-k>", '<CMD>NavigatorUp<CR>')
	vim.keymap.set('n', "<c-j>", '<CMD>NavigatorDown<CR>')
	vim.keymap.set('n', "<c-Left>", '<CMD>NavigatorLeft<CR>')
	vim.keymap.set('n', "<c-Right>", '<CMD>NavigatorRight<CR>')
	vim.keymap.set('n', "<c-Up>", '<CMD>NavigatorUp<CR>')
	vim.keymap.set('n', "<c-Down>", '<CMD>NavigatorDown<CR>')
end

return M
