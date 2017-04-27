#!/bin/sh
# scriptencoding utf-8
set -euB

function split () {
  echo "------- $1 -------"
}

# help
function helpmsg () {
  cat >&1 <<END
  make directory and symlink
  --help -h
  --force -f
    allow override exists files
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   help|--help|-h) helpmsg; exit 0;;
   --force|-f) option="-f "
  esac
  shift
done
unset -f helpmsg

cd "$(dirname "$(readlink -f "$0")")" && cd ../
dotroot=$(pwd -P)
option="${option:-}"" -sn"

[ -d "$HOME"/.vim ] || mkdir "$HOME"/.vim
[ -d "$HOME"/.config ] || mkdir "$HOME"/.config
[ -d "$HOME"/go ] || mkdir -p "$HOME"/go/{bin,pkg,src}

# fallthrough
set +e

split "zsh"
ln $option "$dotroot"/zsh/zshrc "$HOME"/.zshrc

split "bash"
ln $option "$dotroot"/bash/bashrc "$HOME"/.bashrc

split "git"
ln $option "$dotroot"/gitconfig "$HOME"/.gitconfig

split "vim"
ln $option "$dotroot"/vim/vimrc "$HOME"/.vimrc
ln $option "$dotroot"/vim/gvimrc "$HOME"/.gvimrc

# reconsider
#split "neovim"
#ln $option "$HOME"/.vim/ "$HOME"/.config/nvim
#ln $option "$dotroot"/vim/vimrc "$HOME"/.vim/init.vim

split "tmux"
ln $option "$dotroot"/tmux/tmux.conf "$HOME"/.tmux.conf

split "i3-wm"
ln $option "$dotroot"/i3/ "$HOME"/.i3

split "termite"
ln $option "$dotroot"/termite/ "$HOME"/.config/

set -e

# EOF
