#!/bin/sh

set -eu

current_bg_id=$(awk '/feh --bg-max/ { print $3 }' "$HOME"/.fehbg |
  sed "s/^'\(.*\)'$/\1/" |
  awk -F / '{ print $NF }')
walldir="$HOME"/Pictures/links
next_bg=""
with_bg_id="false"

errmsg() {
  echo "[err] randombg.sh: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

helpmsg() {
  cat >&1 <<END
Usage:
  randombg.sh [Options]

Options:
  help, -help         Show this help
  random, -random     Display random background images (default)
  next, -next         Display next background images
  previous, -previous Display previous backgroud images
  with-id, --with-id  Output with image id
  show, -show         Show current background image id

Examples:
  randombg.sh
    Display random background images
  randombg.sh next
    Display next background images
  randombg.sh previous
    Display previous background images
END
}

main() {
  if [ -f "$next_bg" ]; then
    feh --bg-max -- "$next_bg"
    [ "$with_bg_id" = "true" ] && echo "$current_bg_id"
    exit 0
  else
    abort "invalid file path: $next_bg"
  fi
}

if [ ! -d "$walldir" ]; then
  abort "not directory: $walldir"
fi

while true; do
  case ${1:-} in
    help|-help|h|-h|--help)
      helpmsg
      exit 0
      ;;
    ""|random|-random)
      [ -z "$next_bg" ] && next_bg="$walldir"/"$(ls "$walldir" | shuf -n 1)"
      main
      ;;
    next|-next)
      next_bg="$walldir"/"$(expr "$current_bg_id" + 1)"
      ;;
    previous|-previous)
      next_bg="$walldir"/"$(expr "$current_bg_id" - 1)"
      ;;
    with-id|--with-id)
      with_bg_id="true"
      ;;
    show|-show)
      echo "$current_bg_id"
      exit 0
      ;;
    *)
      errmsg "Unexpected option: $*"
      exit 1
      ;;
  esac
  shift
done
