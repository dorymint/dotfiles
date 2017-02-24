#!/bin/bash
set -eu

echo "change directory for update wallpaper"
cd "$(dirname "$(readlink -f "$0")" )"
pwd
wall="$HOME"/Pictures/wall
wallpaper="$HOME"/Pictures/wallpaper
[ -d "$wall" ]
[ -d "$wallpaper" ]

[ -f ./unlink-all.bash ]
[ -f ./ln-wall.bash ]

echo "unlink in $wall"
bash ./unlink-all.bash "$wall"

echo "mklink $wallpaper to $wall"
bash ./ln-wall.bash "$wallpaper" "$wall"

echo "done"
# EOF
