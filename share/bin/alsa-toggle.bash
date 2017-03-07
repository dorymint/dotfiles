#!/bin/bash

# for sound output HDMI
# device number is dependent on environment
set -eu
helpmsg() {
  cat >&1 <<END
toggle output sound device for HDMI

  -h --help
      display help message
  -s --show
      show grep device\n
END
}
case "${1:-}" in
  "-h"|"--help") helpmsg ; exit 0;;
  "-s"|"--show") grep 'device' "$rc"; exit 0;;
esac

if test ! -r "$HOME"/.asoundrc; then
  echo "not found $HOME/.asoundrc"
  exit 1
fi

rc="$HOME"/.asoundrc
if grep 'device 0' "$rc" > /dev/null ; then
  sed -i -e 's/device 0/device 3/' "$rc"
  echo "enable device 3"
else
  sed -i -e 's/device 3/device 0/' "$rc"
  echo "enable device 0"
fi
# EOF
