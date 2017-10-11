scriptencoding utf-8
call plug#begin('~/.vim/plugged')
  " edit
  Plug 'mattn/emmet-vim'
  Plug 'mattn/sonictemplate-vim'

  " status
  Plug 'itchyny/lightline.vim'

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
  Plug 'szw/vim-tags'
    " TODO: consider tags directory
    "     : let g:vim_tags_cache_dir = expand($HOME)
    "     : default .vt_location is .git directory

" TODO: trim syntastic?
if 1 == 1
  Plug 'vim-syntastic/syntastic'
  let s:useALE = 0
else
  Plug 'w0rp/ale'
  let s:useALE = 1
endif

  " language
  " dart
  Plug 'dart-lang/dart-vim-plugin'
  " clang
  Plug 'justmao945/vim-clang'
  " javascript
  Plug 'heavenshell/vim-jsdoc'
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
  " golang
  Plug 'fatih/vim-go'
  " python
  Plug 'davidhalter/jedi-vim'
    " TODO: check

  " color
  Plug 'nanotech/jellybeans.vim'
  "Plug 'w0ng/vim-hybrid'
  "Plug 'cocopon/Iceberg.vim'
  "Plug 'tomasr/molokai'
  "Plug 'trusktr/seti.vim'

  " etc
  Plug 'vim-jp/vimdoc-ja'
  Plug 'deris/vim-duzzle', { 'on': 'DuzzleStart' }

  Plug 'google/vim-maktaba'
  Plug 'google/vim-codefmt'
  Plug 'google/vim-glaive'
call plug#end()


"-----| let |-----"
" sonictemplate-vim
if isdirectory(glob('~/dotfiles/vim/sonicdir'))
  let g:sonictemplate_vim_template_dir = [
    \ '~/dotfiles/vim/sonicdir/pretempl',
    \ '~/dotfiles/vim/sonicdir/templ',
  \ ]
else
  echo "template directory: sonicdir disable"
endif

" lightline.vim
  let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste', 'fugitive' ],
    \     [ 'readonly', 'filename', 'modified' ],
    \   ],
    \   'right': [
    \     [ 'lineinfo', 'percent' ],
    \     [ 'fileformat', 'fileencoding', 'filetype' ],
    \     [ 'syntastic', 'ale' ],
    \   ],
    \ },
    \ 'component': {
    \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
    \ },
    \ 'component_visible_condition': {
    \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
    \ },
    \ 'component_function': {
    \   'syntastic': 'SyntasticStatuslineFlag',
    \   'ale': 'ALEGetStatusLine',
    \ },
  \ }
"  function! AleLintStatus() abort
"    let l:counts = ale#statusline#Count(bufnr(''))
"    let l:all_errors = l:counts.error + l:counts.style_error
"    let l:all_non_errors = l:counts.total - l:all_errors
"    return l:counts.total == 0 ? 'ALE:[OK]' : printf(
"          \ 'ALE:[%dW %dE]',
"          \ all_non_errors,
"          \ all_errors,
"          \)
"  endfunction

" tagbar
if (has('win32') || has('win64'))
  " path to local biuld ctags.exe
  if executable(glob('~/opt/ctags/ctags.exe'))
    let g:tagbar_ctags_bin = expand(glob('~/opt/ctags/ctags.exe'))
  else
    echo "not found ctags.exe"
  endif
endif
  " gotags
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
        \ 'f:functions' ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype' },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n' },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
  \ }

" vim-quickrun
  "let g:quickrun_no_default_key_mappings = 1
    " NOTE: 上を設定するとデフォルトマップが無効になる
  let g:quickrun_config = {}
  let g:quickrun_config['gotest'] = { 'command': 'go', 'exec': ['%c test -v -race'] }
    " NOTE: :QuickRun gotest
    "     : go test -race $(pwd)

" previm
if has('unix') && executable('chromium')
  let g:previm_open_cmd = 'exec chromium'
endif

" vim-easymotion
  let g:EasyMotion_do_mapping = 0

