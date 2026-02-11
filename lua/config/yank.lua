local M = {}
function M.setup()
    local smartyank = require("smartyank")

    smartyank.setup({})
    vim.api.nvim_create_user_command("CopyFilePath", function()
        local path = vim.fn.expand("%:p")
        vim.fn.setreg("+", path)
        print("File path copied: " .. path)
    end, {})
    vim.keymap.set("n", "<leader>cp", ":CopyFilePath<CR>", { silent = true, noremap = true })
end
return M
