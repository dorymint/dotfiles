#!/bin/sh
set -e
# for i3-wm
wall=""
option="--image-bg black \
  --recursive \
  --randomize \
  --bg-max"
if [ -d "$HOME"/Pictures/wall ];then
  # override
  wall="$HOME"/Pictures/wall
fi
feh "$option" "$wall"
# EOF
