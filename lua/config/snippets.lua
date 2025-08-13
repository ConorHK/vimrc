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
	print("Loading snippets from:", snippets_path)
	print("Path exists:", vim.fn.isdirectory(snippets_path))

	require("luasnip.loaders.from_lua").load({ paths = snippets_path })

	-- Debug: print loaded snippets
	vim.defer_fn(function()
		local snippets = ls.get_snippets("python")
		print("Loaded python snippets:", #snippets)
		for _, snip in ipairs(snippets) do
			print("  - " .. snip.trigger)
		end
	end, 100)

	vim.keymap.set("i", "<C-e>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true })
end
return M
