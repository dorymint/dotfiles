#!/bin/sh
set -eu

name="start-imf.sh"
imf=${XMODIFIERS#@im=}

helpmsg() {
  cat >&1 <<END
Description:
  start input method frameworks for sway (default $imf)

Usage:
  $name [Options]

Options:
  -h, --help Display this message

Examples:
  $name --help

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
    ibus) ibus-daemon -drx ;;
    fcitx) fcitx-autostart;;
    *) abort "can not manage $imf";;
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
      [ $# -eq 0 ] || abort "invalid arguments: $*"
      exit 0
      ;;
    *)
      break
      ;;
  esac
  shift
done

main "$@"

