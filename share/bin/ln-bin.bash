#!/bin/bash
cd $(dirname "$0")
dst="$HOME"/bin
for x in *; do
  [ ! -x "$x" ] && continue
  ln -s "$(pwd)/$x" "$dst"
done
# EOF
