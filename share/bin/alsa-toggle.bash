#!/bin/bash

# for sound output HDMI
# device number is dependent on environment
set -eu

rc="$HOME/.asoundrc"
if grep 'device 0' "$rc" > /dev/null ; then
  sed -i -e 's/device 0/device 3/' "$rc"
  echo "enable device 3"
else
  sed -i -e 's/device 3/device 0/' "$rc"
  echo "enable device 0"
fi
# EOF
