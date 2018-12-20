#!/bin/sh
set -eu

abort() {
  echo "$*" >&2
  exit 2
}

[ $# -ne 1 ] &&  abort "invalid arguments $*"

if [ -d "$1" ]; then
  for x in "$(readlink -e "$1")"/*; do
    if [ -L "$x" ]; then
      readlink -e "$x" || rm "$x"
    fi
  done
  exit 0
fi

if [ -L "$1" ]; then
  if [ -L "$1" ]; then
    readlink -e "$1" || rm "$1"
  fi
else
  abort "not symbolic link $1"
fi

