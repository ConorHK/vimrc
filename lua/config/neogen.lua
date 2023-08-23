local M = {}

function M.setup()
	local present, neogen = pcall(require, "neogen")
	if not present then
		return
	end
	vim.api.nvim_set_keymap("n", "<Leader>c", ":lua require('neogen').generate()<CR>", { noremap = true, silent = true})
	neogen.setup(
		{
			enabled = true,
			snippet_engine = "luasnip",
			languages = {
				python = {
				    template = {
						annotation_convention = "reST"
					},
				},
			},
                }
	)
end

return M
