local M = {}
function M.setup()
    local api = vim.api

    local modes = {
        ["n"] = "NORMAL",
        ["no"] = "NORMAL",
        ["v"] = "VISUAL",
        ["V"] = "VISUAL LINE",
        [""] = "VISUAL BLOCK",
        ["s"] = "SELECT",
        ["S"] = "SELECT LINE",
        [""] = "SELECT BLOCK",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rv"] = "VISUAL REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "VIM EX",
        ["ce"] = "EX",
        ["r"] = "PROMPT",
        ["rm"] = "MOAR",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
    }

    local function color()
        local mode = api.nvim_get_mode().mode
        local mode_color = "%#Normal#"
        if mode == "n" then
            mode_color = "%#StatusNormal#"
        elseif mode == "i" or mode == "ic" then
            mode_color = "%#StatusInsert#"
        elseif mode == "v" or mode == "V" or mode == "" then
            mode_color = "%#StatusVisual#"
        elseif mode == "R" then
            mode_color = "%#StatusReplace#"
        elseif mode == "c" then
            mode_color = "%#StatusCommand#"
        elseif mode == "t" then
            mode_color = "%#StatusTerminal#"
        end
        return mode_color
    end

    -- StatusLine Modes
    Statusline = {}

    Statusline.active = function()
        return table.concat({
            color(), -- mode colors
            string.format(" %s ", modes[api.nvim_get_mode().mode]):upper(), -- mode
            "%#StatusLine#", -- middle color
            " %f ", -- file name
            "%=", -- right align
            " %Y ", -- file type
            color(), -- mode colors
            " %c ", -- line, column
        })
    end

    function Statusline.inactive()
        return "%#StatusInactive# %f "
    end

    function Statusline.short()
        return "%#Normal#"
    end

    vim.opt.fillchars = {
        horiz = "━",
        horizup = "┻",
        horizdown = "┳",
        vert = "┃",
        vertleft = "┫",
        vertright = "┣",
        verthoriz = "╋",
    }

    -- Execute statusline
    local group = vim.api.nvim_create_augroup("Statusline", { clear = true })

    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        group = group,
        pattern = "*",
        callback = function()
            vim.wo.statusline = "%!v:lua.Statusline.active()"
        end,
    })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        group = group,
        pattern = "*",
        callback = function()
            vim.wo.statusline = "%!v:lua.Statusline.inactive()"
        end,
    })

    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FileType" }, {
        group = group,
        pattern = { "NvimTree", "terminal" },
        callback = function()
            vim.wo.statusline = "%!v:lua.Statusline.short()"
        end,
    })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "FileType" }, {
        group = group,
        pattern = { "NvimTree", "terminal" },
        callback = function()
            vim.wo.statusline = "%!v:lua.Statusline.short()"
        end,
    })
end
return M
