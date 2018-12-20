#!/bin/sh
set -eu

#name="$(basename $0)"
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
  echo "$name: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

main() {
  echo "not implemented \"$*\""
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
    *)
      break
      ;;
  esac
  shift
done

main "$@"

