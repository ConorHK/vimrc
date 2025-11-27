local M = {}

function M.setup()
    local smear = require("smear_cursor")
    smear.setup({
        legacy_computing_symbols_support = true,
    })
    local no_neck_pain = require("no-neck-pain")
    no_neck_pain.setup({})
    vim.keymap.set("n", "<leader>ct", "<cmd>NoNeckPain<CR>")
    vim.keymap.set("n", "<leader>cs", "<cmd>NoNeckPainScratchPad<CR>")
end

return M
