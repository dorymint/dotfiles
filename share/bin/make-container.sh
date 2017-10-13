#!/bin/sh
set -eu

# TODO: impl

dst=""
# help
function helpmsg () {
  cat >&1 <<END
  make container for nspawn
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
    help|--help|-h) helpmsg; exit 0;;
    *) dst=${1}; shift;;
    "") echo "not specify new container directory"; exit 1;;
  esac
  shift
done
unset -f helpmsg

command -v pacman
command -v pacstrap
command -v systemd-nspawn

# EOF
