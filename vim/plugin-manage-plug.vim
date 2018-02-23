scriptencoding utf-8
call plug#begin('~/.vim/plugged')
" edit
	" for html css completion
	Plug 'mattn/emmet-vim'
	" for snipets
	Plug 'mattn/sonictemplate-vim'

" status
	" for status line customize
	Plug 'itchyny/lightline.vim'

" git
	" for use git commands in vim
	Plug 'tpope/vim-fugitive'
	" for display a git diff in sign column
	Plug 'airblade/vim-gitgutter'

" manage
	" fizzy finder
	Plug 'ctrlpvim/ctrlp.vim'
	" directory tree
	Plug 'scrooloose/nerdtree'
	" tags information
	" NOTE: require ctags
	Plug 'majutsushi/tagbar'
	" command runner
	Plug 'thinca/vim-quickrun'
	" check reference from current cursors words
	Plug 'thinca/vim-ref'
	" preview for markdown
	Plug 'kannokanno/previm'
	" jump to words
	" NOTE: instead action: '/' or '?' on NORMAL mode
	Plug 'easymotion/vim-easymotion'
	" generate tags file
	" TODO: consider tags directory
	" let g:vim_tags_cache_dir = expand($HOME)
	" default .vt_location is .git directory
	Plug 'szw/vim-tags'

" TODO: pick
let s:useALE = v:false
if s:useALE
	Plug 'w0rp/ale'
else
	" NOTE: :Errors
	" see more info is :help syntastic-commands
	Plug 'vim-syntastic/syntastic'
endif

" language
	" dart
	Plug 'dart-lang/dart-vim-plugin'
	" clang
	Plug 'justmao945/vim-clang'
	" javascript
	Plug 'heavenshell/vim-jsdoc'
	Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
	" rust
	Plug 'rust-lang/rust.vim'
	Plug 'racer-rust/vim-racer'
	" golang
	Plug 'fatih/vim-go'
	" python
	Plug 'davidhalter/jedi-vim'

" colorscheme
	Plug 'nanotech/jellybeans.vim'
	Plug 'w0ng/vim-hybrid'
	Plug 'cocopon/Iceberg.vim'
	Plug 'tomasr/molokai'
	"Plug 'trusktr/seti.vim'

" etc
	" translated vim help
	Plug 'vim-jp/vimdoc-ja'
	" fun
	Plug 'deris/vim-duzzle', { 'on': 'DuzzleStart' }
	" Vim script plugin library
	" TODO: consider to remove
	Plug 'google/vim-maktaba'
	Plug 'google/vim-glaive'
	Plug 'google/vim-codefmt'
call plug#end()


"-----| let |-----"
" sonictemplate-vim
" TODO: consider to simpl
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
		\ 'left': [
			\ [ 'mode', 'paste', 'fugitive' ],
			\ [ 'readonly', 'filename', 'modified' ],
		\ ],
		\ 'right': [
			\ [ 'lineinfo', 'charvaluehex', 'percent' ],
			\ [ 'fileformat', 'fileencoding', 'filetype' ],
			\ [ 'syntastic', 'ale' ],
		\ ],
	\ },
	\ 'component': {
		\ 'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
		\ 'charvaluehex': '0x%04B',
	\ },
	\ 'component_visible_condition': {
		\ 'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
	\ },
	\ 'component_function': {
		\ 'syntastic': 'SyntasticStatuslineFlag',
		\ 'ale': 'ALEGetStatusLine',
	\ },
\ }
let g:lightline.tabline = {
	\ 'left': [
		\ [ 'tabs' ],
	\ ],
	\ 'right': [
		\ [ 'close' ],
	\ ],
\ }
let g:lightline.enable = {
	\ 'statusline': 1,
	\ 'tabline': 1,
\ }

" vim-gitgutter
let g:gitgutter_map_keys = v:false

" tagbar
if (has('win32') || has('win64'))
	" path to local biuld ctags.exe
	if executable(glob('~/opt/ctags/ctags.exe'))
		let g:tagbar_ctags_bin = expand(glob('~/opt/ctags/ctags.exe'))
	endif
endif
" use gotags
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds' : [
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
	\ 'ctagsbin' : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

" vim-quickrun
" NOTE: 設定するとデフォルトマップが無効になる
"let g:quickrun_no_default_key_mappings = 1
let g:quickrun_config = {}
" NOTE: :QuickRun gotest
" go test -race $(pwd)
let g:quickrun_config['gotest'] = { 'command': 'go', 'exec': ['%c test -v -race'] }

