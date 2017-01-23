#!/bin/bash
# feh test script
key=""
while [ "$key" != "stop" ]
do
  feh --randomize --recursive --bg-scale /usr/share/backgrounds/*/*.jpg || exit 1
  echo -e -n "\r"
  echo -e -n "change background image. stop it? [<stop> or <C-c>]:"
  read -t 10 key
done
# EOF
