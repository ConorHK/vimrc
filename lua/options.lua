local utils = require("utils")
local cmd = vim.cmd
local indent = 4
-- enable autocompletion utils.opt("o", "wildmode", "list:longest")

-- splits open at bottom and right
utils.opt("o", "splitbelow", true)
utils.opt("o", "splitright", true)

-- spellcheck
utils.opt("b", "spelllang", "en_gb")

-- no case-sensitive search unless uppercase is present
utils.opt("o", "ignorecase", true)
utils.opt("o", "smartcase", true)

-- enable mouse scroll
utils.opt("o", "mouse", "a")

-- statusline config
utils.opt("o", "statusline", "%F")

-- ensure lines break on whole words
utils.opt("o", "linebreak", true)

-- ensure cursor stays away from screen edge
utils.opt("o", "scrolloff", 3)
-- utils.opt("o", "foldcolumn", "1")

-- tab settings
utils.opt("o", "expandtab", true)
utils.opt("o", "tabstop", 2)
utils.opt("o", "softtabstop", 2)
utils.opt("o", "shiftwidth", 2)
utils.opt("o", "smarttab", true)
utils.opt("o", "autoindent", true)
utils.opt("o", "smartindent", true)
utils.opt("o", "shiftround", true)

-- matching braces/tags
utils.opt("o", "showmatch", true)

-- turn on detection for filetypes, indentation files and plugin files
cmd("filetype plugin indent on")

-- share yank buffer with system clipboard
utils.opt("o", "clipboard", "unnamed,unnamedplus")

-- enable column position with ctrl-g
utils.opt("o", "ruler", false)

-- persistent undo
utils.opt("o", "undofile", true)

-- switch syntax highlighting on
cmd("syntax on")

-- colourscheme
cmd("colorscheme alduin")
utils.opt("o", "termguicolors", true)

-- don't write to the ShaDa file on startup
utils.opt("o", "shadafile", "NONE")

-- updatetime for cursorhold
utils.opt("o", "updatetime", 200)

-- Packer Commands
cmd("command! WhatHighlight :call util#syntax_stack()")
cmd("command! PackerInstall packadd packer.nvim | lua require('plugins').install()")
cmd("command! PackerUpdate packadd packer.nvim | lua require('plugins').update()")
cmd("command! PackerSync packadd packer.nvim | lua require('plugins').sync()")
cmd("command! PackerClean packadd packer.nvim | lua require('plugins').clean()")
cmd("command! PackerCompile packadd packer.nvim | lua require('plugins').compile()")

-- disable builtin vim plugins
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
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