" previm
if executable('firefox')
	let g:previm_open_cmd = 'exec firefox'
elseif executable('chromium')
	let g:previm_open_cmd = 'exec chromium'
endif

" vim-easymotion
let g:EasyMotion_do_mapping = 0

if s:useALE
" ale
	let g:ale_lint_on_text_changed = 'never'
	let g:ale_lint_on_save = 1
	let g:ale_lint_on_enter = 1
	" NOTE: rustc is only use nightly
	" if use on stable or beta then be careful that is make the executable
	let g:ale_linters = {
		\ 'rust': ['cargo', 'rls', 'rustc'],
	\ }
else
" syntastic
	" golang
	let g:syntastic_go_checkers = ['go', 'gofmt', 'govet', 'golint']
	" rust
	let g:syntastic_rust_checkers = ['cargo']
	" cpp
	let g:syntastic_cpp_compiler = 'clang'
	let g:syntastic_cpp_compiler_options = '-std=c++1z --pedantic-errors'
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

" NOTE: for python
" jedi-vim
"let g:jedi#auto_initialization = 0
let g:jedi#popup_on_dot = 0
let g:jedi#auto_close_doc = 0
"let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = 0
let g:jedi#rename_command = '<LocalLeader>R'


"-----| keymap |-----"
" TODO: consider
" Filetypeでスイッチするマップは次の autocmd で定義する
" CtrlP emmet sonictemplate はそのまま
" :help ctrlp-mappings

if s:useALE
" ale
	nnoremap <LocalLeader>ale :<C-u>ALEToggle<CR>
	nnoremap <LocalLeader>ad :<C-u>ALEDetail<CR>
	nnoremap <LocalLeader>an :<C-u>ALENextWrap<CR>
	nnoremap <LocalLeader>ap :<C-u>ALEPreviousWrap<CR>
else
" syntastic
	" NOTE: 保存時に常に走らせると少し重い時があるのでトグルをマップ
	" 非同期でチェックできる良いプラグインがあれば乗り換えたい
	nnoremap <LocalLeader>s :<C-u>SyntasticToggleMode<CR>
endif

" nerdtree
nnoremap <LocalLeader>n :<C-u>NERDTreeToggle<CR>

" tagbar
nnoremap <LocalLeader>t :<C-u>TagbarToggle<CR>

" sonictemplate-vim
" すぐにテンプレートを編集できるように
if isdirectory(glob('~/dotfiles/vim/sonicdir/pretempl'))
	nnoremap <LocalLeader>ept :<C-u>10split ~/dotfiles/vim/sonicdir/pretempl/%:e/
	nnoremap <LocalLeader>et :<C-u>10split ~/dotfiles/vim/sonicdir/templ/%:e/
endif

" vim-easymotion
map <LocalLeader>f <Plug>(easymotion-bd-w)
nmap <LocalLeader>f <Plug>(easymotion-overwin-w)

" vim-gitgutter
nnoremap <LocalLeader>ggt :<C-u>GitGutterToggle<CR>


"-----| autocmd |-----"
function! s:ftgolang()
	" vim-go
	nnoremap <buffer> <LocalLeader>i :<C-u>GoImport<Space>
	nnoremap <buffer> <LocalLeader>d :<C-u>GoDrop<Space>
	nnoremap <buffer> <LocalLeader>gd :<C-u>GoDoc<Space>
endfunction

function! s:ftrust()
	" vim-racer
	"if executable(expand('~/.cargo/bin/racer'))
	"	let g:racer_cmd = expand('~/.cargo/bin/racer')
	"	let g:racer_experimental_completer = 1
	"endif
	nmap <buffer> gd <Plug>(rust-def)
	nmap <buffer> gs <Plug>(rust-def-split)
	nmap <buffer> gx <Plug>(rust-def-vertical)
	nmap <buffer> <LocalLeader>gd <Plug>(rust-doc)
	" quickrun
	nmap <buffer> <LocalLeader>r <Plug>(quickrun)
endfunction

" NOTE: plug begin end で含まれてるはずだけど一応
filetype plugin indent on

augroup plugin_manage_plug
	autocmd!
	autocmd FileType go call s:ftgolang()
	autocmd FileType rust call s:ftrust()
augroup END
