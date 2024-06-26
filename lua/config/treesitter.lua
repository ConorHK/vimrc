local M = {}
function M.setup()
	local present, ts_config = pcall(require, "nvim-treesitter.configs")
	if not present then
		return
	end

	---@diagnostic disable-next-line: missing-fields
	ts_config.setup({
		ensure_installed = "all",
		indent = {
			enable = true,
		},
		highlight = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["am"] = "@comment.outer",
					["im"] = "@comment.inner",
					["ao"] = "@loop.outer",
					["io"] = "@loop.inner",
				},
			},
		},
	})
end

return M
