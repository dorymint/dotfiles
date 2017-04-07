#!/bin/sh

# use gm(graphicsmagick) convert $in -strip $out
echo "be carefull. remove auther, copyright, license"
set -eu

# confirm $1=msg return bool
function confirm () {
  local key=""
  local counter=0
  while [ $counter -lt 3 ]; do
    counter=`expr $counter + 1`
    echo -n "$1 [yes:no]?>"
    read -t 60 key || return 1
    case "$key" in
      "no"|"n") return 1;;
      "yes"|"y") return 0;;
    esac
  done
  return 1
}

cd "$1"
confirm "gm convert -strip all files? in $(pwd)" || exit 1
for x in *; do
  gm convert "$x" -strip "$x"
done

# EOF
