#!/bin/sh

### depends on ../wallpaper/getter-toggle.sh

set -eu

# cds(change to script directory)
cd "$(dirname "$(readlink -f "$0")")"

[ -x ../wallpaper/getter-toggle.sh ]
../wallpaper/getter-toggle.sh --service sway-getter.service --timer sway-getter.timer
