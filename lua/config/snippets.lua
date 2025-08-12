local M = {}
function M.setup()
	local ls = require("luasnip")
	local types = require("luasnip.util.types")

	ls.setup({
		enable_autosnippets = true,
		history = true,
		updateevents = "TextChanged,TextChangedI",
		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { "<-", "Error" } },
				},
			},
		},
	})

	local snippets_path = vim.fn.stdpath("config") .. "/snippets/"
	require("luasnip.loaders.from_lua").load({ paths = snippets_path })

	vim.keymap.set("i", "<C-e>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true })
end
return M
