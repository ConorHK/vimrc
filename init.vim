" Cleanup
"set undodir=$XDG_DATA_HOME/vim/undo
"set directory=$XDG_DATA_HOME/vim/swap
"set backupdir=$XDG_DATA_HOME/vim/backup
"set viewdir=$XDG_DATA_HOME/vim/view
"set runtimepath=$XDG_CONFIG_HOME/vim,$VIMRUNTIME,$XDG_CONFIG_HOME/vim/after
"set viminfo+=n$XDG_DATA_HOME/vim/viminfo

" Plugins
  call plug#begin('$XDG_CACHE_HOME/nvim/plugged')
    Plug 'lervag/vimtex'
    Plug 'junegunn/goyo.vim'
    Plug 'tpope/vim-commentary'
    Plug 'sbdchd/neoformat'
    Plug 'xuhdev/vim-latex-live-preview',{'for':'tex'}
    Plug 'junegunn/limelight.vim'
    Plug 'takac/vim-hardtime'
    Plug 'sirver/ultisnips'
    Plug 'tpope/vim-surround'
    Plug 'mhinz/vim-startify'
    Plug 'tpope/vim-sensible'
    Plug 'jacoborus/tender.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
  call plug#end()

" encoding
  set encoding=UTF-8

" Colourscheme
  colorscheme tender
  set noshowmode
  set noshowcmd
  set shortmess+=F

" Set Leader key
  let mapleader=" "
  let maplocalleader=" "

" Longer leader key timeout
  set timeout timeoutlen=1500

" Enable autocompletion
  set wildmode=longest,list,full

" Goyo macro
  map <leader>f :Goyo \| set linebreak<CR>
  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!
  let g:limelight_conceal_ctermfg='gray'

" Splits open at bottom and right
  set splitbelow splitright

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

" Tab settings
  set expandtab
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set smarttab
  set autoindent
  set smartindent
  set shiftround

" Enable syntax highlighting
  syntax on

" Print syntax highlighting
  set printoptions+=syntax:y

" Matching braces/tags
  set showmatch

" Faster ESC
  inoremap jk <ESC>
  inoremap kj <ESC>

" Line wrapping
  set wrap

" Turn on detection for filetypes, indentation files and plugin files
  filetype plugin indent on

" Split window appears on the right hand side of the current one
  set splitright

" Ensure compatible mode is disabled
  set nocompatible

" Share yank buffer with system clipboard
  set clipboard=unnamedplus

" Show next 3 lines while scrolling
  if !&scrolloff
    set scrolloff=3
  endif

" Show next 5 columns while side scrolling
  if !&sidescrolloff
    set sidescrolloff=5
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

" Delete all trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e

" LaTeX Plug
  let g:tex_flavor='latex'
  let g:vimtex_view_method='zathura'
  let g:vimtex_quickfix_mode=0
  set conceallevel=1
  let g:tex_conceal='abdmg'
  let g:livepreview_previewer = 'zathura'

" Hard-time
"let g:hardtime_default_on = 1

" Ultisnips
  let g:UltiSnipsExpandTrigger = '<tab>'
  let g:UltiSnipsJumpForwardTrigger = '<tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
  let g:UltiSnipsSnippetsDir = expand("$XDG_CONFIG_HOME/nvim/ultisnips")
  if has('fname_case')
      let g:UltiSnipsSnippetDirectories = ["UltiSnips", "ultisnips"]
  endif

" Command mapping :Q because I always end up doing that
  command Q q
