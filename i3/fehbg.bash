#!/bin/bash
# for i3-wm
wall=""
if [[ -d "$HOME"/Pictures/wall ]];then
  # override
  wall="$HOME"/Pictures/wall
fi
feh --image-bg black --recursive --randomize --bg-max "$wall"
# EOF
