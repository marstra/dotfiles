" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Add the g flag to search/replace by default
set gdefault
" Highlight searches
set hlsearch

" Show the filename in the window titlebar
set title
" Disable error bells
set noerrorbells

" Show the current mode
set showmode
" Show the cursor position
set ruler

" Enable line numbers
set number
" Use relative line numbers
if exists("&relativenumber")
        set relativenumber
        au BufReadPost * set relativenumber
endif

" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline

" install plugins here
" using vim-plug, see: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
call plug#end()

" use gruvbox theme, see: https://github.com/morhetz/gruvbox/
colorscheme gruvbox
set background=dark
