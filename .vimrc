" Eliminate latency for ESC key
set timeoutlen=1000 ttimeoutlen=10

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

" Add a command alias JF to format a json file as pretty printed
com! JF %!python -m json.tool

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

function! ConfirmQuit(writeFile)
    if (a:writeFile)
        if (expand('%:t')=="")
            echo "Can't save a file with no name."
            return
        endif
        :write
    endif

    " confirm quit if there's more than one buffer open
    "if (len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1)
    "    if (confirm("Do you really want to quit?", "&Yes\n&No", 2)==1)
    "        :quit
    "    endif
    "else
    "    :quit
    "endif
    quit
endfunction
cnoremap <silent> q<CR> :call ConfirmQuit(0)<CR>

" Toggle loc or quickfix list
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>

" Auto-close the loclist buffer when exiting vim
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

" Use pyenv for neovim
let g:python_host_prog = '/Users/ryanlane/.pyenv/versions/neovim/bin/python'
let g:python3_host_prog = '/Users/ryanlane/.pyenv/versions/neovim3/bin/python'

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
" Enable the top tabline for listing buffers
let g:airline#extensions#tabline#enabled = 1

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
"Plugin 'SirVer/ultisnips'

" Trigger configuration.
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Snippets for ultisnips
" Plugin 'honza/vim-snippets'

Plugin 'w0rp/ale'

" Switch from --/>> to W/E
let g:ale_sign_warning='W'
let g:ale_sign_error='E'
" Apply fixers on save
let g:ale_fix_on_save = 1
" Initialize linters and fixers
let g:ale_linters = {}
let g:ale_linter_aliases = {}
let g:ale_fixers = {}
" Show name of linter and severity level in msg format
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" Add maps for moving between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Python
let g:ale_linters['python'] = ['flake8', 'mypy']
let g:ale_python_mypy_options = '--ignore-missing-imports --scripts-are-modules'

" Typescript
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
let g:ale_linters['typescript'] = ['eslint', 'tslint']
let g:ale_fixers['typescript'] = ['prettier']
let g:ale_fixers['typescriptreact'] = ['prettier']
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --tab-width 4'

" Typeahead completion for various languages
Plugin 'ncm2/ncm2'
" yarp is the ncm2 plugin manager
Plugin 'roxma/nvim-yarp'
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANTE: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" Python
Plugin 'ncm2/ncm2-jedi'
" Javascript
Plugin 'ncm2/ncm2-tern'
" Css
Plugin 'cm2/ncm2-cssomni'
" Go
Plugin 'ncm2/ncm2-go'
" Words from the buffer
Plugin 'ncm2/ncm2-bufword'
" Words from the path
Plugin 'ncm2/ncm2-path'

" Support for rst (sphinx)
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

" Add onedark theme
Plugin 'joshdick/onedark.vim'

call vundle#end()

" Set true black and update highlight in onedark
if (has("autocmd"))
  augroup colorset
    autocmd!
    let s:black = { "gui": "#212121", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:black })
  augroup END
endif

" Theme color fixes
colorscheme onedark
let g:onedark_termcolors=256
let g:onedark_terminal_italics=1
let g:airline_theme='onedark'

" load plugin and ident vim files
filetype plugin indent on
