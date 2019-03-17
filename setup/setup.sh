#!/bin/sh
set -eu

# TODO: move to $dotroot/config for .config files

dotroot="$(dirname "$(dirname "$(readlink -e "$0")")")"
force=false
withgui=false

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME"/.config}"

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
  builtin command -v ln > /dev/null
  ln="ln --verbose --symbolic --no-dereference"
  if [ "$force" = "true" ]; then
    ln="$ln --force"
  fi
  ln="$ln --"

  # base
  mkd "$HOME"/bin
  mkd "$XDG_CONFIG_HOME"

  # vim
  mkd "$HOME"/.vim
  mkd "$XDG_CONFIG_HOME"/efm-langserver

  # go
  mkd "$HOME"/go
  mkd "$HOME"/go/bin
  mkd "$HOME"/go/pkg
  mkd "$HOME"/go/src

  # systemd
  mkd "$XDG_CONFIG_HOME"/systemd
  mkd "$XDG_CONFIG_HOME"/systemd/user

  # fallthrough
  set +e
    # zsh
    $ln "$dotroot"/shell/zsh/zshrc "$HOME"/.zshrc
    $ln "$dotroot"/shell/zsh/zprofile "$HOME"/.zprofile

    # bash
    $ln "$dotroot"/shell/bash/bashrc "$HOME"/.bashrc
    $ln "$dotroot"/shell/bash/bash_profile "$HOME"/.bash_profile

    # git
    $ln "$dotroot"/gitconfig "$HOME"/.gitconfig

    # vim
    $ln "$dotroot"/vim/vimrc "$HOME"/.vimrc
    $ln "$dotroot"/vim/gvimrc "$HOME"/.gvimrc

    # tmux
    $ln "$dotroot"/tmux/tmux.conf "$HOME"/.tmux.conf

    # efm-langserver
    $ln "$dotroot"/config/efm-langserver/config.yaml "$XDG_CONFIG_HOME"/efm-langserver/config.yaml
  set -e

  # with gui
  if [ "$withgui" = "true" ]; then


    mkd "$XDG_CONFIG_HOME"/fontconfig
    mkd "$XDG_CONFIG_HOME"/sway
    mkd "$XDG_CONFIG_HOME"/sway/local.d

    # TODO: fix
    #mkd "$XDG_CONFIG_HOME"/i3

    mkd "$XDG_CONFIG_HOME"/termite
    mkd "$XDG_CONFIG_HOME"/conky
    mkd "$XDG_CONFIG_HOME"/dunst

    # fallthrough
    set +e
      # x
      $ln "$dotroot"/x/xinitrc "$HOME"/.xinitrc
      $ln "$dotroot"/x/Xresources "$HOME"/.Xresources
      # reuse
      $ln "$dotroot"/x/Xresources "$HOME"/.Xdefaults

      # remove?
      #$ln "$dotroot"/x/xserverrc "$HOME"/.xserverrc

      $ln "$dotroot"/config/fontconfig/fonts.conf "$XDG_CONFIG_HOME"/fontconfig/fonts.conf

      # window manager

      # TODO: fix
      $ln "$dotroot"/config/i3/ "$XDG_CONFIG_HOME"/i3

      $ln "$dotroot"/config/sway/config "$XDG_CONFIG_HOME"/sway/config
      $ln "$dotroot"/config/sway/mode.conf "$XDG_CONFIG_HOME"/sway/mode.conf

      # termite
      $ln "$dotroot"/config/termite/config "$XDG_CONFIG_HOME"/termite/config
      $ln "$dotroot"/config/termite/gtk.css "$XDG_CONFIG_HOME"/termite/gtk.css

      # conky
      $ln "$dotroot"/config/conky/conky.conf "$XDG_CONFIG_HOME"/conky/conky.conf

      # dunst
      $ln "$dotroot"/config/dunst/dunstrc "$XDG_CONFIG_HOME"/dunst/dunstrc
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

