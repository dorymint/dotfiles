scriptencoding utf-8

" plugin manage dein
" TODO:pluginのディレクトリをdotfiles以下に変えるか迷ってる

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin(expand('~/.vim/dein'))

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')
"call dein#add('Shougo/unite.vim')

call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

call dein#add('scrooloose/nerdtree')
call dein#add('tpope/vim-fugitive')
call dein#add('airblade/vim-gitgutter')

call dein#add('altercation/vim-colors-solarized')
call dein#add('w0ng/vim-hybrid')

call dein#add('ctrlpvim/ctrlp.vim')
"call dein#add('majutsushi/tagbar')
  " require ctags

" You can specify revision/branch/tag.
" call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

" Required:
call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

" neosnippet {{{
"let g:neosnippet#snippets_directory  = expand('~/.vim/dein/repos/github.com/Shougo/neosnippet-snippets/neosnippets , ~/dotfiles/vim/snippets')
"imap <C-k> <Plug>(neosnippet_expand_or_jump)
"smap <C-k> <Plug>(neosnippet_expand_or_jump)
"xmap <C-k> <plug>(neosnippet_expand_target)
" }}}


" vim-airline {{{
let g:airline_theme='papercolor'
"let g:airline_theme='hybrid'

let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#show_buffers = 0
"let g:airline#extensions#tabline#tab_nr_type = 1
" }}}

