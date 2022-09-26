local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local textnode = ls.text_node
local insertnode = ls.insert_node
local snippet = ls.s

ls.add_snippets("python", {
	snippet({ trig = "#!" }, {
		textnode("#!/usr/bin/env python"),
	}),
	snippet({ trig = "mfi" , name= "module: from import"}, {
		textnode("from "),
		insertnode(1, "<module>"),
		textnode(" import "),
		insertnode(0, "<object>"),
	}),
	snippet({ trig = "mi", name= "module: import" }, {
		textnode("import "),
		insertnode(0, "<object>"),
	}),
	snippet(
		{ trig = "cd", name = "comment: docstring" },
		fmt(
			[[
				"""
				{}
				"""
				{}
			]],
			{ insertnode(1), insertnode(0) }
		)
	),
	snippet(
		{ trig = "mainf", name = "python (main) file" },
		fmt(
			[[
				"""
				{}
				"""
				import logging
				logger = logging.getLogger(__name__)
				def main():
				  """
				  {}
				  """
				  {}
				if __name__ == "__main__":
				    main()
			]],
			{ insertnode(1), insertnode(2), insertnode(0) }
		)
	),
	snippet(
		{ trig = "fd", name = "function definition" },
		fmt("def {}({}):\n    {}\n\n{}", { insertnode(1), insertnode(2), insertnode(3), insertnode(0) })
	),
	snippet({
		trig = "dbp",
		name = "debug: ipdb breakpoint",
	}, textnode("import ipdb; ipdb.set_trace() # TODO: Remove")),
	snippet(
		{ trig = "tc", name = "type class" },
		fmt("class {}:\n    {}\n\n{}", { insertnode(1), insertnode(2), insertnode(0) })
	),
})
