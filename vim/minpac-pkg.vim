scriptencoding utf-8

if !isdirectory(glob('~/.vim/pack/minpac/opt/minpac'))
	echo "can not found ~/.vim/pack/minpac/opt/minpac"
	finish
endif

" TODO: consider index
if exists('*minpac#init')
" --- init ---
	call minpac#init()
	call minpac#add('k-takata/minpac', {'type': 'opt'})

" --- snip ---
	call minpac#add('mattn/emmet-vim')

	call minpac#add('mattn/sonictemplate-vim')
	if isdirectory(glob('~/dotfiles/vim/sonicdir'))
		let g:sonictemplate_vim_template_dir = [
			\ '~/dotfiles/vim/sonicdir/pretempl',
			\ '~/dotfiles/vim/sonicdir/templ',
		\ ]
	else
		echo "template directory: sonicdir disable"
	endif
	" NOTE: すぐにテンプレートを編集できるように
	if isdirectory(glob('~/dotfiles/vim/sonicdir/pretempl'))
		nnoremap <Leader>wp :<C-u>10split ~/dotfiles/vim/sonicdir/pretempl/%:e/
		nnoremap <Leader>ww :<C-u>10split ~/dotfiles/vim/sonicdir/templ/%:e/
	endif

" --- status line ---
	call minpac#add('itchyny/lightline.vim')
let g:lightline = {
	\ 'colorscheme': 'jellybeans',
	\ 'active': {
		\ 'left': [
			\ [ 'mode', 'paste', 'fugitive' ],
			\ [ 'readonly', 'filename', 'modified' ],
		\ ],
		\ 'right': [
			\ [ 'lineinfo', 'percent' ],
			\ [ 'fileformat', 'fileencoding', 'filetype' ],
			\ [ 'syntastic', 'ale' ],
		\ ],
	\ },
	\ 'component': {
		\ 'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
	\ },
	\ 'component_visible_condition': {
		\ 'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
	\ },
	\ 'component_function': {
		\ 'syntastic': 'SyntasticStatuslineFlag',
		\ 'ale': 'ALEGetStatusLine',
	\ },
\ }
"function! AleLintStatus() abort
"	let l:counts = ale#statusline#Count(bufnr(''))
"	let l:all_errors = l:counts.error + l:counts.style_error
"	let l:all_non_errors = l:counts.total - l:all_errors
"	return l:counts.total == 0 ? 'ALE:[OK]' : printf(
"				\ 'ALE:[%dW %dE]',
"				\ all_non_errors,
"				\ all_errors,
"				\)
"endfunction

" --- git ---
	call minpac#add('tpope/vim-fugitive')

	call minpac#add('airblade/vim-gitgutter')
	nnoremap <Leader>ggt :<C-u>GitGutterToggle<CR>

" TODO: classify
" --- etc ---
	call minpac#add('ctrlpvim/ctrlp.vim')

	call minpac#add('scrooloose/nerdtree')
	nnoremap <Leader>n :<C-u>NERDTreeToggle<CR>

	" NOTE: require ctags
	call minpac#add('majutsushi/tagbar')
	nnoremap <Leader>t :<C-u>TagbarToggle<CR>
	if (has('win32') || has('win64'))
		" path to local biuld ctags.exe
		if executable(glob('~/opt/ctags/ctags.exe'))
			let g:tagbar_ctags_bin = expand(glob('~/opt/ctags/ctags.exe'))
		else
			echo "not found ctags.exe"
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

	call minpac#add('thinca/vim-quickrun')
	"let g:quickrun_no_default_key_mappings = 1
		" NOTE: 上を設定するとデフォルトマップが無効になる
	let g:quickrun_config = {}
	let g:quickrun_config['gotest'] = { 'command': 'go', 'exec': ['%c test -v -race'] }
		" NOTE: :QuickRun gotest
		" go test -race $(pwd)

	call minpac#add('thinca/vim-ref')

	call minpac#add('kannokanno/previm')
	if has('unix')
		if executable('firefox')
			let g:previm_open_cmd = 'exec firefox'
		elseif executable('chromium')
			let g:previm_open_cmd = 'exec chromium'
		endif
	endif

	call minpac#add('easymotion/vim-easymotion')
	let g:EasyMotion_do_mapping = 0
	map <Leader>f <Plug>(easymotion-bd-w)
	nmap <Leader>f <Plug>(easymotion-overwin-w)

	call minpac#add('szw/vim-tags')
		" TODO: consider tags directory
		" let g:vim_tags_cache_dir = expand($HOME)
		" default .vt_location is .git directory

