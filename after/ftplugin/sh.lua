local present, ls = pcall(require, "luasnip")
if not present then
	return
end
local textnode = ls.text_node
local snippet = ls.s

ls.add_snippets("sh", {
	snippet({ trig = "#!" }, {
		textnode("#!/usr/bin/env sh"),
	}),
})
