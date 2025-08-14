local M = {}
function M.alduin()
    local alduin = require("alduin")
    alduin.setup({
        colors = {
            terminal_colors = true,
            inverse = true,
        },
    })
end
function M.setup()
    M.alduin()
    vim.opt.termguicolors = true
    vim.cmd("colorscheme alduin")
end
return M
