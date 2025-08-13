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

	-- Find snippets in the runtime path (works with both Nix package and local dev)
	local snippets_paths = {}
	for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
		local snippets_dir = path .. "/snippets"
		if vim.fn.isdirectory(snippets_dir) == 1 then
			table.insert(snippets_paths, snippets_dir)
		end
	end

	if #snippets_paths > 0 then
		require("luasnip.loaders.from_lua").load({ paths = snippets_paths })
	end

	vim.keymap.set("i", "<C-e>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true })
end
return M
