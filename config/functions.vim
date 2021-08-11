" toggle the quickfix window
" from steve losh, http://learnvimscriptthehardway.stevelosh.com/chapters/38.html
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

" keep search matches in the middle of the window and pulse the line when moving
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
