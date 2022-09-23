local diagnostics = require("null-ls").builtins.diagnostics
local formatting = require("null-ls").builtins.formatting
local codeactions = require("null-ls").builtins.code_actions
local completion = require("null-ls").builtins.completion
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

require("null-ls").setup({
  sources = {
	formatting.black,
	codeactions.refactoring,
	completion.luansip,
	diagnostics.flake8,
	diagnostics.luacheck,
	diagnostics.mypy,
	diagnostics.pylint,
  },
})
