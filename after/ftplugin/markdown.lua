local present, ls = pcall(require, "luasnip")
if not present then
	return
end
local fmt = require("luasnip.extras.fmt").fmt
local textnode = ls.text_node
local insertnode = ls.insert_node
local functionnode = ls.function_node
local snippet = ls.s

local date = function()
	return { os.date("%Y-%m-%d") }
end

ls.add_snippets("all", { --TODO: fix
	snippet({ trig = "link", name = "hyperlink", dscr = "Create markdown link [txt](url)" }, {
		textnode("["),
		insertnode(1, "<text>"),
		textnode("]("),
		insertnode(0, "<link>"),
		textnode(")"),
	}),
	snippet({
		trig = "codewrap",
		namr = "markdown_code_wrap",
		dscr = "Create markdown code block from existing text",
	}, {
		textnode("``` "),
		insertnode(1, "Language"),
		textnode({ "", "" }),
		functionnode(function(_, snip)
			local tmp = {}
			tmp = snip.env.TM_SELECTED_TEXT
			tmp[0] = nil
			return tmp or {}
		end, {}),
		textnode({ "", "```", "" }),
		insertnode(0),
	}),
	snippet({
		trig = "codeempty",
		namr = "markdown_code_empty",
		dscr = "Create empty markdown code block",
	}, {
		textnode("``` "),
		insertnode(1, "Language"),
		textnode({ "", "" }),
		insertnode(2, "Content"),
		textnode({ "", "```", "" }),
		insertnode(0),
	}),
	snippet({
		trig = "date",
		namr = "Date",
		dscr = "Date in the form of YYYY-MM-DD",
	}, {
		functionnode(date, {}),
	}),
})
