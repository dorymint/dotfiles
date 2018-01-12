#!/bin/sh
set -eu

# help
helpmsg() {
  cat >&1 <<END
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
    help|-help|--help|-h) helpmsg; exit 0;;
    *)echo "unknown option: $*"; exit 1;;
    "");;
  esac
  shift
done
unset -f helpmsg

# EOF
