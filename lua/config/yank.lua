local M = {}
function M.setup()
    local smartyank = require("smartyank")

    smartyank.setup({})
    vim.api.nvim_create_user_command("CopyFilePath", function()
        local path = vim.fn.expand("%:p")
        local b64 = vim.base64.encode(path)
        io.stdout:write(string.format("\027]52;c;%s\a", b64))
        print("File path copied: " .. path)
    end, {})
    vim.keymap.set("n", "<leader>cp", ":CopyFilePath<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>cr", function()
        local file = vim.fn.expand("%:p")
        local line = vim.fn.line(".")
        local result = vim.fn.system({ "git-url", file, tostring(line) })
        if vim.v.shell_error ~= 0 then
            vim.notify("git-url: " .. result, vim.log.levels.ERROR)
        end
    end, { silent = true, noremap = true })
end
return M
