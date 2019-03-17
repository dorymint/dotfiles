scriptencoding utf-8

call plug#begin('~/.vim/plugged')
  " Base:
  " help for japanese
  Plug 'vim-jp/vimdoc-ja'

  " status line
  Plug 'itchyny/lightline.vim'

  " preview on browser
  Plug 'previm/previm'

  " fizzy finder
  Plug 'ctrlpvim/ctrlp.vim'

  " directory tree
  Plug 'scrooloose/nerdtree'

  " tags information, require ctags
  Plug 'majutsushi/tagbar'

  " for generate tags file
  " TODO: consider tags directory
  " let g:vim_tags_cache_dir = expand($HOME)
  " default .vt_location is .git directory
  Plug 'szw/vim-tags'

  " template
  Plug 'mattn/sonictemplate-vim'

  " command runner
  Plug 'thinca/vim-quickrun'

  " check references from current cursors words
  " TODO: remove? if worked LspReferences
  Plug 'thinca/vim-ref'

  " jump to words
  Plug 'easymotion/vim-easymotion'

  " Git:
  " run git commands in vim
  Plug 'tpope/vim-fugitive'

  " display a git diff in sign column
  Plug 'airblade/vim-gitgutter'

  " Language:
  " language server protocol
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'

  " diagnostics
  Plug 'vim-syntastic/syntastic'

  " dart
  Plug 'dart-lang/dart-vim-plugin'

  " c
  Plug 'justmao945/vim-clang'

  " javascript
  Plug 'heavenshell/vim-jsdoc'
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }

  " rust
  Plug 'rust-lang/rust.vim'
  Plug 'racer-rust/vim-racer'

  " go
  " TODO: remove?
  Plug 'fatih/vim-go', { 'tag': 'v1.19' }

  " python
  " TODO: remove?
  "Plug 'davidhalter/jedi-vim'

  " UML is Unified Modeling Language, see 'plantuml.com'
  " vim-slumlord is for insert the ASCII diagrams
  Plug 'scrooloose/vim-slumlord'
  Plug 'aklt/plantuml-syntax'

  " html css
  Plug 'mattn/emmet-vim'

  " Colorscheme:
  Plug 'nanotech/jellybeans.vim'
  Plug 'w0ng/vim-hybrid'
  Plug 'cocopon/Iceberg.vim'
  Plug 'tomasr/molokai'
  "Plug 'trusktr/seti.vim'

  " Workaround:
  Plug 'vim-jp/syntax-vim-ex'
call plug#end()

filetype plugin indent on

"
" Config:
"
" mattn/sonictemplate-vim
let s:sonicdir = expand('~/dotfiles/vim/sonictemplate')
if isdirectory(s:sonicdir)
  let g:sonictemplate_vim_template_dir = s:sonicdir
endif

" itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
        \ 'left': [
          \ [ 'mode', 'fugitive', 'paste' ],
          \ [ 'readonly', 'filename', 'modified' ],
          \ ],
        \ 'right': [
          \ [ 'lineinfo', 'charvaluehex', 'percent', 'bufnum' ],
          \ [ 'spell', 'fileformat', 'fileencoding', 'filetype' ],
          \ [ 'syntastic' ],
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

" airblade/vim-gitgutter
let g:gitgutter_map_keys = v:false

" majutsushi/tagbar
if has('win32') || has('win64')
  " path to local biuld ctags.exe
  if executable(expand('~/opt/ctags/ctags.exe'))
    let g:tagbar_ctags_bin = expand('~/opt/ctags/ctags.exe')
  endif
endif
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
      \ 'ctagsbin' : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }

" thinca/vim-quickrun
" 設定するとデフォルトマップが無効になる
"let g:quickrun_no_default_key_mappings = 1
let g:quickrun_config = {}
let g:quickrun_config['gotest'] = {'command': 'go', 'exec': ['%c test -v -race']}

" kannokanno/previm
if executable('firefox')
  let g:previm_open_cmd = 'exec firefox'
elseif executable('chromium')
  let g:previm_open_cmd = 'exec chromium'
endif

