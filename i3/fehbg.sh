#!/bin/sh
set -e
# for i3-wm
wall=""
option="--bg-max --randomize --recursive"
if [ -d "$HOME"/Pictures/wall ];then
  # override
  wall="$HOME"/Pictures/wall
fi
feh "$option" "$wall"
# EOF
