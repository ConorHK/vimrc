local M = {}

function M.setup()
    -- Nix filetype settings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "nix",
        callback = function()
            vim.bo.shiftwidth = 2
            vim.bo.expandtab = true
            vim.bo.tabstop = 8
            vim.bo.softtabstop = 0
        end,
    })

    -- Java filetype settings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java", "lua" },
        callback = function()
            vim.bo.shiftwidth = 4
            vim.bo.expandtab = true
            vim.bo.tabstop = 4
            vim.bo.softtabstop = 0
        end,
    })

    -- Python filetype settings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
            vim.wo.colorcolumn = "120"
        end,
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "brazil-config",
        callback = function()
            vim.bo.shiftwidth = 4
            vim.bo.expandtab = true
            vim.bo.tabstop = 4
            vim.bo.softtabstop = 0
        end,
    })
end

return M
