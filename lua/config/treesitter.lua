local M = {}

function M.setup()
    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "*" },
        callback = function(ev)
            if vim.api.nvim_buf_is_valid(ev.buf) and vim.api.nvim_buf_is_loaded(ev.buf) then
                local ok, parser = pcall(vim.treesitter.get_parser, ev.buf)
                if ok and parser then
                    vim.treesitter.start(ev.buf)
                end
            end
        end,
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        callback = function(ev)
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(ev.buf) and vim.api.nvim_buf_is_loaded(ev.buf) then
                    local filetype = vim.bo[ev.buf].filetype
                    local skip_indent = { nix = true, python = true }
                    if not skip_indent[filetype] then
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end
            end)
        end,
    })

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldlevel = 99

    vim.g.textobjects_select_enable = true
    vim.g.textobjects_select_lookahead = true

    local keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["am"] = "@comment.outer",
        ["im"] = "@comment.inner",
        ["ao"] = "@loop.outer",
        ["io"] = "@loop.inner",
    }

    for keymap, textobject in pairs(keymaps) do
        vim.keymap.set("x", keymap, function()
            require("nvim-treesitter.textobjects.select").select_textobject(nil, textobject)
        end, { noremap = true, silent = true })
    end
end

return M
