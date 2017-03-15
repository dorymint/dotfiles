#!/bin/sh

set -eu

# NOTE: all wallpaper are use symlink
wall=""
if [ -d "$HOME"/Pictures/wall ]; then
  # override
  wall="$HOME"/Pictures/wall
fi

option="--image-bg black \
  --recursive \
  --randomize \
  --bg-max \
  --no-fehbg"
feh $option "$wall"
while sleep 1m; do
  feh $option "$wall"
done
# EOF
