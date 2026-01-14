local M = {}

function M.setup()
    -- Nix filetype settings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "nix",
        callback = function()
            vim.opt.shiftwidth = 2
            vim.opt.expandtab = true
            vim.opt.tabstop = 8
            vim.opt.softtabstop = 0
        end,
    })

    -- Java filetype settings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java", "lua" },
        callback = function()
            vim.opt.shiftwidth = 4
            vim.opt.expandtab = true
            vim.opt.tabstop = 4
            vim.opt.softtabstop = 0
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
            vim.opt.shiftwidth = 4
            vim.opt.expandtab = true
            vim.opt.tabstop = 4
            vim.opt.softtabstop = 0
        end,
    })
end

return M
