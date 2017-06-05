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

[ -f ../ln/unlink-all.bash ] && unlink="../ln/unlink-all.bash"
[ -f ./ln-wall.bash ] && linkwall="./ln-wall.bash"

echo "unlink in $links"
bash $unlink "$links"

echo "mklink $wallpaper and $getter to $links"
bash $linkwall "$wallpaper" "$links"
bash $linkwall "$getter" "$links"

echo "done"
# EOF
