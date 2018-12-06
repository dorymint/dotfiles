#!/bin/sh
set -eu

name="{{_expr_:expand("%:t")}}"

helpmsg() {
  cat >&1 <<END
Description:
  {{_cursor_}}short description

Usage:
  $name [Options]

Options:
  -h, --help Display this message

Examples:
  $name --help

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

main() {
  echo "do something"
}

while true; do
  case "${1:-}" in
    -h|--help|h|help|-help)
      helpmsg
      shift
      ckargv "$@"
      exit 0
      ;;
    "")
      ckargv "$@"
      main
      exit 0
      ;;
    *)
      errmsg "unknown option: $*"
      exit 1
      ;;
  esac
  shift
done

