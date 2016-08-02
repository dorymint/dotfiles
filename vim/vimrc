"###vim設定ファイル###

set hidden
set history=1000
set nocompatible

" Charset Init
set encoding=utf-8

"-----| Visual Options |-----"
syntax on

set number
set title
set ruler
"set vb
set showmatch
set autoindent
set smartindent

set cmdheight=2
set wildmenu
set showcmd

set expandtab
set tabstop=4

set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<,eol:<

set laststatus=2
"# statuslineに表示する情報の指定(コピペなので正規表現で何を指定してるか理解が浅い)
"# statuslineに+=で表示情報を追加してる,起動中にvimrcを複数読むとバグりそう
set statusline+=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P


colorscheme desert
set background=dark


"backupをとらない
set nobackup
set backupdir=~/dotfiles/vim/tmp/backup

"undoフォルダを指定
set undodir=~/dotfiles/vim/tmp/undo

"swp output directory
set directory=~/dotfiles/vim/tmp/swap

" New splits open to right and bottom
set splitbelow
set splitright


"-----| key maps  |-----"
inoremap jj <Esc>

"-----| test adds |-----"
set incsearch
set hlsearch
set autoread  "ファイル内容が変更されると自動で読み込む
"---beep off
set vb t_vb=

"-----EOF
