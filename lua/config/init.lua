local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

map("", "<Space>", "<Nop>", default_opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local plugin_modules = {
    "options",
    "keymaps",
    "statusline",

    "autocomplete",
    "colorscheme",
    "dap",
    "diagnostics",
    "display",
    "filesystem",
    "ftplugin",
    "git",
    "indent",
    "java",
    "lsp",
    "ninetynine",
    "snacks",
    "snippets",
    "statuscolumn",
    "treesitter",
    "yank",
    "zellij",
}

for _, plugin in ipairs(plugin_modules) do
    local import = string.format("config.%s", plugin)
    require(import).setup()
end

-- disable unused remote plugin providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- override legacy nvim-treesitter healthcheck (built-in treesitter is used directly,
-- parsers come from Nix, so the install-dir/tree-sitter-cli checks are not relevant)
package.preload["nvim-treesitter.health"] = function()
    return {
        check = function()
            vim.health.start("nvim-treesitter")
            vim.health.ok("Parsers managed by Nix; legacy install checks skipped.")
        end,
    }
end

-- disable builtin vim plugins
local disabled_built_ins = {
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end
