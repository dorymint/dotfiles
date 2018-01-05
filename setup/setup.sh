#!/bin/sh
# scriptencoding utf-8
set -euB

# TODO: consider setup scripts

function split () {
  echo "------- setup $1 -------"
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
   --force|-f) lnopt="-f"
  esac
  shift
done
unset -f helpmsg

cd "$(dirname "$(readlink -f "$0")")" && cd ../
dotroot=$(pwd -P)
lnopt="-sn ""${lnopt:-}"

[ -d "$HOME"/.vim ] || mkdir "$HOME"/.vim
[ -d "$HOME"/go ] || mkdir -p "$HOME"/go/{bin,pkg,src}
[ -d "$HOME"/bin ] || mkdir "$HOME"/bin
[ -d "$HOME"/bin/dev ] || mkdir "$HOME"/bin/dev
[ -d "$HOME"/.config ] || mkdir "$HOME"/.config
[ -d "$HOME"/.config/nvim ] || mkdir -p "$HOME"/.config/nvim
[ -d "$HOME"/.config/systemd/user ] || mkdir -p "$HOME"/.config/systemd/user

# fallthrough
set +e
  split "zsh"
  ln $lnopt "$dotroot"/zsh/zshrc "$HOME"/.zshrc
  ln $lnopt "$dotroot"/zsh/zprofile "$HOME"/.zprofile

  split "bash"
  ln $lnopt "$dotroot"/bash/bashrc "$HOME"/.bashrc
  ln $lnopt "$dotroot"/bash/bash_profile "$HOME"/.bash_profile

  split "git"
  ln $lnopt "$dotroot"/gitconfig "$HOME"/.gitconfig

  split "vim"
  ln $lnopt "$dotroot"/vim/vimrc "$HOME"/.vimrc
  ln $lnopt "$dotroot"/vim/gvimrc "$HOME"/.gvimrc

  # TODO: reconsider neovim
  #split "neovim"
  #cp -i "$dotroot"/vim/vimrc "$HOME"/.config/nvim/init.vim

  split "tmux"
  ln $lnopt "$dotroot"/tmux/tmux.conf "$HOME"/.tmux.conf
set -e

# EOF
