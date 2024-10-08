local ls = require("luasnip")
local types = require("luasnip.util.types")
local textnode = ls.text_node
local funcnode = ls.function_node
local snippet = ls.s

ls.config.set_config({
	-- This tells LuaSnip to remember to keep around the last snippet.
	-- You can jump back into it even if you move outside of the selection
	history = true,

	-- This one is cool cause if you have dynamic snippets, it updates as you type!
	updateevents = "TextChanged,TextChangedI",

	-- Autosnippets:
	enable_autosnippets = true,

	-- Crazy highlights!!
	-- #vid3
	-- ext_opts = nil,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "<-", "Error" } },
			},
		},
	},
})

ls.add_snippets("all", {
	snippet({ trig = "date" }, {
		funcnode(function()
			return string.format(string.gsub(vim.bo.commentstring, "%%s", " %%s"), os.date())
		end, {}),
	}),
})
