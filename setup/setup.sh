#!/bin/sh
set -eu

dotroot="$(dirname "$(readlink -e "$0")")"
dotgui="$dotroot"/x
options="--verbose -sn"
force=false
withgui=false

helpmsg() {
  cat >&1 <<END
Description:
  make configuration directories and symbolic links

Usage:
  setup.sh [Options]

Options:
  -h, --help  Diplay this message
  -f, --force Allow override exist files
  -x, --withx Setup with xorg configuration
  -g, --gui   Setup with gui, same -x

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
  if [ "$withgui" = "true" ]; then
    split "xorg"
    [ -d "$HOME"/.config/systemd/user ] || mkdir -v -p -- "$HOME"/.config/systemd/user

    # fallthrough
    set +e
      ln $options -- "$dotgui"/xinitrc "$HOME"/.xinitrc
      # TODO: consider to remove
      #ln $options -- "$dotgui"/xserverrc "$HOME"/.xserverrc
      ln $options -- "$dotgui"/Xresources "$HOME"/.Xresources
      ln $options -- "$dotgui"/fontconfig/ "$HOME"/.config/fontconfig

      # window manager
      ln $options -- "$dotgui"/i3/ "$HOME"/.i3
      ln $options -- "$dotgui"/sway/ "$HOME"/.sway

      # config
      ln $options -- "$dotgui"/termite/ "$HOME"/.config/termite
      ln $options -- "$dotgui"/conky/ "$HOME"/.config/conky
      ln $options -- "$dotgui"/dunst/ "$HOME"/.config/dunst
    set -e
  fi
}

while [ $# -ne 0 ]; do
  case "$1" in
    help|-help|--help|-h)
      helpmsg
      exit 0
      ;;
    -force|--force|-f)
      force=true
      ;;
    -withx|--withx|-x|-g|--gui)
      withgui=true
      ;;
    *)
      helpmsg
      errmsg "unknown option: $*"
      exit 1
      ;;
  esac
  shift
done

main

