local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

map("", "<Space>", "<Nop>", default_opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local plugin_modules = {
        "autocomplete",
        "colorscheme",
        "commenting",
        "diagnostics",
        "filesystem",
        "general",
        "git",
        "indent",
        "lsp",
        "movement",
        "snippets",
        "startup",
        "surround",
        "telescope",
        "tmux",
        "treesitter",
        "yank",
}

for _, plugin in ipairs(plugin_modules) do
	if nixCats(plugin) then
		local success, module = pcall(require, string.format("config.%s", plugin))
		if success then
			print("Successfully loaded:", plugin)
			module.setup()
		else
			print("Failed to load:", plugin, "Error:", module)
		end
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
