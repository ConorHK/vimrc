" Ensure compatible mode is disabled
set nocompatible

" Encoding
set encoding=UTF-8

" Set Leader key
let mapleader=" "
let maplocalleader=" "

" Longer leader key timeout
set timeout timeoutlen=1500

" Enable autocompletion
set wildmode=longest,list,full

" Splits open at bottom and right
set splitbelow splitright

" Split sane bindings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Spellcheck
autocmd FileType text,markdown setlocal spell
set spelllang=en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Don't automatically collapse markdown
set conceallevel=0

" Automatically re-read file if a change was made outside vim
set autoread

" No case-sensitive search unless uppercase is present
set ignorecase
set smartcase

" Enable mouse scroll
set mouse=a

" Allow new buffer to be opened without saving current
set hidden

" Statusline config
set statusline+=%F
set cmdheight=1

" Ensure lines break on whole words
set linebreak

" Ensure cursor stays away from screen edge
set scrolloff=3
set foldcolumn=1

" Tab settings
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set autoindent
set smartindent
set shiftround

" Print syntax highlighting
set printoptions+=syntax:y

" Matching braces/tags
set showmatch

" Line wrapping
set wrap

" Turn on detection for filetypes, indentation files and plugin files
filetype plugin indent on

" Share yank buffer with system clipboard
set clipboard=unnamedplus

" Show next 3 lines while scrolling
if !&scrolloff
  set scrolloff=3
endif

" Jump to last known position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Relative line numbers
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

" Disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Save files as sudo on files that require root permission
cmap w!! w !sudo tee > /dev/null %

" Clear highlight
nnoremap <esc><esc> :noh<return>

" Command mapping :Q because I always end up doing that
command Q q

" Lower updatetime
set updatetime=50

" Enable column position with Ctrl-G
set noruler

" Persistent undo
try
set undodir=$HOME/.cache/undodir
set undofile
catch
endtry

" toggle highlighting the cursor line
nnoremap <leader>w :set cursorline!<cr>  

" switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
   syntax on    
endif

" Quick yanking to the end of the line
nnoremap Y y$

" Clears the search register
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Pull word under cursor into LHS of a substitute (for quick search and
" replace)
nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" colourscheme
colorscheme alduin
set noshowmode
set noshowcmd
set shortmess+=F
