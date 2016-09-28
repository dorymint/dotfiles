scriptencoding utf-8
"
" plugin_manage_plug
"

" plug tuto {{{
"" vim-plug: Vim plugin manager
"" ============================
""   call plug#begin('~/.vim/plugged')
""
""   " Make sure you use single quotes
""   Plug 'junegunn/vim-easy-align'
""
""   " Any valid git URL is allowed
""   Plug 'https://github.com/junegunn/vim-github-dashboard.git'
""
""   " Group dependencies, vim-snippets depends on ultisnips
""   Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
""
""   " On-demand loading
""   Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
""   Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
""
""   " Using a non-master branch
""   Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
""
""   " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
""   Plug 'fatih/vim-go', { 'tag': '*' }
""
""   " Plugin options
""   Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
""
""   " Plugin outside ~/.vim/plugged with post-update hook
""   Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
""
""   " Unmanaged plugin (manually installed and updated)
""   Plug '~/my-prototype-plugin'
""
""   " Add plugins to &runtimepath
""   call plug#end()
""
"" Then reload .vimrc and :PlugInstall to install plugins.
""
"" Plug options:
""
""| Option                  | Description                                      |
""| ----------------------- | ------------------------------------------------ |
""| `branch`/`tag`/`commit` | Branch/tag/commit of the repository to use       |
""| `rtp`                   | Subdirectory that contains Vim plugin            |
""| `dir`                   | Custom directory for the plugin                  |
""| `as`                    | Use different name for the plugin                |
""| `do`                    | Post-update hook (string or funcref)             |
""| `on`                    | On-demand loading: Commands or `<Plug>`-mappings |
""| `for`                   | On-demand loading: File types                    |
""| `frozen`                | Do not update unless explicitly specified        |
""
"" More information: https://github.com/junegunn/vim-plug
"" }}}


"-----| plug begin |-----" {{{
call plug#begin('~/.vim/plugged')
  " edit
    Plug 'junegunn/vim-easy-align'

  "status
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

  " git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

  " file
    Plug 'scrooloose/nerdtree'
    Plug 'ctrlpvim/ctrlp.vim'

  " manage
    Plug 'majutsushi/tagbar'
      " require ctags
    Plug 'thinca/vim-quickrun'
    Plug 'thinca/vim-ref'

  " IED like
    Plug 'scrooloose/syntastic'
    "Plug 'fatih/vim-go'
      " 少し大きすぎるので今のところコメントアウト
    Plug 'vim-jp/vim-go-extra'
    Plug 'google/vim-ft-go'
      " vim-ft-goはvimのversionが新しければ、本体にmergeされているらしい

  " snippet
    Plug 'mattn/sonictemplate-vim'
    "Plug 'SirVer/ultisnips'
    "Plug 'honza/vim-snippets'

  " syntax
    "Plug 'tpope/vim-markdown'
    "Plug 'plasticboy/vim-markdown'

  " color
    "Plug 'altercation/vim-colors-solarized'
    Plug 'w0ng/vim-hybrid'
    Plug 'cocopon/Iceberg.vim'

  " web
    Plug 'mattn/webapi-vim'

  " etc
    Plug 'mattn/vim-soundcloud'
      " require... mplayer ctrlp.vim webapi-vim
call plug#end()
"-----| plug end |-----" }}}


