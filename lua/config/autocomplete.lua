local M = {}

function M.setup()
	local blink = require("blink.cmp")
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

	blink.setup(config)
end

return M
