"--- vim設定ファイル ---"


colorscheme desert
set background=dark
syntax on
set number
set title
set showcmd
set ruler
set showmatch
set matchtime=3
set guioptions-=T
set guioptions-=m


if has('multi_byte_ime')
        hi Cursor guifg=bg guibg=White gui=NONE
        hi CursorIM guifg=NONE guibg=Green gui=NONE
endif

autocmd GUIEnter * set transparency=200

