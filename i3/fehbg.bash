#!/bin/bash
# for i3-wm
dirs="/usr/share/backgrounds /usr/share/archlinux"
if [[ -d "$HOME/Pictures/wall" ]];then
  dirs="$dirs $HOME/Pictures/wall"
fi
feh --recursive --randomize --bg-scale $dirs
# EOF
