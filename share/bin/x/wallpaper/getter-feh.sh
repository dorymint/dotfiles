#!/bin/sh
set -eu

bgcmd="feh"
option="--scale-down"

# help
helpmsg() {
  cat >&1 <<END
getter-feh.sh
  use default feh

options:
  -h --help help
  -bg --background
  -sway --background-sway
END
}
while [ -n "${1:-}" ]; do
  case "${1}" in
  help|-help|--help|-h)
    helpmsg
    exit 0
    ;;
  -bg|-background|--background)
    option="--bg-max"
    ;;
  -sway|-background-sway|--background-sway)
    bgcmd='swaymsg -t command output "*" bg'
    option="fit"
    ;;
  "")
    ;;
  *)
    echo "unknown option: ${*}"
    exit 1
    ;;
  esac
  shift
done
unset -f helpmsg
[ -x "$(command which getter)" ]
if [ "${bgcmd}" = "feh" ];then
  ${bgcmd} ${option} "$(getter)"
else
  ${bgcmd} "$(getter)" ${option}
fi
