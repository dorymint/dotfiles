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

feh --image-bg black --recursive --randomize --bg-center --no-fehbg "$wall" || echo "feh: fallthrough"
echo 'feh loop stop it?[<C-c>]:'
while sleep 1m; do
  feh --image-bg black --recursive --randomize --bg-center --no-fehbg "$wall" || echo "feh: fallthrough"
done
# EOF
