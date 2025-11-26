local M = {}

local centering_enabled = false
local statuscolumn_default = "  "
local autocmd_id = nil

local function toggle_centering()
    centering_enabled = not centering_enabled
    
    if centering_enabled then
        autocmd_id = vim.api.nvim_create_autocmd({
            'BufEnter', 'BufWinEnter', 'BufWinLeave', 'WinEnter', 'WinLeave', 'WinResized', 'VimResized'
        }, {
            callback = function()
                local full_screen = vim.o.columns
                local winwidth = vim.api.nvim_win_get_width(0)
                if winwidth > (full_screen / 2) then
                    vim.o.statuscolumn = string.rep(" ", (full_screen - 100) / 2) .. statuscolumn_default
                else
                    vim.o.statuscolumn = statuscolumn_default
                end
            end,
        })
    else
        if autocmd_id then
            vim.api.nvim_del_autocmd(autocmd_id)
            autocmd_id = nil
        end
        vim.o.statuscolumn = statuscolumn_default
    end
end

function M.setup()
    local map = vim.keymap.set

    local default_opts = { noremap = true, silent = true }

    local function cnoreabbrev(command)
        vim.api.nvim_command("cnoreabbrev " .. command)
    end

    local has_zellij = pcall(require, "zellij-nav")
    if not has_zellij then
        -- split sane bindings
        map("n", "<c-Left>", "<c-w>h", default_opts)
        map("n", "<c-Down>", "<c-w>j", default_opts)
        map("n", "<c-Up>", "<c-w>k", default_opts)
        map("n", "<c-Right>", "<c-w>l", default_opts)

        map("n", "<c-h>", "<c-w>h", default_opts)
        map("n", "<c-j>", "<c-w>j", default_opts)
        map("n", "<c-k>", "<c-w>k", default_opts)
        map("n", "<c-l>", "<c-w>l", default_opts)
    end

    -- quick yanking to the end of the line
    map("n", "Y", "y$", default_opts)

    -- clear highlight
    map("n", "<esc><esc>", ":noh<return>", default_opts)

    -- toggle centering
    map("n", "<leader>c", toggle_centering, default_opts)

    -- misspellings
    cnoreabbrev("Qa qa")
    cnoreabbrev("Q q")
    cnoreabbrev("Qall qall")
    cnoreabbrev("Q! q!")
    cnoreabbrev("Qall! qall!")
    cnoreabbrev("qQ q@")
    cnoreabbrev("Bd bd")
    cnoreabbrev("bD bd")
    cnoreabbrev("qw wq")
    cnoreabbrev("Wq wq")
    cnoreabbrev("WQ wq")
    cnoreabbrev("Wq wq")
    cnoreabbrev("Wa wa")
    cnoreabbrev("wQ wq")
    cnoreabbrev("W w")
    cnoreabbrev("W! w!")
end
return M
