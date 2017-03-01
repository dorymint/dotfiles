scriptencoding utf-8

"-----| plug begin |-----" {{{
call plug#begin('~/.vim/plugged')
" edit
  Plug 'mattn/emmet-vim'
  Plug 'mattn/sonictemplate-vim'

"status
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

" IDE like
  Plug 'vim-syntastic/syntastic'
  Plug 'justmao945/vim-clang'
  "Plug 'fatih/vim-go'
    " NOTE: 少し大きすぎるので今のところコメントアウト
  Plug 'vim-jp/vim-go-extra'
  "Plug 'google/vim-ft-go'
    " NOTE: vim-ft-goはvimのversionが新しければ本体にmergeされているらしい

" color
  Plug 'w0ng/vim-hybrid'
  Plug 'cocopon/Iceberg.vim'
  Plug 'nanotech/jellybeans.vim'
  Plug 'tomasr/molokai'
  "Plug 'altercation/vim-colors-solarized'

" etc
  Plug 'vim-jp/vimdoc-ja'
call plug#end()
"-----| plug end |-----" }}}


"-----| config |-----"{{{
"--- edit ---
" sonictemplate-vim
if isdirectory(glob('~/dotfiles/vim/sonicdir'))
  let g:sonictemplate_vim_template_dir = '~/dotfiles/vim/sonicdir'
else
  echo "template directory: sonicdir disable"
endif


"--- status ---
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


"--- manage ---
" tagbar
if (has('win32') || has('win64'))
  " path to local biuld ctags.exe
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
" }}}

" previm
if has('unix') && executable('chromium')
  let g:previm_open_cmd = 'exec chromium'
endif


"--- IED like ---
" vim-go
if 1 == 0
  " highlight
  "let g:go_highlight_functions = 1
  "let g:go_highlight_methods = 1
  "let g:go_highlight_fields = 1
  "let g:go_highlight_types = 1
  "let g:go_highlight_operator = 1
  "let g:go_highlight_build_constraints = 1
  let g:go_fmt_command = "goimports"
  " windowsと設定変わってないので環境でpathを変えないなら下はいらないかも
  let g:go_bin_path = expand(glob('$GOPATH/bin'))
  " haswin
  if has('win32') || has('win64')
    let g:go_bin_path = expand(glob('$GOPATH/bin'))
  endif
endif

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
" -----| config end |----- }}}


"-----| keymap |-----" {{{
" NOTE: プラグインのプレフィックスは<C-@>を基本に設定してみる
"     : Filetypeでスイッチするマップは次の autocmd で定義する
"     : CtrlPは<C-p>のまま

" syntastic
  nnoremap <C-@>s   :<C-u>SyntasticToggleMode<nl>
    " NOTE: 保存時に常に走らせると少し重い時があるのでトグルをマップ
    "     : 非同期でチェックできる良いプラグインがあれば乗り換えたい
" NERDTree
  nnoremap <C-@>n   :<C-u>NERDTreeToggle<nl>
" tagbar
  nnoremap <C-@>t   :<C-u>TagbarToggle<nl>
" sonictemplate
if isdirectory(glob('~/dotfiles/vim/sonicdir'))
  nnoremap <C-@>w :<C-u>10split ~/dotfiles/vim/sonicdir/%:e/
    " NOTE: すぐにテンプレートを編集できるように
endif
"-----| keymap end |-----" }}}


"-----| autocmd |-----" {{{
filetype plugin indent on
  " NOTE: plug begin end で含まれてるはずだけど一応
augroup plugin_manage_plug
  autocmd!
  " vim-go-extra
    autocmd Filetype go nnoremap <buffer> <S-k> :<C-u>Godoc
augroup END
"-----| autocmd |-----" }}}
" EOF
