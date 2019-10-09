#!/bin/bash

# git clone repository into ~/src/URN/

set -eu

dry=false

case $# in
  0)
    echo "URL not specify" >&2
    exit 1
    ;;
  1)
    # pass
    ;;
  2)
    case "$1" in
      -d|-dry|--dry|--dry-run)
        dry=true
        shift
        ;;
    esac
    ;;
  *)
    echo "unexpected arguments: $*" >&2
    exit 1
    ;;
esac

url="$1"
path="$url"
case "$url" in
  http://*)
    path="${path#"http://"}"
    ;;
  https://*)
    path="${path#"https://"}"
    ;;
  *)
    echo "unexpected arguments: $url" >&2
    exit 1
    ;;
esac
path="$(readlink -m /"$path")"
path="${path%".git"}"

dir="$HOME/src"
dir="${dir}${path}"

if [ -e "$dir" ]; then
  echo "already exist in $dir" >&2
  exit 1
fi

echo "URL:   $url"
echo "Path:  $path"
echo "Local: $dir"

echo
echo "<Enter>"
read -r

if [ "$dry" = true ]; then
  echo "git clone -- \"$url\" \"$dir\""
  exit 0
fi

git clone -- "$url" "$dir"

