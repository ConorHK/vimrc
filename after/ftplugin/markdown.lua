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