" TODO: fix
if s:useALE
" ale
  let g:ale_linters = {'go': ['gometalinter', 'gofmt', 'go build']}
  let g:ale_go_gometalinter_options = '--fast'
else
" syntastic
  let g:syntastic_mode_map = { 'mode': 'active' }
    " golang
    let g:syntastic_go_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
    let g:syntastic_go_checkers = ['gofmt', 'govet', 'golint']
    " cpp
    let g:syntastic_cpp_compiler = 'clang'
    let g:syntastic_cpp_compiler_options = '-std=c++1z --pedantic-errors'
    let g:syntastic_cpp_mode_map = { 'mode': 'active', 'passive_filetypes': ['cpp'] }
    let g:syntastic_cpp_checkers = ['clang_check']
    " javascript
    let g:syntastic_javascript_checkers = ['eslint']
endif

" vim-clang
  let g:clang_c_options = '-std=c11'
  let g:clang_cpp_options = '-std=c++1z --pedantic-errors'

" vim-go
if isdirectory(glob('~/dotfiles/vim/tmp/bin'))
  let g:go_bin_path = glob('~/dotfiles/vim/tmp/bin')
endif
  let g:go_play_open_browser = 0
  let g:go_fmt_autosave = 0
  let g:go_template_autocreate = 0

" jedi-vim
  " NOTE: for python
" let g:jedi#auto_initialization = 0
  let g:jedi#popup_on_dot = 0
  let g:jedi#auto_close_doc = 0
" let g:jedi#popup_select_first = 0
  let g:jedi#show_call_signatures = 0
  let g:jedi#rename_command = '<Leader>R'


"-----| keymap |-----"
" NOTE: プラグインのプレフィックスは<Leader>を基本に設定してみる
"     : Filetypeでスイッチするマップは次の autocmd で定義する
"     : CtrlP emmet sonictemplate はそのまま
"     : help: ctrlp-mappings

" TODO: fix
if s:useALE
" ale
  nnoremap <Leader>at :<C-u>ALEToggle<CR>
  nnoremap <Leader>ad :<C-u>ALEDetail<CR>
  nnoremap <Leader>j :<C-u>ALENextWrap<CR>
  nnoremap <Leader>k :<C-u>ALEPreviousWrap<CR>
else
" syntastic
  nnoremap <Leader>s :<C-u>SyntasticToggleMode<CR>
    " NOTE: 保存時に常に走らせると少し重い時があるのでトグルをマップ
    "     : 非同期でチェックできる良いプラグインがあれば乗り換えたい
endif

" nerdtree
  nnoremap <Leader>n :<C-u>NERDTreeToggle<CR>

" tagbar
  nnoremap <Leader>t :<C-u>TagbarToggle<CR>

" sonictemplate-vim
  " すぐにテンプレートを編集できるように
  if isdirectory(glob('~/dotfiles/vim/sonicdir/pretempl'))
    nnoremap <Leader>wp :<C-u>10split ~/dotfiles/vim/sonicdir/pretempl/%:e/
    nnoremap <Leader>ww :<C-u>10split ~/dotfiles/vim/sonicdir/templ/%:e/
  endif

" vim-easymotion
  map  <Leader>f <Plug>(easymotion-bd-w)
  nmap <Leader>f <Plug>(easymotion-overwin-w)

" vim-gitgutter
  nnoremap <Leader>ggt :<C-u>GitGutterToggle<CR>


"-----| autocmd |-----"
function! s:ftgo()
  " vim-go
  nnoremap <buffer> <Leader>i :<C-u>GoImport<space>
  nnoremap <buffer> <Leader>d :<C-u>GoDrop<space>
  nnoremap <buffer> <Leader>gd :<C-u>GoDoc<space>
endfunction

filetype plugin indent on
  " NOTE: plug begin end で含まれてるはずだけど一応
augroup plugin_manage_plug
  autocmd!
  autocmd Filetype go call s:ftgo()
augroup END
" EOF
