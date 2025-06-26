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
	local luasnip_present = pcall(require, "luasnip")
	local config = {
		keymap = {
			preset = "enter",
		},
		cmdline = {
			keymap = {
				preset = "enter",
			},
		},
		completion = {
			list = {
				selection = {
					preselect = false,
				},
			},
			ghost_text = {
				enabled = false,
				show_without_menu = false,
			},
		},
	}

	if luasnip_present then
		config.snippets = { preset = "luasnip" }
	end
	blink.setup(config)
end

return M
