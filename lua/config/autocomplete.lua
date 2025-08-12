local M = {}

function M.setup()
	local present, blink = pcall(require, "blink.cmp")
	if not present then
		return
	end
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
