" Never compatible mode...
set nocompatible

" Use space as the leader
let mapleader = "\<Space>"

" Don't allow ctrl-z to background vim
noremap <c-z> <nop>

" We're using a fast tty, so use the setting for faster loading
set ttyfast

" Use the ruler
set ruler

" Use all the colors
set t_Co=256

" Highlight code syntax
syntax on

" Highlight searches
set hlsearch
" case insensitive searches
set ic
" type-ahead-find
set incsearch

"" Default spacing
" use spaces instead of tabs
set expandtab
" 1 tab == 2 spaces
set shiftwidth=4
" 1 tab == 2 spaces
set tabstop=4

" set autoread and adjust backupcopy for inotify forwarding fixes
set autoread
set backupcopy=yes

" Identation
autocmd Filetype sh setlocal ts=2 sts=2 sw=2
autocmd Filetype bash setlocal ts=2 sts=2 sw=2
autocmd FileType json setlocal ts=2 sts=2 sw=2
autocmd FileType yaml setlocal ts=2 sts=2 sw=2
autocmd FileType xml setlocal ts=2 sts=2 sw=2

" Resume cursor location when a file is reentered
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" Simple re-format for minified Javascript
" command! UnMinify call UnMinify()
function! UnMinify()
  %s/{\ze[^\r\n]/{\r/g
  %s/){/) {/g
  %s/};\?\ze[^\r\n]/\0\r/g
  %s/;\ze[^\r\n]/;\r/g
  %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
  normal ggVG=
endfunction

" Setup vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/Vundle.vim'

" The bundles you install will be listed here

" plist editing for osx plists
Plugin 'darfink/vim-plist'
let g:plist_json_filetype = 'javascript'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'minimalist'
" Enable the top tabline for listing buffers
let g:airline#extensions#tabline#enabled = 1

Plugin 'klen/python-mode'

let g:pymode = 1
let g:pymode_options = 0
let g:pymode_folding = 0
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
" let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pep257']
" let g:pymode_lint_checkers = ['pep8']
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mypy']

" For sls syntax
Plugin 'saltstack/salt-vim'

Plugin 'elzr/vim-json'
" Disable the stupid quotes concealing. We're not using coffeescript, this is
" json -_-.
let g:vim_json_syntax_conceal = 0

Plugin 'pangloss/vim-javascript'

Plugin 'leafgarland/typescript-vim'
" Have make output from typescript support show in a lower window
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

Plugin 'fatih/vim-go'

" For boilerplate snippets
Plugin 'SirVer/ultisnips'

" Trigger configuration.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Snippets for ultisnips
Plugin 'honza/vim-snippets'

Plugin 'Valloric/YouCompleteMe'
" Disable for rst, since it's not supported and the autocompletion shows every
" word in the rst doc as an ID.
let g:ycm_filetype_blacklist = {'rst': 1}
" Let YCM read tags from Ctags file
let g:ycm_collect_identifiers_from_tags_files = 1
" Completion for programming language's keyword
let g:ycm_seed_identifiers_with_syntax = 1
" Completion in comments
let g:ycm_complete_in_comments = 1
" Completion in strings
let g:ycm_complete_in_strings = 1
" Close the preview window when completion event occurs
let g:ycm_autoclose_preview_window_after_completion = 1
" Map ctrl-g to goto definition
nnoremap <leader>g :YcmCompleter GoTo<CR>

" for rst
Plugin 'Rykka/riv.vim'
let g:riv_disable_folding=1

" Let editorconfig in repos automatically set settings like tabstop, tabwidth,
" max line length, etc.
Plugin 'editorconfig/editorconfig-vim'

" Support for dockerfiles
Plugin 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}

" Filesystem hierarchy view
Plugin 'scrooloose/nerdtree'
" Exit vim if last window is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

call vundle#end()

filetype plugin indent on
