#!/bin/sh
set -eu
bgdir="$HOME"/Pictures/links
bgn="$(ls $bgdir | shuf -n 1)"
[ -n "$SWAYSOCK" ]
swaymsg -s $SWAYSOCK -t command output "*" bg "$bgdir"/"$bgn" fit
