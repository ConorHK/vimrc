local M = {}
function M.setup()
	local present, indent = pcall(require, "ibl")
	if not present then
		return
	end
	local highlight = {
		"FirstIndent",
		"SecondIndent",
	}
	local hooks = require("ibl.hooks")
	-- create the highlight groups in the highlight setup hook, so they are reset
	-- every time the colorscheme changes
	hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		vim.api.nvim_set_hl(0, "FirstIndent", { bg = "#121212" })
		vim.api.nvim_set_hl(0, "SecondIndent", { bg = "#212121" })
	end)
	indent.setup({
		exclude = { filetypes = { "alpha", "telescopeprompt" } },
		indent = { highlight = highlight, char = "" },
		whitespace = {
			highlight = highlight,
			remove_blankline_trail = false,
		},
		scope = { enabled = false },
	})
end

return M
