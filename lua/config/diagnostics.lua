local M = {}

function M.setup()
    local trouble = require("trouble")

    local map = vim.keymap.set

    map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
    map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix List (Trouble)" })
    map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Local List (Trouble)" })
    map(
        "n",
        "gr",
        "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
        { desc = "LSP Definitions / references / ... (Trouble)" }
    )
    trouble.setup({})
end

return M
