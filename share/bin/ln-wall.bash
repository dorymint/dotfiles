#!/bin/bash

# for make link wallpaper
# $1 wallpapers directry
# $2 dst directory

set -eu

wallsdir=${1:-invalidstate}
dst=${2:-invalidstate}
if [[ "$wallsdir" == "invalidstate" ]] || [[ "$dst" == "invalidstate" ]];then
  echo "invalid state"
  echo '$1=wallsdir $2=dst'
  exit 1
fi

dst=$(cd "$dst" && pwd)
count=$(find "$dst" -type l | wc -l)

wallsdir=$(cd "$wallsdir" && pwd)
cd "$wallsdir"
for x in * ; do
  ln -s "$wallsdir/$x" "$dst/$count"
  count=$(expr $count + 1)
done
# EOF
