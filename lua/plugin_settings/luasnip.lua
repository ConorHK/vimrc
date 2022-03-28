local ls = require("luasnip")
local types = require("luasnip.util.types")
local textnode = ls.text_node
local funcnode = ls.function_node
local insertnode = ls.insert_node
local snippetnode = ls.snippet_node
local indent_snippetnode = ls.indent_snippet_node
local choicenode = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local events = require("luasnip.util.events")

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

vim.keymap.set({ "i", "s" }, "<c-w>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

local snippets = {}

snippets.all = {
	snippet({ trig = "date" }, {
		funcnode(function()
			return string.format(string.gsub(vim.bo.commentstring, "%%s", " %%s"), os.date())
		end, {}),
	}),
}

snippets.python = {
	snippet({ trig = "#!" }, {
		textnode("#!/usr/bin/env python"),
	}),
	snippet({ trig = "fim" }, {
		textnode("from "),
		insertnode(1, "<module>"),
		textnode(" import "),
		insertnode(0, "<object>"),
	}),
	snippet({ trig = "im" }, {
		textnode("import "),
		insertnode(0, "<object>"),
	}),

	snippet({ trig = "def" }, {
		textnode("def "),
		insertnode(1, "<function>"),
		textnode("("),
	}),
}

snippets.sh = {
	snippet({ trig = "#!" }, {
		textnode("#!/usr/bin/env sh"),
	}),
}

ls.snippets = snippets
