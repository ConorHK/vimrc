local M = {}

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.setup()
	local present, blink = pcall(require, "blink.cmp")
	if not present then
		return
	end
	blink.setup({
		keymap = {
			preset = "enter",
			["<Tab>"] = { 'show_and_insert', 'select_next' },
			['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
		},
		cmdline = {
			keymap = {
				preset = "enter",
				["<Tab>"] = { 'show_and_insert', 'select_next' },
				['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
			},
		},
		snippets = { preset = "luasnip" },
		completion = {
			list = {
				selection = { 
					preselect = false 
				},
			}
		}
	})
end

return M
