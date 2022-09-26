local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
	return
end

ts_config.setup({
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
		swap = {
			enable = true,
			swap_next = {
				["<leader>f"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>F"] = "@parameter.inner",
			},
		},
	},
})
