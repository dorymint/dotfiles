#!/bin/bash
set -eu

echo "change directory for update wallpaper"
cd "$(dirname "$(readlink -f "$0")" )"
pwd
links="$HOME"/Pictures/links
wallpaper="$HOME"/Pictures/wallpaper
getter="$HOME"/Pictures/getter
[ -d "$links" ]
[ -d "$wallpaper" ]
[ -d "$getter" ]

[ -f ./unlink-all.bash ]
[ -f ./ln-wall.bash ]

echo "unlink in $links"
bash ./unlink-all.bash "$links"

echo "mklink $wallpaper and $getter to $links"
bash ./ln-wall.bash "$wallpaper" "$links"
bash ./ln-wall.bash "$getter" "$links"

echo "done"
# EOF
