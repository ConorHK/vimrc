local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

map("", "<Space>", "<Nop>", default_opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local plugin_modules = {
	"snippets",
	"autocomplete",
	"display",
	"colorscheme",
	"commenting",
	"diagnostics",
	"filesystem",
	"general",
	"git",
	"indent",
	"lsp",
	"movement",
	"surround",
	"telescope",
	"tmux",
	"treesitter",
	"yank",
	"zellij",
}

for _, plugin in ipairs(plugin_modules) do
	if nixCats(plugin) then
		local import = string.format("config.%s", plugin)
		-- vim.notify("Loading: " .. import, vim.log.levels.DEBUG)
		local success, module = pcall(require, import)
		if success then
			module.setup()
			-- vim.notify("Successfully loaded: " .. plugin, vim.log.levels.DEBUG)
		else
			-- vim.notify("Failed to load: " .. plugin .. ";Error:" .. module, vim.log.levels.ERROR)
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
