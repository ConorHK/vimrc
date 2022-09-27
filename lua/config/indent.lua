local M = {}
function M.setup()
	local present, indent = pcall(require, "indent_blankline")
	if not present then
		return
	end
	indent.setup({
		show_current_context = true,
		filetype_exclude = { "alpha", "telescopeprompt" },
	})
end

return M