" --- syntax check ---
" TODO: consider to use which
	if v:false
		call minpac#add('vim-syntastic/syntastic')
		let g:syntastic_mode_map = { 'mode': 'active' }
		" golang
		let g:syntastic_go_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
		let g:syntastic_go_checkers = ['go', 'gofmt', 'govet', 'golint']
		" cpp
		let g:syntastic_cpp_compiler = 'clang'
		let g:syntastic_cpp_compiler_options = '-std=c++1z --pedantic-errors'
		let g:syntastic_cpp_mode_map = { 'mode': 'active', 'passive_filetypes': ['cpp'] }
		let g:syntastic_cpp_checkers = ['clang_check']
		" javascript
		let g:syntastic_javascript_checkers = ['eslint']
		nnoremap <Leader>s :<C-u>SyntasticToggleMode<CR>
	else
		call minpac#add('w0rp/ale')
		let g:ale_lint_on_text_changed = 'never'
		let g:ale_lint_on_save = 1
		let g:ale_lint_on_enter = 1
		let g:ale_linters = {'go': ['gofmt', 'go vet', 'golint', 'go build', 'gosimple', 'staticcheck']}
		let g:ale_go_gometalinter_options = '--fast'
		nnoremap <Leader>at :<C-u>ALEToggle<CR>
		nnoremap <Leader>ad :<C-u>ALEDetail<CR>
		nnoremap <Leader>j :<C-u>ALENextWrap<CR>
		nnoremap <Leader>k :<C-u>ALEPreviousWrap<CR>
	endif

" --- language ---
	call minpac#add('dart-lang/dart-vim-plugin')

	call minpac#add('justmao945/vim-clang')
	let g:clang_c_options = '-std=c11'
	let g:clang_cpp_options = '-std=c++1z --pedantic-errors'

	call minpac#add('heavenshell/vim-jsdoc')

	call minpac#add('ternjs/tern_for_vim')

	call minpac#add('fatih/vim-go')
	if isdirectory(glob('~/dotfiles/vim/tmp/bin'))
		let g:go_bin_path = glob('~/dotfiles/vim/tmp/bin')
	endif
	let g:go_play_open_browser = 0
	let g:go_fmt_autosave = 0
	let g:go_template_autocreate = 0
	nnoremap <buffer> <Leader>i :<C-u>GoImport<space>
	nnoremap <buffer> <Leader>d :<C-u>GoDrop<space>
	nnoremap <buffer> <Leader>gd :<C-u>GoDoc<space>

	call minpac#add('davidhalter/jedi-vim')
	"let g:jedi#auto_initialization = 0
	let g:jedi#popup_on_dot = 0
	let g:jedi#auto_close_doc = 0
	"let g:jedi#popup_select_first = 0
	let g:jedi#show_call_signatures = 0
	let g:jedi#rename_command = '<Leader>R'

" --- colors ---
	call minpac#add('nanotech/jellybeans.vim')
	call minpac#add('w0ng/vim-hybrid')
	call minpac#add('cocopon/Iceberg.vim')
	call minpac#add('tomasr/molokai')
	"call minpac#add('trusktr/seti.vim')

" --- etc ---
	call minpac#add('vim-jp/vimdoc-ja')
	call minpac#add('deris/vim-duzzle', {'type': 'opt'})

	call minpac#add('google/vim-maktaba')
	call minpac#add('google/vim-codefmt')
	call minpac#add('google/vim-glaive')

	" TODO: consider
	"packloadall
endif

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()
