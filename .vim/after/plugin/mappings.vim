" Map buffer management to something easier
" Up/Down handle file open history
nnoremap <leader><Up> <c-o>
nnoremap <leader><Down> <c-i>
" Left/Right handle previous and next in the buffer
nnoremap <leader><Left> :bprevious<CR>
nnoremap <leader><Right> :bnext<CR>
" Delete deletes a buffer
nnoremap <leader><Backspace> :bdelete<CR>
nnoremap <leader><Backspace><Backspace> :bdelete!<CR>
