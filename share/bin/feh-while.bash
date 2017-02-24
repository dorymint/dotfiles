#!/bin/bash

set -e

# TODO: reconsider filepath
filetype='*[\(jpg\)\|\(png\)]'
wall="/usr/share/archlinux/wallpaper/$filetype
/usr/share/backgrounds/mate/*/$filetype
/usr/share/backgrounds/xfce/$filetype"
if [[ -d "$HOME"/Pictures/wall ]]; then
  # override
  wall="$HOME"/Pictures/wall
fi

option="--image-bg black --recursive --randomize --bg-max --no-fehbg"

feh $option "$wall" || echo "feh: fallthrough"
echo 'feh loop stop it?[<C-c>]:'
while sleep 1m; do
  feh $option "$wall" || echo "feh: fallthrough"
done
# EOF
