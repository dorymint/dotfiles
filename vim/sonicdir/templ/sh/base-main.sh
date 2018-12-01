#!/bin/sh
set -eu

helpmsg() {
  cat >&1 <<END
Description:
  {{_cursor_}}Short description

Usage:
  {{_expr_:expand("%:t")}} [Options]

Options:
  -h, --help Display this message

Examples:
  {{_expr_:expand("%:t")}} --help

END
}

errmsg() {
  echo "[err] {{_expr_:expand("%:t")}}: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

main() {
  echo "do something"
}

while true; do
  case "${1:-}" in
    -h|--help|h|help|-help)
      helpmsg
      exit 0
      ;;
    "")
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
