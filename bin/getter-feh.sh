#!/bin/sh
set -eu

# TODO: rewrite
background=false
file="$HOME"/dotfiles/etc/getter/conf2.json

helpmsg() {
  cat >&1 <<END
getter-feh.sh
  use default feh

options:
  -h --help help
  -bg --background
END
}

while [ -n "${1:-}" ]; do
  case "$1" in
  help|-help|--help|-h)
    helpmsg
    exit 0
    ;;
  -b|-bg|--bg|-background|--background)
    background=true
    ;;
  "")
    # pass
    ;;
  *)
    echo "unknown option: ${*}"
    exit 1
    ;;
  esac
  shift
done

[ -x "$(command which getter)" ]
bg="$(getter -conf "$file")"

if [ "$background" = "true" ]; then
  feh="feh --bg-max --"
else
  feh="feh --scale-down --"
fi
$feh "$bg"

