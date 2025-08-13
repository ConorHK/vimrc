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
	"diagnostics",
	"display",
	"filesystem",
	"ftplugin",
	"git",
	"indent",
	"lsp",
	"snacks",
	"snippets",
	"treesitter",
	"yank",
	"zellij",
}

for _, plugin in ipairs(plugin_modules) do
	local import = string.format("config.%s", plugin)
	local success, module = pcall(require, import)
	if success then
		module.setup()
	end
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
}

for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end
