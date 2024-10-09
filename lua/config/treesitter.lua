local M = {}
function M.setup()
	local present, ts_config = pcall(require, "nvim-treesitter.configs")
	if not present then
		return
	end

	-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
	---@diagnostic disable-next-line: missing-fields
	opts = {
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
	}

	if not require('nixCatsUtils').isNixCats then
		opts["ensure_installed"] = "all" -- bit overzealous but i dont want to maintain parity between flake list and here
	end
	vim.defer_fn(function()
		ts_config.setup(opts)
	end, 0)
end

return M
