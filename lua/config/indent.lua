local present, indent = pcall(require, "indent_blankline")
if not present then
	return
end

vim.opt.list = true

indent.setup({
	show_current_context = true,
	filetype_exclude = { "alpha", "telescopeprompt" },
})
