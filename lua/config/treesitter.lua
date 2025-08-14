local M = {}
function M.setup()
    local ts_config = require("nvim-treesitter.configs")

    ---@diagnostic disable-next-line: missing-fields
    local opts = {
        indent = {
            enable = true,
            disable = {
                "nix",
                "python",
            },
        },
        highlight = {
            enable = true,
            disable = {
                "nix",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["am"] = "@comment.outer",
                    ["im"] = "@comment.inner",
                    ["ao"] = "@loop.outer",
                    ["io"] = "@loop.inner",
                },
            },
        },
    }

    -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
    vim.defer_fn(function()
        ts_config.setup(opts)
    end, 0)
end

return M
