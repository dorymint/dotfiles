#!/bin/bash

# for sound output HDMI
# device number is dependent on environment
set -e
if test ! -r "$HOME"/.asoundrc; then
  echo "not found $HOME/.asoundrc"
  exit 1
fi

rc="$HOME"/.asoundrc

case "$1" in
  "show") grep 'device' "$rc"; exit 0;;
  "") ;;
  *) exit 1;;
esac

if grep 'device 0' "$rc" > /dev/null ; then
  sed -i -e 's/device 0/device 3/' "$rc"
  echo "enable device 3"
else
  sed -i -e 's/device 3/device 0/' "$rc"
  echo "enable device 0"
fi
# EOF
