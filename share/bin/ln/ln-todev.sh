#!/bin/sh
set -eu
if [ ! -x "$(readlink -f "$1")" ]; then
  echo "not -x $1"
  exit 1
fi
ln -s "$(readlink -f "$1")" "$HOME"/bin/dev
