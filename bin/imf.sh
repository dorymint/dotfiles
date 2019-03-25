#!/bin/sh
set -eu

# Start input method frameworks

name=imf.sh
imf=ibus

helpmsg() {
  cat >&1 <<END
Description:
  start input method frameworks for sway (default $imf)

Usage:
  $name [Options]
  $name [ibus|fcitx]

Options:
  -h, --help         Display this message
  start [ibus|fcitx] Specify start input method framework

Examples:
  $name --help      # display help messages
  $name             # start $imf
  $name start fcitx # start fcitx
END
}

errmsg() {
  printf "%s\n" "$*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

main() {
  case "$imf" in
    ibus)
      if command -v ibus-daemon > /dev/null 2>&1; then
        export GTK_IM_MODULE=ibus
        export XMODIFIERS=@im=ibus
        export QT_IM_MODULE=ibus
        ibus-daemon -r --xim &
      fi
      ;;
    fcitx)
      if command -v fcitx-autostart > /dev/null 2>&1; then
        export GTK_IM_MODULE=fcitx
        export XMODIFIERS=@im=fcitx
        export QT_IM_MODULE=fcitx
        fcitx-autostart
      fi
      ;;
    *) abort "invalid imf $imf";;
  esac
}

while [ $# -ne 0 ]; do
  case "$1" in
    --)
      shift
      break
      ;;
    -h|--help|h|help|-help)
      helpmsg
      shift
      [ $# -eq 0 ] || abort "invalid arguments:$*"
      exit 0
      ;;
    start)
      shift
      imf="$1"
      ;;
    *)
      abort "invalid arguments:$*"
      break
      ;;
  esac
  shift
done

main

