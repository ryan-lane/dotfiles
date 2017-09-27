" Up/Down handle previous and next in the buffer
nnoremap <leader><Up> :bprevious<CR>
nnoremap <leader><Down> :bnext<CR>
" Left/Right handle previous and next windows
nnoremap <leader><Left> <c-w><Left>
nnoremap <leader><Right> <c-w><Right>
" Delete deletes a buffer
nnoremap <leader><Backspace> :bprevious<CR>:bdelete #<CR>
