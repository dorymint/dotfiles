scriptencoding utf-8
call plug#begin('~/.vim/plugged')
" edit
  Plug 'mattn/emmet-vim'
  Plug 'mattn/sonictemplate-vim'

" status
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  "Plug 'itchyny/lightline.vim'
    " NOTE: も少し考える

" git
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

" manage
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'majutsushi/tagbar'
    " NOTE: require ctags
  Plug 'thinca/vim-quickrun'
  Plug 'thinca/vim-ref'
  Plug 'kannokanno/previm'
  Plug 'easymotion/vim-easymotion'

" IDE like
  Plug 'vim-syntastic/syntastic'
  Plug 'justmao945/vim-clang'
  "Plug 'fatih/vim-go'
    " NOTE: 少し大きすぎる
  Plug 'vim-jp/vim-go-extra'
  "Plug 'google/vim-ft-go'
    " NOTE: vim-ft-goはvimのversionが新しければ本体にmergeされているらしい
  Plug 'dart-lang/dart-vim-plugin'

" color
  Plug 'w0ng/vim-hybrid'
  Plug 'cocopon/Iceberg.vim'
  Plug 'nanotech/jellybeans.vim'
  Plug 'tomasr/molokai'

" etc
  Plug 'vim-jp/vimdoc-ja'
call plug#end()

"-----| let |-----"
" sonictemplate-vim
  if isdirectory(glob('~/dotfiles/vim/sonicdir'))
    let g:sonictemplate_vim_template_dir = '~/dotfiles/vim/sonicdir'
  else
    echo "template directory: sonicdir disable"
  endif

" airline
  let g:airline#extensions#tabline#enabled = 1
if 1 == 0
" lightline
  let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', 'fugitive' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \  'right': [ [ 'percent' ],
      \             [ 'fileformat', 'fileencoding', 'filetype' ],
      \             [ 'syntastic', 'lineinfo' ] ],
      \ },
      \ 'component': {
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'component_function': {
      \   'syntastic': 'SyntasticStatuslineFlag'
      \ },
  \ }
endif

" tagbar
  " path to local biuld ctags.exe
  if (has('win32') || has('win64'))
    if executable(glob('~/opt/ctags/ctags.exe'))
      let g:tagbar_ctags_bin = expand(glob('~/opt/ctags/ctags.exe'))
    else
      echo "do not find ctags.exe"
    endif
  endif
  " NOTE: require gotags
  let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
          \ 'p:package',
          \ 'i:imports:1',
          \ 'c:constants',
          \ 'v:variables',
          \ 't:types',
          \ 'n:interfaces',
          \ 'w:fields',
          \ 'e:embedded',
          \ 'm:methods',
          \ 'r:constructor',
          \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
          \ 't' : 'ctype',
          \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
          \ 'ctype' : 't',
          \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
  \ }

" vim-quickrun
  if 1 == 0
    let g:quickrun_no_default_key_mappings = 1
      " NOTE: 上を設定するとデフォルトマップが無効になる
  endif

" previm
  if has('unix') && executable('chromium')
    let g:previm_open_cmd = 'exec chromium'
  endif

" easymotion
  let g:EasyMotion_do_mapping = 0

" sytastic
  let g:syntastic_mode_map = { 'mode': 'active' }
  " golang
  let g:syntastic_go_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
  let g:syntastic_go_checkers = ['go', 'gofmt', 'gotype', 'govet', 'golint']
  " cpp
  let g:syntastic_cpp_compiler = 'clang'
  let g:syntastic_cpp_compiler_options = '-std=c++1z --pedantic-errors'
  let g:syntastic_cpp_checkers = ['clang_check']
  let g:syntastic_cpp_mode_map = { 'mode': 'active', 'passive_filetypes': ['cpp'] }

" vim-clang
  let g:clang_c_options = '-std=c11'
  let g:clang_cpp_options = '-std=c++1z --pedantic-errors'

"-----| keymap |-----"
" NOTE: プラグインのプレフィックスは<Leader>を基本に設定してみる
"     : Filetypeでスイッチするマップは次の autocmd で定義する
"     : CtrlP ummet sonictemplate はそのまま

  nnoremap <Leader>s   :<C-u>SyntasticToggleMode<nl>
    " NOTE: 保存時に常に走らせると少し重い時があるのでトグルをマップ
    "     : 非同期でチェックできる良いプラグインがあれば乗り換えたい
  nnoremap <Leader>n   :<C-u>NERDTreeToggle<nl>
  nnoremap <Leader>t   :<C-u>TagbarToggle<nl>

  " NOTE: すぐにテンプレートを編集できるように
  if isdirectory(glob('~/dotfiles/vim/sonicdir'))
    nnoremap <Leader>w   :<C-u>10split ~/dotfiles/vim/sonicdir/%:e/
  endif

  map  <Leader>f <Plug>(easymotion-bd-w)
  nmap <Leader>f <Plug>(easymotion-overwin-w)

"-----| autocmd |-----"
filetype plugin indent on
  " NOTE: plug begin end で含まれてるはずだけど一応
augroup plugin_manage_plug
  autocmd!
  " vim-go-extra
  autocmd Filetype go nnoremap <buffer> <S-k> :<C-u>Godoc
augroup END

" EOF
