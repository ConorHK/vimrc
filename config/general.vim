" ensure compatible mode is disabled
set nocompatible

" encoding
set encoding=UTF-8

" turn on detection for filetypes, indentation files and plugin files
filetype plugin indent on

" set leader key
let mapleader=" "
let maplocalleader=" "

" longer leader key timeout
set timeout timeoutlen=1500

" enable autocompletion
set wildmode=longest,list,full

" splits open at bottom and right
set splitbelow splitright

" split sane bindings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" spellcheck
autocmd FileType text,markdown setlocal spell
set spelllang=en_gb

" don't automatically collapse markdown
set conceallevel=0

" automatically re-read file if a change was made outside vim
set autoread

" no case-sensitive search unless uppercase is present
set ignorecase
set smartcase

" enable mouse scroll
set mouse=a

" allow new buffer to be opened without saving current
set hidden

" statusline config
set statusline+=%F
set cmdheight=1
set noshowmode
set noshowcmd
set shortmess+=F

" ensure lines break on whole words
set linebreak

" ensure cursor stays away from screen edge
set scrolloff=3
set foldcolumn=1

" tab settings
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set autoindent
set smartindent
set shiftround

" matching braces/tags
set showmatch

" line wrapping
set wrap

" share yank buffer with system clipboard
set clipboard=unnamedplus

" show next 3 lines while scrolling
set scrolloff=3

" jump to last known position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" relative line numbers
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

" disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" save files as sudo on files that require root permission
cmap w!! w !sudo tee > /dev/null %

" clear highlight
nnoremap <esc><esc> :noh<return>

" mistype rebind
command Q q

" lower updatetime
set updatetime=50

" enable column position with ctrl-g
set noruler

" persistent undo
try
  set undodir=$HOME/.cache/undodir
  set undofile
catch
endtry

" switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on    
endif

" quick yanking to the end of the line
nnoremap Y y$

" pull word under cursor into lhs of a substitute (for quick search and replace)
nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" jump to matching pairs easily, with tab
nnoremap <Tab> %
vnoremap <Tab> %

" colourscheme
colorscheme alduin
