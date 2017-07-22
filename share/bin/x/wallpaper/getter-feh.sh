#!/bin/sh
set -eu

bgcmd="feh"
option="--scale-down"

# help
function helpmsg () {
  cat >&1 <<END
  use default feh

  -h --help help
  -bg --background

  -sway --background-sway
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   help|--help|-h) helpmsg; exit 0;;
   -bg|--background) option="--bg-max";;
   -sway|--background-sway)
     bgcmd='swaymsg -t command output "*" bg'
     option="fit";;
  esac
  shift
done
unset -f helpmsg
[ -x "$(command which getter)" ]
if [ "$bgcmd" = "feh" ];then
  $bgcmd $option "$(getter)"
else
  $bgcmd "$(getter)" $option
fi
# EOF
