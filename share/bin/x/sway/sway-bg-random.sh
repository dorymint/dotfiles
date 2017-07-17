#!/bin/sh
set -eu
bgdir="$HOME"/Pictures/links
bgn="$(ls $bgdir | shuf -n 1)"
swaymsg output "*" bg "$bgdir"/"$bgn" fit
# EOF
