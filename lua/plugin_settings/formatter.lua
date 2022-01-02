local present, formatter = pcall(require, "formatter")
if not present then
	return
end

formatter.setup({
	filetype = {
		c = {
			function()
				return {
					exe = "clang-format",
					args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
					stdin = true,
					cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
				}
			end,
		},
		lua = {
			function()
				return {
					exe = "stylua",
					args = { "-" },
					stdin = true,
				}
			end,
		},
		python = {
			-- Configuration for psf/black
			function()
				return {
					exe = "black", -- this should be available on your $PATH
					args = { "-" },
					stdin = true,
				}
			end,
		},
		java = {
			function()
				return {
					exe = "gjf",
					-- Formatter uses '-' as stdin
					args = { "-" },
					stdin = true,
				}
			end,
		},
	},
})
