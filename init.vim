" Cleanup
  "set undodir=$XDG_DATA_HOME/vim/undo
  "set directory=$XDG_DATA_HOME/vim/swap
  "set backupdir=$XDG_DATA_HOME/vim/backup
  "set viewdir=$XDG_DATA_HOME/vim/view
  "set runtimepath=$XDG_CONFIG_HOME/vim,$VIMRUNTIME,$XDG_CONFIG_HOME/vim/after
  "set viminfo+=n$XDG_DATA_HOME/vim/viminfo

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

" Clear highlight
  nnoremap <esc><esc> :noh<return>

" Command mapping :Q because I always end up doing that
  command Q q

" Lower updatetime
  set updatetime=50

" Enable column position with Ctrl-G
  set noruler
" netrw settings
  let g:netrw_browse_split=2
  let g:vrfr_rg = 'true'
  let g:netrw_banner = 0
  let g:netrw_winsize = 25
  nnoremap <leader>t :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

" Source PEP8 defaults for c and python - may override some settings here
  " source $XDG_CONFIG_HOME/nvim/src/pep8.vim

" ------- Plugins ------
  if empty(glob('$XDG_CONFIG_HOME/nvim/autoload/plug.vim'))
    silent !curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  call plug#begin('$XDG_CACHE_HOME/nvim/plugged')
    Plug 'lervag/vimtex'                                  " Latex support
    Plug 'junegunn/goyo.vim'                              " No distractions mode
    Plug 'tpope/vim-commentary'                           " Commenting plugin: use gc
    Plug 'sbdchd/neoformat'                               " Formats code
    Plug 'xuhdev/vim-latex-live-preview',{'for':'tex'}    " Live preview for latex files
    Plug 'junegunn/limelight.vim'                         " Highlights paragraph in Goyo mode
    Plug 'takac/vim-hardtime'                             " Limits hjkl usage
    Plug 'sirver/ultisnips'                               " Snippet tool
    Plug 'tpope/vim-surround'                             " Changes surrounding tags: use cs/ds
    Plug 'mhinz/vim-startify'                             " Adds start screen
    Plug 'jacoborus/tender.vim'                           " Tender theme
    Plug 'tpope/vim-fugitive'                             " Git commands
    Plug 'airblade/vim-gitgutter'                         " Shows whats changed in repo
    Plug 'morhetz/gruvbox'                                " Gruvbox theme
    Plug 'tpope/vim-obsession'                            " Sane session defaults
    Plug 'yuttie/comfortable-motion.vim'                  " Smooth scroll
    Plug 'unblevable/quick-scope'                         " f&t highlighting
    Plug 'dense-analysis/ale'                             " linting
    Plug 'vim-ruby/vim-ruby'                              " ruby
  call plug#end()

" Goyo macro
  map <leader>f :Goyo \| set linebreak<CR>
  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!
  let g:limelight_conceal_ctermfg='gray'

" Hard-time
  " let g:hardtime_default_on = 1

" Ultisnips
  let g:UltiSnipsExpandTrigger = '<tab>'
  let g:UltiSnipsJumpForwardTrigger = '<tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
  let g:UltiSnipsSnippetsDir = expand("$XDG_CONFIG_HOME/nvim/ultisnips")
  if has('fname_case')
      let g:UltiSnipsSnippetDirectories = ["UltiSnips", "ultisnips"]
  endif

" LaTeX Plug
  let g:tex_flavor='latex'
  let g:vimtex_view_method='zathura'
  let g:vimtex_quickfix_mode=0
  set conceallevel=1
  let g:tex_conceal='abdmg'
  let g:livepreview_previewer = 'zathura'

" Quickscope
  let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
  augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
  augroup END

" Obsess
  command -nargs=1 Obs :Obsess $SESSIONS/<args>.vim

" Colourscheme
  colorscheme gruvbox
  set noshowmode
  set noshowcmd
  set shortmess+=F

" ALE settings
let g:ale_sign_info= "•"
let g:ale_sign_error = "•"
let g:ale_sign_warning = "•"
let g:ale_sign_style_error = "•"
let g:ale_sign_style_warning = "•"
let g:ale_linters = { 'ruby': ['rubocop'],}
