local M = {}
function M.setup()
	local ls = require("luasnip")
	local types = require("luasnip.util.types")
	local fmt = require("luasnip.extras.fmt").fmt
	local textnode = ls.text_node
	local insertnode = ls.insert_node
	local functionnode = ls.function_node
	local snippet = ls.s

	local function copy(args)
		return args[1]
	end

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
end
return M
