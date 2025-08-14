local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
    s({
        trig = "ipdb",
        name = "debug: ipdb breakpoint",
    }, t("import ipdb; ipdb.set_trace()  # TODO: remove")),

    s({
        trig = "pdb",
        name = "debug: pdb breakpoint",
    }, t("import pdb; pdb.set_trace()  # TODO: remove")),
}
