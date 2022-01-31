local opt = vim.opt
local cmd = vim.cmd
local indent = 4

-- splits open at bottom and right
--
opt.splitbelow = true
opt.splitright = true

-- window 
opt.hidden = true
opt.fillchars.vert = "│"

-- remove intro
opt.shortmess:append "sI"

opt.cmdheight = 1
opt.showmode = false

-- spellcheck
opt.spelllang = "en_gb"

-- no case-sensitive search unless uppercase is present
opt.ignorecase = true
opt.smartcase = true

-- enable mouse scroll
opt.mouse = "a"

-- statusline config
opt.statusline = "%F"

-- ensure lines break on whole words
opt.linebreak = true

-- ensure cursor stays away from screen edge
opt.scrolloff = 3
opt.foldcolumn = "1"

-- tab settings
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true
opt.shiftround = true

-- matching braces/tags
opt.showmatch = true

-- turn on detection for filetypes, indentation files and plugin files
cmd("filetype plugin indent on")

-- share yank buffer with system clipboard
opt.clipboard = "unnamed,unnamedplus"

-- enable column position with ctrl-g
opt.ruler = false

-- persistent undo
opt.undofile = true

-- switch syntax highlighting on
cmd("syntax on")

-- colourscheme
cmd("colorscheme alduin")
opt.termguicolors = true

-- don't write to the ShaDa file on startup
opt.shadafile = "NONE"

-- updatetime for cursorhold
opt.updatetime = 200

-- relative line numbers
opt.number = true

opt.formatoptions = 'tcrqnj'
-- o.formatoptions = o.formatoptions
--                    + 't'    -- auto-wrap text using textwidth
--                    + 'c'    -- auto-wrap comments using textwidth
--                    + 'r'    -- auto insert comment leader on pressing enter
--                    - 'o'    -- don't insert comment leader on pressing o
--                    + 'q'    -- format comments with gq
--                    - 'a'    -- don't autoformat the paragraphs (use some formatter instead)
--                    + 'n'    -- autoformat numbered list
--                    - '2'    -- I am a programmer and not a writer
--                    + 'j'    -- Join comments smartly

-- Packer Commands
cmd("command! WhatHighlight :call util#syntax_stack()")
cmd("command! PackerInstall packadd packer.nvim | lua require('plugins').install()")
cmd("command! PackerUpdate packadd packer.nvim | lua require('plugins').update()")
cmd("command! PackerSync packadd packer.nvim | lua require('plugins').sync()")
cmd("command! PackerClean packadd packer.nvim | lua require('plugins').clean()")
cmd("command! PackerCompile packadd packer.nvim | lua require('plugins').compile()")

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
