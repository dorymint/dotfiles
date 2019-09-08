#!/bin/sh
set -eu

# Start input method frameworks
name=imf.sh
imf="${XMODIFIERS#@im=}"

helpmsg() {
  cat >&1 <<END
Description:
  start input method frameworks for sway (default $imf)

Usage:
  $name [Options]

Options:
  -h, --help         Display this message

Examples:
  $name --help      # display help messages
  $name             # start
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
        ibus-daemon -r --xim &
        return
      fi
      ;;
    fcitx)
      if command -v fcitx-autostart > /dev/null 2>&1; then
        fcitx-autostart
        return
      fi
      ;;
    *) abort "invalid imf $imf";;
  esac
  abort "not found imf: $imf"
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
    *)
      abort "invalid arguments:$*"
      break
      ;;
  esac
  shift
done

main

