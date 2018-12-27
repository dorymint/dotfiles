#!/bin/sh
set -eu

[ $# -eq 1 ] || exit 1

case "$1" in
  ''|*[!0-9]*) exit 2 ;;
  *) ;;
esac

for x in $(seq 0 "$1"); do
  tput setaf "$x"; echo "setaf=$x"; tput sgr0
done

