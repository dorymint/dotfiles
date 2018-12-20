#!/bin/sh
set -eu

dotroot="$(dirname "$(readlink -e "$0")")"
options="--verbose -sn"
force=false
withx=false

helpmsg() {
  cat >&1 <<END
Description:
  make configuration directories and symbolic links

Usage:
  setup.sh [Options]

Options:
  -h, -help  Diplay this message
  -f, -force Allow override exist files
  -x, -withx Setup with xorg configuration

END
}

errmsg() {
 echo "[err] setup.sh: $*" 1>&2
}

split() {
  printf "\n------- setup %s -------\n" "$*"
}

main() {
  [ -d "$HOME"/.vim ] || mkdir -v -m 0700 -- "$HOME"/.vim
  [ -d "$HOME"/bin ] || mkdir -v -m 0700 -- "$HOME"/bin
  [ -d "$HOME"/.config ] || mkdir -v -m 0700 -- "$HOME"/.config

  # TODO: coonsider mkdir for golang
  if [ ! -d "$HOME"/go ]; then
    mkdir -v -p -- "$HOME"/go/bin
    mkdir -v -- "$HOME"/go/pkg
    mkdir -v -- "$HOME"/go/src
  fi

  if [ "$force" = "true" ]; then
    options="$options --force"
  fi

  # fallthrough
  set +e
    split "zsh"
    ln $options -- "$dotroot"/zsh/zshrc "$HOME"/.zshrc
    ln $options -- "$dotroot"/zsh/zprofile "$HOME"/.zprofile

    split "bash"
    ln $options -- "$dotroot"/bash/bashrc "$HOME"/.bashrc
    ln $options -- "$dotroot"/bash/bash_profile "$HOME"/.bash_profile

    split "git"
    ln $options -- "$dotroot"/gitconfig "$HOME"/.gitconfig

    split "vim"
    ln $options -- "$dotroot"/vim/vimrc "$HOME"/.vimrc
    ln $options -- "$dotroot"/vim/gvimrc "$HOME"/.gvimrc

    split "tmux"
    ln $options -- "$dotroot"/tmux/tmux.conf "$HOME"/.tmux.conf
  set -e

  # for xorg
  if [ "$withx" = "true" ]; then
    split "xorg"
    [ -d "$HOME"/.config/systemd/user ] || mkdir -v -p "$HOME"/.config/systemd/user

    # fallthrough
    set +e
      ln $options -- "$dotroot"/x/xinitrc "$HOME"/.xinitrc
      # TODO: consider to remove
      #ln $options -- "$dotroot"/x/xserverrc "$HOME"/.xserverrc
      ln $options -- "$dotroot"/x/Xresources "$HOME"/.Xresources
      ln $options -- "$dotroot"/x/fontconfig/ "$HOME"/.config/fontconfig

      # window manager
      ln $options -- "$dotroot"/x/i3/ "$HOME"/.i3
      ln $options -- "$dotroot"/x/sway/ "$HOME"/.sway

      # config
      ln $options -- "$dotroot"/x/termite/ "$HOME"/.config/termite
      ln $options -- "$dotroot"/x/conky/ "$HOME"/.config/conky
      ln $options -- "$dotroot"/x/dunst/ "$HOME"/.config/dunst
    set -e
  fi
}

while true; do
  case "${1:-}" in
    help|-help|--help|-h)
      helpmsg
      exit 0
      ;;
    -force|--force|-f)
      force=true
      ;;
    -withx|--withx|-x)
      withx=true
      ;;
    "")
      main
      exit 0
      ;;
    *)
      helpmsg
      errmsg "unknown option: $*"
      exit 1
      ;;
  esac
  shift
done

