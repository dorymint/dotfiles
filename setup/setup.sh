#!/bin/sh
set -eu

# TODO: move to $dotroot/config for .config files

dotroot="$(dirname "$(dirname "$(readlink -e "$0")")")"
dotx="$dotroot"/x
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

mkd() {
  [ -d "$1" ] || mkdir -v -m 0700 -- "$1"
}

main() {
  mkd "$HOME"/bin
  mkd "$HOME"/.config

  mkd "$HOME"/.vim
  mkd "$HOME"/.config/efm-langserver

  mkd "$HOME"/go
  mkd "$HOME"/go/bin
  mkd "$HOME"/go/pkg
  mkd "$HOME"/go/src

  mkd "$HOME"/.config/systemd
  mkd "$HOME"/.config/systemd/user

  options="--verbose --symbolic --no-dereference"
  if [ "$force" = "true" ]; then
    options="$options --force"
  fi

  # fallthrough
  set +e
    # zsh
    ln $options -- "$dotroot"/zsh/zshrc "$HOME"/.zshrc
    ln $options -- "$dotroot"/zsh/zprofile "$HOME"/.zprofile

    # bash
    ln $options -- "$dotroot"/bash/bashrc "$HOME"/.bashrc
    ln $options -- "$dotroot"/bash/bash_profile "$HOME"/.bash_profile

    # git
    ln $options -- "$dotroot"/gitconfig "$HOME"/.gitconfig

    # vim
    ln $options -- "$dotroot"/vim/vimrc "$HOME"/.vimrc
    ln $options -- "$dotroot"/vim/gvimrc "$HOME"/.gvimrc

    # tmux
    ln $options -- "$dotroot"/tmux/tmux.conf "$HOME"/.tmux.conf

    # efm-langserver
    ln $options -- "$dotroot"/config/efm-langserver/config.yaml "$HOME"/.config/efm-langserver/config.yaml
  set -e

  # for xorg
  if [ "$withgui" = "true" ]; then
    # fallthrough
    set +e
      ln $options -- "$dotx"/xinitrc "$HOME"/.xinitrc
      # TODO: consider to remove
      #ln $options -- "$dotx"/xserverrc "$HOME"/.xserverrc
      ln $options -- "$dotx"/Xresources "$HOME"/.Xresources
      ln $options -- "$dotx"/fontconfig/ "$HOME"/.config/fontconfig

      # window manager
      ln $options -- "$dotx"/i3/ "$HOME"/.config/i3
      ln $options -- "$dotx"/sway/ "$HOME"/.config/sway

      # config
      ln $options -- "$dotx"/termite/ "$HOME"/.config/termite
      ln $options -- "$dotx"/conky/ "$HOME"/.config/conky
      ln $options -- "$dotx"/dunst/ "$HOME"/.config/dunst
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
      echo "unknown option: $*" 1>&2
      exit 1
      ;;
  esac
  shift
done

main

