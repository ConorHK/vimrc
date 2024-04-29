local M = {}

local nls = require("null-ls")
local nls_utils = require("null-ls.utils")
local b = nls.builtins


-- local with_root_file = function(builtin, file)
--   return builtin.with {
--     condition = function(utils)
--       return utils.root_has_file(file)
--     end,
--   }
-- end

local sources = {
	-- formatting
	b.formatting.black,
	b.formatting.isort,
	-- b.formatting.prettierd,
	-- b.formatting.shfmt,
	-- b.formatting.shellharden,
	-- b.formatting.fixjson,
	-- b.formatting.google_java_format,
	-- b.formatting.stylua,
	-- -- with_root_file(b.formatting.stylua, "stylua.toml"),

	-- diagnostics
	-- b.diagnostics.write_good,
	-- b.diagnostics.markdownlint,
	-- b.diagnostics.eslint_d,
	-- b.diagnostics.flake8.with { extra_args = { "--max-line-length=120" } },
	-- b.diagnostics.tsc,
	-- b.diagnostics.selene,
	-- b.diagnostics.codespell,
	-- with_root_file(b.diagnostics.selene, "selene.toml"),
	b.diagnostics.zsh,
	-- b.diagnostics.mypy,
	-- b.diagnostics.stylelint,

	-- code actions
	-- b.code_actions.eslint_d,
	-- b.code_actions.gitrebase,
	-- b.code_actions.refactoring,
	-- b.code_actions.proselint,
	-- b.code_actions.shellcheck,

	-- hover
	b.hover.dictionary,
}

function M.setup(opts)
	nls.setup({
		debug = true,
		debounce = 150,
		save_after_format = false,
		sources = sources,
		on_attach = opts.on_attach,
		root_dir = nls_utils.root_pattern(".git"),
	})
end

return M
