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
    vim.keymap.set("n", "<leader>cu", function()
        local file = vim.fn.expand("%:p")
        local dir = vim.fn.fnamemodify(file, ":h")
        local line = vim.fn.line(".")
        local repo_root = vim.trim(vim.fn.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }))
        if vim.v.shell_error ~= 0 then
            vim.notify("git-url: not in a git repo", vim.log.levels.ERROR)
            return
        end
        local rel_file = file:sub(#repo_root + 2)
        local result = vim.trim(vim.fn.system({ "git", "-C", dir, "url", rel_file, tostring(line) }))
        if vim.v.shell_error ~= 0 then
            vim.notify("git-url: " .. result, vim.log.levels.ERROR)
            return
        end
        local b64 = vim.base64.encode(result)
        io.stdout:write(string.format("\027]52;c;%s\a", b64))
        print(result)
    end, { silent = true, noremap = true })
end
return M
