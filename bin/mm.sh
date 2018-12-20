#!/bin/sh
set -eu

name="mm.sh"
file="$HOME"/Documents/mm/memo.txt
editor="${EDITOR:-vim}"
options="--color=auto -C 1 --line-number --ignore-case"

helpmsg() {
  cat >&1 <<END
Description:
  memo tool

Usage:
  $name [Options] -- STRING

Options:
  -h, --help          Display this message
  -e, --edit          Open file by editor
  -a, --append STRING Append string to file
  -c, --clean         Delete content

Examples:
  show this help
    \$ $name --help
  search string from $file
    \$ $name -- STRING
  append string to $file
    \$ $name -a STRING

END
}

errmsg() {
  echo "${name}: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

# e.g. ckargv "$@"
ckargv() {
  [ $# -eq 0 ] || abort "invalid arguments: $*"
}

append() {
  printf "%s\n%s\n\n" "$(date)" "$*" | tee -a "$file"
}

clean() {
  : > "$file"
  echo "file contents removed"
}

main() {
  grep $options --regexp "$*" -- "$file"
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
      ckargv "$@"
      exit 0
      ;;
    -e|--edit)
      shift
      ckargv "$@"
      $editor "$file"
      exit $?
      ;;
    -a|--append)
      shift
      append "$@"
      exit 0
      ;;
    -c|--clean)
      shift
      ckargv "$@"
      clean
      exit 0
      ;;
    *)
      break
      ;;
  esac
  shift
done

main "$@"

