#!/bin/sh

set -eu

#which awk
#which sed
#which feh
#which swaymsg

current_bg="$(awk '/feh --bg-max/ { print $3 }' "$HOME"/.fehbg |
  sed "s/^'\(.*\)'$/\1/")"
current_bg_id="$(echo "$current_bg" | awk -F / '{ print $NF }')"

walldir="$HOME"/Pictures/links
if [ ! -d "$walldir" ]; then
  abort "not directory: $walldir"
fi

next_bg=""
with_bg_id="false"

abort() {
  echo "$*" >&2
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
  \$ randombg.sh          # Display random background images
  \$ randombg.sh next     # Display next background images
  \$ randombg.sh previous # Display previous background images
END
}

main() {
  if [ -f "$next_bg" ]; then
    if [ -n "${SWAYSOCK:-}" ]; then
      swaymsg -- output "*" background "$next_bg" fill
    else
      feh --bg-max -- "$next_bg"
    fi

    [ "$with_bg_id" = "true" ] && echo "$current_bg_id"
    exit 0
  else
    abort "invalid file path: $next_bg"
    fi
}

while true; do
  case ${1:-} in
    help|-help|h|-h|--help)
      helpmsg
      exit 0
      ;;
    ""|random|-random)
      [ -z "$next_bg" ] && next_bg="$walldir"/"$(basename "$(find "$walldir" -type l | shuf -n 1)")"
      main
      ;;
    next|-next)
      next_bg="$walldir"/"$(( current_bg_id + 1 ))"
      ;;
    previous|-previous)
      next_bg="$walldir"/"$(( current_bg_id - 1 ))"
      ;;
    with-id|--with-id)
      with_bg_id="true"
      ;;
    show|-show)
      echo "$current_bg_id"
      exit 0
      ;;
    *)
      abort "Unexpected option: $*"
      ;;
  esac
  shift
done

