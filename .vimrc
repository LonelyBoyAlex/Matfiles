set relativenumber
set number
set tabstop=2

let data_dir = has('vim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()
filetype indent off
syntax off

" Enable the status line permanently
set laststatus=2

" Enable the Powerline symbols for a fancy look
let g:airline_powerline_fonts = 1

" Set a theme (e.g., 'badwolf' or 'gruvbox')
" You need the vim-airline-themes plugin installed for extra themes
" let g:airline_theme='gruvbox'

" Enable the tabline for buffer management (optional, but recommended)
let g:airline#extensions#tabline#enabled = 0

" Ensure proper encoding
set encoding=utf-8

