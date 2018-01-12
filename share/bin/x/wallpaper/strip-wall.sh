#!/bin/sh

# use gm(graphicsmagick) mogrify -strip ./*
echo "be carefull. remove auther, copyright, license"
set -eu

# confirm $1=msg return bool
confirm() {
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

set +e
invalid="$(ls | \
  grep -v ".*.jpg" | \
  grep -v ".*.jpeg" | \
  grep -v ".*.png")"
set -e
if [ -n "$invalid" ]; then
  echo "find invalid filename:"
  echo "$invalid"
  exit 1
fi

confirm "gm mogrify -strip ./* ? pwd=$(pwd)" || exit 1
echo "please wait ..."
/usr/bin/gm mogrify -strip ./*
echo "done!"
# EOF
