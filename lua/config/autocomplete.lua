local M = {}

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
