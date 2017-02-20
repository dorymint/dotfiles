#!/bin/bash

cd $(dirname "$0")
dst="$HOME"/bin
for x in $(ls); do
  #[ "ln-bin.bash" == "$x" ] && continue
  [ ! -x "$x" ] && continue
  ln -s "$(pwd)/$x" "$dst"
done
# EOF
