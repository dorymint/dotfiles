#!/bin/sh
set -eu

# help
helpmsg() {
  cat >&1 <<END
Options:
  -h --help
    Show help

Examples:

END
}

# main
main() {
  echo "Do something"
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
      echo "Unknown option: $*"
      exit 1
      ;;
  esac
  shift
done
