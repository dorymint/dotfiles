scriptencoding utf-8
call plug#begin('~/.vim/plugged')
  " Japanese help
  Plug 'vim-jp/vimdoc-ja'

  " status line
  Plug 'itchyny/lightline.vim'

  " fuzzy finder
  Plug 'ctrlpvim/ctrlp.vim'

  " file explorer
  Plug 'scrooloose/nerdtree'
  "Plug 'mattn/vim-molder'

  " jump to words
  Plug 'easymotion/vim-easymotion'

  " run git commands in vim
  Plug 'tpope/vim-fugitive'

  " display a git diff in sign column
  Plug 'airblade/vim-gitgutter'

  " template
  Plug 'mattn/sonictemplate-vim'

  " language server protocol
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'mattn/vim-lsp-settings'

  " command runner
  Plug 'thinca/vim-quickrun'

  " rust
  Plug 'rust-lang/rust.vim'
  Plug 'racer-rust/vim-racer'

  " go
  Plug 'mattn/vim-goimports'

  " UML is Unified Modeling Language, see 'plantuml.com'
  " vim-slumlord is for insert the ASCII diagrams
  Plug 'scrooloose/vim-slumlord'
  Plug 'aklt/plantuml-syntax'

  " html css
  Plug 'mattn/emmet-vim'

  " markdown preview
  Plug 'previm/previm'

  " colorscheme
  Plug 'nanotech/jellybeans.vim'
  Plug 'w0ng/vim-hybrid'
  Plug 'cocopon/Iceberg.vim'
  Plug 'tomasr/molokai'
  "Plug 'trusktr/seti.vim'

  Plug 'vim-jp/syntax-vim-ex'
call plug#end()

filetype plugin indent on

" Config:

" sonictemplate-vim
let s:d = expand('~/dotfiles/vim/sonictemplate')
if isdirectory(s:d)
  let g:sonictemplate_vim_template_dir = s:d
endif
unlet s:d

nnoremap <LocalLeader>w :<C-u>call <SID>edit_templ()<CR>
function! s:edit_templ() abort
  if isdirectory(g:sonictemplate_vim_template_dir)
    execute "vsplit " . g:sonictemplate_vim_template_dir
  endif
endfunction

" lightline.vim
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

" vim-gitgutter
let g:gitgutter_map_keys = v:false

" vim-quickrun
" 設定するとデフォルトマップが無効になる
"let g:quickrun_no_default_key_mappings = 1
let g:quickrun_config = {}
let g:quickrun_config['gotest'] = {'command': 'go', 'exec': ['%c test -v -race']}

" previm
if executable('firefox')
  let g:previm_open_cmd = 'exec firefox'
elseif executable('chromium')
  let g:previm_open_cmd = 'exec chromium'
endif

" vim-easymotion
let g:EasyMotion_do_mapping = 0

" vim-lsp
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_signs_enabled = 1
augroup vimrc_plugin_LSP
  autocmd!
  " sh
  if executable('shellcheck') && executable('efm-langserver')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'shellcheck',
          \ 'cmd': {server_info -> ['efm-langserver']},
          \ 'whitelist': ['sh']
          \ })
  endif
augroup END

" vim-slp-settings
let g:lsp_settings_servers_dir = expand('~/.local/share/vim-lsp-settings/servers')

" vim-racer
if executable(expand('~/.cargo/bin/racer'))
  let g:racer_cmd = expand('~/.cargo/bin/racer')
  let g:racer_experimental_completer = 1
else
  echoerr 'not found "racer"'
endif

" Mapping:

noremap <LocalLeader><LocalLeader> <Nop>
map     <LocalLeader><LocalLeader> <Plug>(easymotion-bd-w)
nmap    <LocalLeader><LocalLeader> <Plug>(easymotion-overwin-w)

nnoremap <LocalLeader>ggt :<C-u>GitGutterToggle<CR>
nnoremap <LocalLeader>h   :<C-u>NERDTreeToggle<CR>
nnoremap <LocalLeader>r   :<C-u>QuickRun<Space>

" sonictemplate
nnoremap <LocalLeader>w :<C-u>call <SID>edit_templ()<CR>

" vim-lsp
nnoremap <LocalLeader>s :<C-u>LspStatus<CR>
nnoremap <LocalLeader>d :<C-u>LspDefinition<CR>
nnoremap <LocalLeader>f :<C-u>LspDocumentFormat<CR>

nnoremap <LocalLeader>t :<C-u>call <SID>toggle_lsp()<CR>
let s:lsp_state = v:true
function! s:toggle_lsp() abort
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

" quickfix
nnoremap <LocalLeader>o :<C-u>LspDocumentDiagnostics<CR>
nnoremap <LocalLeader>e :<C-u>LspDocumentDiagnostics<CR>
nnoremap <LocalLeader>c :<C-u>cclose<CR>
nnoremap <LocalLeader>n :<C-u>LspNextError<CR>
nnoremap <LocalLeader>p :<C-u>LspPreviousError<CR>

" FileType:

augroup vimrc_plugin_ft
  autocmd!
  autocmd FileType go call s:ftgo()
  autocmd FileType rust call s:ftrust()
  autocmd FileType markdown call s:ftmd()
augroup END

function! s:ftgo()
  " vim-goimports
  nnoremap <buffer> <LocalLeader>i :<C-u>GoImportRun<Space>
  " vim-lsp
  nnoremap <buffer> gd :<C-u>LspDefinition<CR>
endfunction

function! s:ftrust()
  " vim-racer
  nmap <buffer> gd <Plug>(rust-def)
  nmap <buffer> gs <Plug>(rust-def-split)
  nmap <buffer> gx <Plug>(rust-def-vertical)
  nmap <buffer> <LocalLeader>gd <Plug>(rust-doc)
  " rust.vim
  nmap <buffer> <LocalLeader>f :<C-u>RustFmt<CR>
endfunction

function! s:ftmd()
  " previm
  nnoremap <buffer> <LocalLeader>o :<C-u>PrevimOpen<CR>
endfunction