" easymotion/vim-easymotion
let g:EasyMotion_do_mapping = 0

" prabirshrestha/vim-lsp
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
" for debug
if v:false
  let g:lsp_log_verbose = 1
  " check: tail --follow $logfile
  let g:lsp_log_file = expand('~/tmp/vim-lsp.log')
  let g:asyncomplete_log_file = expand('~/tmp/asyncomplete.log')
endif
augroup vimrc_plugin_lsp
  autocmd!
  " Go: go get golang.org/x/tools/cmd/gopls
  if executable('gopls')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'gopls',
          \ 'cmd': {server_info -> ['gopls', '-mode', 'stdio']},
          \ 'whitelist': ['go'],
          \ })
  endif

  " Rust: rustup update
  "     : rustup component add rls-preview rust-analysis rust-src
  if executable('rls')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'rls',
          \ 'cmd': {server_info -> ['rustup', 'run', 'stable', 'rls']},
          \ 'whitelist': ['rust'],
          \ })
  endif

  " Bash: npm install -g bash-language-server
  if executable('bash-language-server')
    " TODO: consider
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'bash-language-server',
          \ 'cmd': {server_info -> [&shell, &shellcmdflag, 'bash-language-server start']},
          \ 'whitelist': [],
          \ })
  endif

  " efm-langserver: go get -v -u github.com/mattn/efm-langserver/cmd/efm-langserver
  "   Linters:
  "     markdown: npm install -g markdownlint-cli
  "     vim: pip install vim-vint
  "     sh: pacman -S shellcheck # on arch
  "   DefaultConfig:
  "     Linux: '$HOME/.config/efm-langserver/config.yaml'
  "     Windows: '%APPDATA%\efm-langserver\config.yaml'
  if executable('efm-langserver')
      autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'efm-langserver',
            \ 'cmd': {server_info -> ['efm-langserver']},
            \ 'whitelist': ['sh', 'eruby', 'markdown', 'vim'],
            \ })
  endif
augroup END

" vim-syntastic/syntastic
let g:syntastic_cpp_compiler = 'clang'
let g:syntastic_cpp_compiler_options = '-std=c++1z --pedantic-errors'
let g:syntastic_cpp_checkers = ['clang_check']
let g:syntastic_javascript_checkers = ['eslint']

" justmao945/vim-clang
let g:clang_c_options = '-std=c11'
let g:clang_cpp_options = '-std=c++1z --pedantic-errors'

" racer-rust/vim-racer
if executable(expand('~/.cargo/bin/racer'))
  let g:racer_cmd = expand('~/.cargo/bin/racer')
  let g:racer_experimental_completer = 1
else
  echoerr 'not found "racer"'
endif

" fatih/vim-go
if isdirectory(expand('~/dotfiles/vim/tmp/bin'))
  let g:go_bin_path = expand('~/dotfiles/vim/tmp/bin')
endif
let g:go_play_open_browser = 0
let g:go_fmt_autosave = 0
let g:go_template_autocreate = 0

" davidhalter/jedi-vim
""let g:jedi#auto_initialization = 0
"let g:jedi#popup_on_dot = 0
"let g:jedi#auto_close_doc = 0
""let g:jedi#popup_select_first = 0
"let g:jedi#show_call_signatures = 0
"let g:jedi#rename_command = '<LocalLeader>R'

"
" Function:
"
" mattn/sonictemplate-vim
" すぐにテンプレートを編集できるように
function! s:edit_tmpl() abort
  if isdirectory(g:sonictemplate_vim_template_dir)
    " open by NERDTree or netrw
    execute "vsplit " . g:sonictemplate_vim_template_dir
  endif
endfunction

