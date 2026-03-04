local M = {}

local function git_url(lines_arg)
    local file = vim.fn.expand("%:p")
    local dir = vim.fn.fnamemodify(file, ":h")
    local repo_root = vim.trim(vim.fn.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }))
    if vim.v.shell_error ~= 0 then
        vim.notify("git-url: not in a git repo", vim.log.levels.ERROR)
        return
    end
    local rel_file = file:sub(#repo_root + 2)
    local cmd = { "git", "-C", dir, "url", rel_file }
    if lines_arg then
        table.insert(cmd, lines_arg)
    end
    local result = vim.trim(vim.fn.system(cmd))
    if vim.v.shell_error ~= 0 then
        vim.notify("git-url: " .. result, vim.log.levels.ERROR)
        return
    end
    local b64 = vim.base64.encode(result)
    io.stdout:write(string.format("\027]52;c;%s\a", b64))
    print(result)
end

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
        git_url(tostring(vim.fn.line(".")))
    end, { silent = true, noremap = true })
    vim.keymap.set("v", "<leader>cu", function()
        local start = vim.fn.line("v")
        local finish = vim.fn.line(".")
        if start > finish then
            start, finish = finish, start
        end
        git_url(start .. "-" .. finish)
    end, { silent = true, noremap = true })
end
return M
