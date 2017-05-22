#!/bin/bash

# for sound output HDMI
# device number is dependent on environment
set -eu
rc="$HOME"/.asoundrc

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


if [ ! -f "$rc" ]; then
  echo "not found $rc"
  exit 1
fi


if grep 'device 0' "$rc" > /dev/null ; then
  sed -i -e 's/device 0/device 3/' "$rc"
  echo "enable device 3"
else
  sed -i -e 's/device 3/device 0/' "$rc"
  echo "enable device 0"
fi
# EOF
