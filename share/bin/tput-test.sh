#!/bin/sh
set -eu
for c in {0..255}; do
  tput setaf $c
  echo -n -e "$c\t"
  [ $(expr $(expr $c + 1) % 8) -eq 0 ] && echo
done
tput sgr0
echo