"-----| plugin config |-----"{{{
" status {{{
  " vim-airline {{{
    "let g:airline_theme='papercolor'
    "let g:airline_theme='hybrid'
    let g:airline#extensions#tabline#enabled = 1
    "let g:airline#extensions#tabline#show_buffers = 0
    "let g:airline#extensions#tabline#tab_nr_type = 1
  " }}}
" }}}

" manage {{{
  " tagbar {{{
    if (has('win32') || has('win64'))
      " path to local biuld ctags.exe
      if executable(glob('~/opt/ctags/ctags.exe'))
        let g:tagbar_ctags_bin = expand(glob('~/opt/ctags/ctags.exe'))
      else
        echo "do not find ctags.exe"
      endif
    endif
    " go config... require gotags
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
  " }}}

  " vim-quickrun {{{
  if 1 == 0
    let g:quickrun_no_default_key_mappings = 1
      " NOTE: 上を設定するとデフォルトマップが無効になる
  endif
  " }}}
" }}}


" IED like {{{
  " vim-go {{{
    if 1 == 0
    " NOTE: 今は使ってないので読まない様にしておく
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
  " }}}
  " sytastic {{{
    let g:syntastic_mode_map = { 'mode': 'active' }
    " golang
    let g:syntastic_go_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
    let g:syntastic_go_checkers = ['golin', 'govet', 'errcheck', 'gometalinter']
      " gometalinterは他の多くのパッケージに依存しているので注意
      " といかmeta linter. lintermanagerみたい
      " $gometalinter --install で依存パッケージをインストールできるらしい
      " checkerはgometalinterだけ登録すればいいのかよくわかっていない...取り敢えず動く
        ""Installing:
        ""  structcheck
        ""  aligncheck
        ""  deadcode
        ""  gocyclo
        ""  ineffassign
        ""  dupl
        ""  golint
        ""  gotype
        ""  goimports
        ""  errcheck
        ""  varcheck
        ""  interfacer
        ""  goconst
        ""  gosimple
        ""  staticcheck
        ""  unused
        ""  misspell
        ""  lll
    " cpp
    let g:syntastic_cpp_compiler = 'clang++'
    let g:syntastic_cpp_compiler_options = ' -lstdc++ -std=c++11'
    let g:syntastic_cpp_checkers = ['clang-tidy', 'clang_checker', 'gcc']
    let g:syntastic_cpp_mode_map = { 'mode': 'active', 'passive_filetypes': ['cpp'] }
      " require clang-tidy?
  " }}}
" }}}

" snippet
  " sonictemplate-vim {{{
    if isdirectory(glob('~/dotfiles/vim/sonicdir'))
      let g:sonictemplate_vim_template_dir = '~/dotfiles/vim/sonicdir'
    else
      echo "template directory: sonicdir disable"
    endif
  " }}}
  " ultisnips {{{
    if 1 == 0
      let g:UltiSnipsExpandTrigger = "<tab>"
      let g:UltiSnipsJumpForwardTrigger = "<tab>"
      let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"
      let g:UltiSnipsEditSplit = "vertical"
    endif
  " }}}

" color
  " vim-colors-solarized {{{
    if has('win32') && has('win64')
    else
      let g:solarized_termcolors = 256
    endif
  " }}}


" -----| plugin config END |----- }}}


"-----| plugin keymap |-----"
" NOTE:
" プラグインのプレフィックスは<C-@>を基本に設定してみる
" Filetypeでスイッチするマップは次の | autocmd | で定義する
" CtrlPは<ctrl-p>のまま変えない
  " easy-alignon
    xmap <C-@>ea  <Plug>(EasyAlign)
    nmap <C-@>ea  <Plug>(EasyAlign)
  " syntastic
    nnoremap <C-@>s   :<C-u>SyntasticToggleMode<nl>
      " NOTE:
      " 保存時に常に走らせると少し重い時があるのでトグルをマップ
      " 非同期でチェックできる良いプラグインがあれば乗り換えたい
  " NERDTree
    nnoremap <C-@>n   :<C-u>NERDTreeToggle<nl>
  " tagbar
    nnoremap <C-@>t   :<C-u>TagbarToggle<nl>
  " sonictemplate
    if isdirectory(glob('~/dotfiles/vim/sonicdir'))
      nnoremap <C-@>w :<C-u>10split ~/dotfiles/vim/sonicdir/%:e/
        " NOTE: すぐにテンプレートを編集できるように
    endif


"-----| plugin autocmd |-----"
filetype indent plugin on
augroup plugin_manage_plug
  autocmd!
  " vim-go-extra
    " Godocのキーマップ
    autocmd Filetype go nnoremap <buffer> <S-k>   :<C-u>Godoc
augroup END
" EOF