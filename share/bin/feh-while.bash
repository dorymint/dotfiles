#!/bin/bash

set -e

# TODO: reconsider filepath
filetype='*[\(jpg\)\|\(png\)]'
wall="/usr/share/archlinux/wallpaper/$filetype
/usr/share/backgrounds/mate/*/$filetype
/usr/share/backgrounds/xfce/$filetype"
if [[ -d "$HOME/Pictures/wall" ]]; then
  wall="$HOME/Pictures/wall/$filetype"
fi

echo "feh loop stop it?[<C-c>]:"
while true; do
  feh --randomize --bg-center --no-fehbg $wall || echo "feh: fallthrough"
  sleep 1m
done
# EOF
