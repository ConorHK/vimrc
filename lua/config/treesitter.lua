local M = {}

function M.setup()
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { '*' },
        callback = function()
            if vim.treesitter.get_parser(nil, nil, { error = false }) then
                vim.treesitter.start()
            end
        end,
    })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = { '*' },
        callback = function(ev)
            local filetype = ev.match
            if filetype ~= 'nix' or filetype ~= 'python' then
                vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })

    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.opt.foldlevel = 99

    vim.g.textobjects_select_enable = true
    vim.g.textobjects_select_lookahead = true
    
    local keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['am'] = '@comment.outer',
        ['im'] = '@comment.inner',
        ['ao'] = '@loop.outer',
        ['io'] = '@loop.inner',
    }
    
    for keymap, textobject in pairs(keymaps) do
        vim.keymap.set('x', keymap, function()
            require('nvim-treesitter.textobjects.select').select_textobject(nil, textobject)
        end, { noremap = true, silent = true })
    end
end

return M
