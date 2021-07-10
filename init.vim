" Ensure compatible mode is disabled
set nocompatible

" Sane regex
nnoremap / /\v
vnoremap / /\v


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

" Enable syntax highlighting
syntax on

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

" netrw settings
let g:netrw_browse_split=2
let g:vrfr_rg = 'true'
let g:netrw_banner = 0
let g:netrw_winsize = 25
nnoremap <leader>t :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

" Persistent undo
try
set undodir=$HOME/.cache/undodir
set undofile
catch
endtry

" Triggers global-search-and-replace. Prompts for a replacement string and
" will replace all matches from the previous search command.
" nnoremap <leader>r :%s//
nnoremap <leader>r :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>:%s//

" toggle highlighting the cursor line
nnoremap <leader>w :set cursorline!<cr>  

" Toggle the quickfix window {{{
" From Steve Losh, http://learnvimscriptthehardway.stevelosh.com/chapters/38.html
nnoremap <leader>q :call <SID>QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! s:QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction
" }}}

" Highlighting {{{

if (has("termguicolors"))
   " set termguicolors
endif

if &t_Co > 2 || has("gui_running")
   syntax on    " switch syntax highlighting on, when the terminal has colors
endif
" }}}

" Quick yanking to the end of the line
nnoremap Y y$

" Clears the search register
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Pull word under cursor into LHS of a substitute (for quick search and
" replace)
nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" Keep search matches in the middle of the window and pulse the line when moving
" to them.
function! PulseCursorLine()
    setlocal cursorline

    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    hi CursorLine guibg=#3a3a3a
    redraw
    sleep 14m

    hi CursorLine guibg=#4a4a4a
    redraw
    sleep 10m

    hi CursorLine guibg=#3a3a3a
    redraw
    sleep 14m

    hi CursorLine guibg=#2a2a2a
    redraw
    sleep 10m

    execute 'hi ' . old_hi
    setlocal nocursorline
endfunction

nnoremap n n:call PulseCursorLine()<cr>
nnoremap N N:call PulseCursorLine()<cr>

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" ------- Plugins ------
if empty(glob('$XDG_CONFIG_HOME/nvim/autoload/plug.vim'))
  silent !curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('$XDG_CACHE_HOME/nvim/plugged')
  Plug 'lervag/vimtex'                                    " Latex support
  Plug 'junegunn/goyo.vim'                                " No distractions mode
  Plug 'tpope/vim-commentary'                             " Commenting plugin: use gc
  Plug 'sbdchd/neoformat'                                 " Formats code
  Plug 'xuhdev/vim-latex-live-preview',{'for':'tex'}      " Live preview for latex files
  Plug 'junegunn/limelight.vim'                           " Highlights paragraph in Goyo mode
  Plug 'takac/vim-hardtime'                               " Limits hjkl usage
  Plug 'tpope/vim-surround'                               " Changes surrounding tags: use cs/ds
  Plug 'mhinz/vim-startify'                               " Adds start screen
  Plug 'tpope/vim-fugitive'                               " Git commands
  Plug 'airblade/vim-gitgutter'                           " Shows whats changed in repo
  Plug 'morhetz/gruvbox'                                  " Gruvbox theme
  Plug 'tpope/vim-obsession'                              " Sane session defaults
  Plug 'unblevable/quick-scope'                           " f&t highlighting
  Plug 'dense-analysis/ale'                               " linting
  Plug 'numirias/semshi', { 'do': ':UpdateRemovePlugins'} " python syntax highlighting
  Plug 'christoomey/vim-tmux-navigator'                   " tmux split integration
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " fzf
  Plug 'junegunn/fzf.vim'                                 " fzf
  Plug 'Yggdroot/indentline'                              " indent indicator
  Plug 'tpope/vim-repeat'                                 " sane repeat
  Plug 'Vimjas/vim-python-pep8-indent'                    " pep8 indenting
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sainnhe/gruvbox-material',                        " gruvbox material
call plug#end()
 
" Goyo macro
map <leader>g :Goyo \| set linebreak<CR>
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
let g:limelight_conceal_ctermfg='gray'
 
" Hard-time
let g:hardtime_default_on = 0
 
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
colorscheme gruvbox-material
set noshowmode
set noshowcmd
set shortmess+=F
 
" ALE settings
let g:ale_sign_info= "•"
let g:ale_sign_error = "•"
let g:ale_sign_warning = "•"
let g:ale_sign_style_error = "•"
let g:ale_sign_style_warning = "•"
let g:ale_set_quickfix = 1
let g:ale_set_loclist = 0
let g:ale_lint_on_enter = 1
 
" fzf settings
nnoremap <leader>f :Files<CR>
 
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
 
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
 
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
 
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
 
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
 
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
 
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
 
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
 
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
 
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
 
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
 
" Formatting selected code.
xmap <leader>p  <Plug>(coc-format-selected)
nmap <leader>p  <Plug>(coc-format-selected)
 
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
 
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
 
" Apply AutoFix to problem on the current line.
nmap <leader>x  <Plug>(coc-fix-current)
 
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
 
" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
 
" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
 
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
 
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
 
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
 
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
 
" Mappings for CoCList
" Show all diagnostics.

nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>


