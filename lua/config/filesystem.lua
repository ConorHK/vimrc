local M = {}

function M.oil()
    local oil = require("oil")
    oil.setup({
        columns = { "icon" },
        keymaps = {
            ["<C-h>"] = false,
            ["<C-l>"] = false,
            ["<Leader>p"] = "actions.preview",
        },
        view_options = {
            show_hidden = true,
        },
        win_options = {
            signcolumn = "yes:1",
        },
    })

    -- Open parent directory in current window
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

    -- Open parent directory in floating window
    vim.keymap.set("n", "<space>-", require("oil").toggle_float)
end

function M.setup()
    M.oil()
end

return M