" prabirshrestha/vim-lsp
" TODO: consider to remove
function! s:lsp_commands() abort
  let l:m = {
        \ 'a': 'LspCodeAction',
        \ 'D': 'LspDeclaration',
        \ 'd': 'LspDefinition',
        \ 's': 'LspDocumentSymbol',
        \ 'e': 'LspDocumentDiagnostics',
        \ 'h': 'LspHover',
        \ 'n': 'LspNextError',
        \ 'p': 'LspPreviousError',
        \ 'r': 'LspReferences',
        \ 'R': 'LspRename',
        \ 'w': 'LspWorkspaceSymbol',
        \ 'f': 'LspDocumentFormat',
        \ 'F': 'LspDocumentFormatSync',
        \ 'i': 'LspImplementation',
        \ 't': 'LspTypeDefinition',
        \ 'S': 'LspStatus',
        \ }
  echo "Lsp:"
  for l:key in sort(keys(l:m))
    echo '  ' . l:key . '  ' . string(l:m[l:key])
  endfor
  echo 'Input:>'
  let l:c = nr2char(getchar())
  echo 'Input:' . l:c
  if has_key(l:m, l:c)
    execute l:m[l:c]
  else
    echo 'Invalid keys: ' . l:c
  endif
endfunction

let s:lsp_state = v:true
function! s:lsp_toggle() abort
  if s:lsp_state
    call lsp#disable()
    let s:lsp_state = v:false
    echo "Lsp disabled"
  else
    call lsp#enable()
    let s:lsp_state = v:true
    echo "Lsp enabled"
  endif
endfunction

"
" Mapping:
"
noremap <LocalLeader><LocalLeader> <Nop>
map     <LocalLeader><LocalLeader> <Plug>(easymotion-bd-w)
nmap    <LocalLeader><LocalLeader> <Plug>(easymotion-overwin-w)

nnoremap <LocalLeader>gt :<C-u>GitGutterToggle<CR>
nnoremap <LocalLeader>N  :<C-u>NERDTreeToggle<CR>
nnoremap <LocalLeader>h  :<C-u>NERDTreeToggle<CR>
nnoremap <LocalLeader>T  :<C-u>TagbarToggle<CR>
nnoremap <LocalLeader>l  :<C-u>TagbarToggle<CR>
nnoremap <LocalLeader>r  :<C-u>QuickRun<CR>

" mattn/sonictemplate-vim
nnoremap <LocalLeader>w :<C-u>call <SID>edit_tmpl()<CR>

" prabirshrestha/vim-lsp
nnoremap <LocalLeader>s :<C-u>LspStatus<CR>
nnoremap <LocalLeader>d :<C-u>LspDefinition<CR>
nnoremap <LocalLeader>f :<C-u>LspDocumentFormat<CR>
nnoremap <LocalLeader>t :<C-u>call <SID>lsp_toggle()<CR>
" TODO: consider
"nnoremap <LocalLeader>l :<C-u>call <SID>lsp_commands()<CR>

" lsp quickfix
nnoremap <LocalLeader>o :<C-u>LspDocumentDiagnostics<CR>
nnoremap <LocalLeader>e :<C-u>LspDocumentDiagnostics<CR>
nnoremap <LocalLeader>c :<C-u>cclose<CR>
nnoremap <LocalLeader>n :<C-u>LspNextError<CR>
nnoremap <LocalLeader>p :<C-u>LspPreviousError<CR>

augroup vimrc_plugin
  autocmd!
  function! s:ftgo()
    " fatih/vim-go
    nnoremap <buffer> <LocalLeader>f  :<C-u>GoFmt<CR>
    nnoremap <buffer> <LocalLeader>i  :<C-u>GoImports<Space>
    nnoremap <buffer> <LocalLeader>gd :<C-u>GoDoc<CR>
    cnoremap <buffer> <C-o>i :<C-u>GoImport<space>
    cnoremap <buffer> <C-o>d :<C-u>GoDrop<space>
  endfunction
  autocmd FileType go call s:ftgo()

  function! s:ftrust()
    " racer-rust/vim-racer
    nmap <buffer> gd <Plug>(rust-def)
    nmap <buffer> gs <Plug>(rust-def-split)
    nmap <buffer> gx <Plug>(rust-def-vertical)
    nmap <buffer> <LocalLeader>gd <Plug>(rust-doc)

    " rust-lang/rust.vim
    nmap <buffer> <LocalLeader>f :<C-u>RustFmt<CR>
  endfunction
  autocmd FileType rust call s:ftrust()
augroup END

