local opt = vim.opt
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local textnode = ls.text_node
local insertnode = ls.insert_node
local functionnode = ls.function_node
local snippet = ls.s

ls.add_snippets("python", {
	snippet({ trig = "#!" }, {
		textnode("#!/usr/bin/env python"),
	}),
	snippet({ trig = "importf", name = "module: from import" }, {
		textnode("from "),
		insertnode(1, "<module>"),
		textnode(" import "),
		insertnode(0, "<object>"),
	}),
	snippet({ trig = "import", name = "module: import" }, {
		textnode("import "),
		insertnode(0, "<object>"),
	}),
	snippet(
		{ trig = "doc", name = "comment: docstring" },
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
		{ trig = "main", name = "python (main) file" },
		fmt(
			[[
				"""{}"""
				from __future__ import annotations

				import logging
				logger = logging.getLogger(__name__)


				def main() -> None:
				    """Driver"""
				    {}

				if __name__ == "__main__":
				    main()

			]],
			{ insertnode(1), insertnode(0) }
		)
	),
	snippet(
		{ trig = "testboil", name = "Testing boilerplate" },
		fmt(
		"test_cases = [\n" ..
		"    {}\n" ..
		"]\n" ..
		[[

for test_case in test_cases:
    result = {}(test_case.input)
    print(f"Output  : {{result}}")
    print(f"Expected: {{test_case.output}}")
    print(f"Result matches expected: {{result == test_case.output }}")
    print("-------------------------------")
		]],
			{ insertnode(1), insertnode(0) }
		)
	),
	snippet(
		{ trig = "tcc", name = "Test case boilerplate class" },
		fmt(
			[[
				from dataclasses import dataclass

				@dataclass
				class TestCase:
				    input: {}
				    output: {}
					
			]],
			{ insertnode(1), insertnode(0) }
		)
	),
	snippet(
		{ trig = "tc", name = "Test case boilerplate" },
		fmt(
			[[
				TestCase(input={}, output={}),
			]],
			{ insertnode(1), insertnode(0)}
		)
	),
	snippet(
		{ trig = "func", name = "function definition" },
		fmt("def {}({}) -> {}:\n    pass", { insertnode(1), insertnode(2), insertnode(0)})
	),
	snippet({
		trig = "ipdb",
		name = "debug: ipdb breakpoint",
	}, textnode("import ipdb; ipdb.set_trace()  # TODO: remove")),
	snippet({
		trig = "pdb",
		name = "debug: pdb breakpoint",
	}, textnode("import pdb; pdb.set_trace()  # TODO: remove")),
	snippet(
		{ trig = "class", name = "type class" },
		fmt("class {}:\n    {}\n\n{}", { insertnode(1), insertnode(2), insertnode(0) })
	),
})

-- colourcolumn for black formatting
opt.colorcolumn = "120"
