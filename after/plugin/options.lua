local opt = vim.opt
local cmd = vim.cmd

-- splits open at bottom and right
--
opt.splitbelow = true
opt.splitright = true

-- window
opt.hidden = true
opt.fillchars.vert = "│"

-- remove intro
opt.shortmess:append("sI")

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
opt.laststatus = 2

-- ensure lines break on whole words
opt.linebreak = true

-- ensure cursor stays away from screen edge
opt.scrolloff = 3
opt.foldcolumn = "0"

-- matching braces/tags
opt.showmatch = true

-- turn on detection for filetypes, indentation files and plugin files
cmd("filetype plugin indent on")

-- enable column position with ctrl-g
opt.ruler = false

-- persistent undo
opt.undofile = true

-- switch syntax highlighting on
cmd("syntax on")

-- don't write to the ShaDa file on startup
opt.shadafile = "NONE"

-- updatetime for cursorhold
opt.updatetime = 500

-- hybrid relative line numbers
opt.number = true
opt.relativenumber = true

opt.formatoptions:remove("o")

-- highlight line with cursor
opt.cursorline = true

-- LSP signs in number column
opt.signcolumn = "number"

-- Disable smartindent
opt.smartindent = false

-- list chars
opt.list = true
opt.listchars = { tab = "» " ,extends = "›", precedes = "‹", nbsp = "·", trail = "·", space = "·", eol = "↲"}
opt.showbreak="↪"
