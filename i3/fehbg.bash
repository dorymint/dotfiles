#!/bin/bash
# for i3-wm
wall=""
option="--image-bg black \
  --recursive \
  --randomize \
  --bg-max \
  --magick-timeout 1"
if [[ -d "$HOME"/Pictures/wall ]];then
  # override
  wall="$HOME"/Pictures/wall
fi
#feh --image-bg black --recursive --randomize --bg-max "$wall"
feh "$option" "$wall"
# EOF
