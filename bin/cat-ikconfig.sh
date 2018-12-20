#!/bin/sh

# cat In-kernel config

set -eu

kconfgz=/proc/config.gz

helpmsg() {
  cat >&1 <<END

Usage:
  cat-ikconfig.sh [Options]

Options:
  -h, --help Display this message

Examples:

END
}

errmsg() {
  echo "$@" 1>&2
}

main() {
  gunzip --stdout "${kconfgz}"
}

while true; do
  case "${1:-}" in
    help|-help|--help|-h)
      helpmsg
      exit 0
      ;;
    "")
      main
      exit 0
      ;;
    *)
      errmsg "Unknown option: $*"
      exit 1
      ;;
  esac
  shift
done
