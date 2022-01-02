local utils = require("utils")

-- dereference all functions
local nnoremap = utils.nnoremap
local inoremap = utils.inoremap
local vnoremap = utils.vnoremap
local nmap = utils.nmap

-- Helper functions to write create abbreveations
local function cnoreabbrev(command)
	vim.api.nvim_command("cnoreabbrev " .. command)
end

-- set leader key
vim.g.mapleader = " "

-- split sane bindings
nmap("<c-Left>", "<c-w>h")
nmap("<c-Down>", "<c-w>j")
nmap("<c-Up>", "<c-w>k")
nmap("<c-Right>", "<c-w>l")

nmap("<c-h>", "<c-w>h")
nmap("<c-j>", "<c-w>j")
nmap("<c-k>", "<c-w>k")
nmap("<c-l>", "<c-w>l")

-- misspellings
cnoreabbrev("Qa qa")
cnoreabbrev("Q q")
cnoreabbrev("Qall qall")
cnoreabbrev("Q! q!")
cnoreabbrev("Qall! qall!")
cnoreabbrev("qQ q@")
cnoreabbrev("Bd bd")
cnoreabbrev("bD bd")
cnoreabbrev("qw wq")
cnoreabbrev("Wq wq")
cnoreabbrev("WQ wq")
cnoreabbrev("Wq wq")
cnoreabbrev("Wa wa")
cnoreabbrev("wQ wq")
cnoreabbrev("W w")
cnoreabbrev("W! w!")

-- quick yanking to the end of the line
nmap("Y", "y$")

-- clear highlight
nmap("<esc><esc>", ":noh<return>")

-- mappings to move lines
nnoremap("<A-j>", ":m .+1<CR>==")
nnoremap("<A-k>", ":m .-2<CR>==")
inoremap("<A-j>", "<esc>:m .+1<CR>==")
inoremap("<A-v>", "<esc>:m .-2<CR>==")
vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
vnoremap("<A-k>", ":m '<-2<CR>gv=gv")
