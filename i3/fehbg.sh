#!/bin/sh
set -eu
# for i3-wm
wallpath="$HOME"/Pictures/wall
wall="$wallpath"/"$(ls "$wallpath" | shuf -n 1)"
option="--bg-max"
feh "$option" "$wall"
# EOF
