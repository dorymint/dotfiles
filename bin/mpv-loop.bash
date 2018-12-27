#!/bin/bash
set -eu

#name="$(basename $0)"
name="mpv-loop.bash"

loops="yes"
full=false

helpmsg() {
  cat >&1 <<END
Description:
  for slideshow of gif animation

Usage:
  $name [Options]

Options:
  -h, --help Display this message
  -l NUMBER  Specify loop count
  -f         Fullscreen

Examples:
  $name --help

END
}

errmsg() {
  echo "$name: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

main() {
  [ $# -eq 1 ] || abort "unexpected arguments $*"
  [ -d "$1" ] || abort "not directory $1"
  mpv="mpv --loop-file=$loops"
  if [ "$full" = "true" ]; then
    mpv="$mpv --fullscreen"
  fi
  for x in "$1"/*; do
    $mpv -- "$x"
    echo -n 'push "q" or "n" to return >'
    read -r -t 0.2 -n 1 key || :
    case "$key" in
      q|n) break ;;
      *) ;;
    esac
    echo
  done
}

while true; do
  case "${1:-}" in
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
    -l)
      shift
      case "$1" in
        ''|*[!0-9]*) abort "not number" ;;
        *) ;;
      esac
      loops="$1"
      ;;
    -f)
      full=true
      ;;
    *)
      break
      ;;
  esac
  shift
done

main "$@"
