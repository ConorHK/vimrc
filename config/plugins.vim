if empty(glob('$XDG_CONFIG_HOME/nvim/autoload/plug.vim'))
  silent !curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('$XDG_CACHE_HOME/nvim/plugged')
  Plug 'lervag/vimtex'                                    " Latex support
  Plug 'tpope/vim-commentary'                             " Commenting plugin: use gc
  Plug 'tpope/vim-surround'                               " Changes surrounding tags: use cs/ds
  Plug 'mhinz/vim-startify'                               " Adds start screen
  Plug 'tpope/vim-fugitive'                               " Git commands
  Plug 'airblade/vim-gitgutter'                           " Shows whats changed in repo
  Plug 'tpope/vim-obsession'                              " Sane session defaults
  Plug 'unblevable/quick-scope'                           " f&t highlighting
  Plug 'dense-analysis/ale'                               " linting
  Plug 'nvim-treesitter/nvim-treesitter', {'dp': ':TSUpdate'} " highlighting
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " fzf
  Plug 'junegunn/fzf.vim'                                 " fzf
  Plug 'Yggdroot/indentline'                              " indent indicator
  Plug 'tpope/vim-repeat'                                 " sane repeat
  Plug 'Vimjas/vim-python-pep8-indent'                    " pep8 indenting
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " college
  Plug 'lervag/vimtex'                                    " Latex support
  Plug 'junegunn/goyo.vim'                                " No distractions mode
  Plug 'xuhdev/vim-latex-live-preview',{'for':'tex'}      " Live preview for latex files
  Plug 'junegunn/limelight.vim'                           " Highlights paragraph in Goyo mode
call plug#end()

 
" quickscope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END
 
" obsess
command -nargs=1 Obs :Obsess $SESSIONS/<args>.vim
 
" ale settings
let g:ale_sign_info= "•"
let g:ale_sign_error = "•"
let g:ale_sign_warning = "•"
let g:ale_sign_style_error = "•"
let g:ale_sign_style_warning = "•"
let g:ale_set_quickfix = 1
let g:ale_set_loclist = 0
let g:ale_lint_on_enter = 1
let g:ale_set_highlights = 0
 
" fzf settings
nnoremap <leader>f :Files<CR>
 
" coc
" goto code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
 
" use k to show documentation in preview window.
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
 
" highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
 
" symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
 
" formatting selected code.
xmap <leader>p  <Plug>(coc-format-selected)
nmap <leader>p  <Plug>(coc-format-selected)
 
augroup mygroup
  autocmd!
  " setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
 
" map function and class text objects
" note: requires 'textdocument.documentsymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
 
" add `:format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
 
" add `:fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
 
" add `:or` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
 
" add (neo)vim's native statusline support.
" note: please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
 
" gitgutter config
let g:gitgutter_set_sign_backgrounds = 0
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
set signcolumn=auto

" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- highlight the @foo.bar capture group with the "identifier" highlight group.
      ["foo.bar"] = "identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

" goyo
map <leader>g :Goyo \| set linebreak<CR>
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
let g:limelight_conceal_ctermfg='gray'

" latex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let g:livepreview_previewer = 'zathura'
