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

echo "mklink in $wallpaper and in $getter to $links"
bash $linkwall "$wallpaper" "$links"
bash $linkwall "$getter" "$links"
echo "read sub directory in $getter"
for x in $getter/*; do
  echo "find sub directory $x"
  if [ -d "$x" ]; then
    bash $linkwall "${x}" "$links"
  fi
done
echo "done"
# EOF
