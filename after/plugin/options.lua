local opt = vim.opt
local cmd = vim.cmd
local g = vim.g

-- splits open at bottom and right
opt.splitbelow = true
opt.splitright = true

-- window
opt.hidden = true
opt.fillchars.vert = "│"

-- remove intro
opt.shortmess:append("sI")

opt.cmdheight = 0
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
opt.laststatus = 0

-- ensure lines break on whole words
opt.linebreak = true

-- ensure cursor stays away from screen edge
opt.scrolloff = 3
opt.foldcolumn = "1"

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

-- time in milliseconds to wait for a mapped sequence to complete.
opt.timeoutlen = 500

-- hybrid relative line numbers
opt.number = true
opt.relativenumber = true

opt.formatoptions = "tcrqnj"
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

-- highlight line with cursor
opt.cursorline = true

-- better netrw
g.netrw_banner = 0 -- Hide banner
g.netrw_browse_split = 4 -- Open in previous window
g.netrw_altv = 1 -- Open with right splitting
g.netrw_liststyle = 3 -- Tree-style view
g.netrw_list_hide = (vim.fn["netrw_gitignore#Hide"]()) .. [[,\(^\|\s\s\)\zs\.\S\+]] -- use .gitignore
