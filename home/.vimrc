syntax on
set tabstop=2
set shiftwidth=2
set expandtab "set expandtab! "retab
set ai
set number
set incsearch
set wildmenu
set ruler
set list
set colorcolumn=0
set re=0
set backspace=indent,eol,start
highlight Comment ctermfg=green

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'jparise/vim-graphql'
Plugin 'drtom/fsharp-vim'
Plugin 'calviken/vim-gdscript3'
Plugin 'VundleVim/Vundle.vim'

call vundle#end()
filetype plugin indent on
