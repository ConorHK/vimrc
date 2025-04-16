local M = {}
function M.setup()
	local obsidian = require("obsidian")
	obsidian.setup({
		workspaces = {
			{
				name = "work",
				path = "~/Documents/work"
			}
		},
		daily_notes = {
			folder = "x.journal",
			default_tags = { "daily-notes" },
		}
	})
end
return M
