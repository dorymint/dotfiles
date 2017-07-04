#!/bin/sh
set -eu

option="--scale-down"

# help
function helpmsg () {
  cat >&1 <<END
  -h --help help
  -bg --background
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   help|--help|-h) helpmsg; exit 0;;
   -bg|--background) option="--bg-max";;
  esac
  shift
done
unset -f helpmsg
[ -x "$(command which getter)" ]
[ -x "$(command which feh)" ]
feh $option "$(getter)"
# EOF
