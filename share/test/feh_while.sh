#!/bin/bash
# feh test script
key=""
while [ "$key" != "stop" ]
do
  feh --randomize --recursive --bg-scale /usr/share/backgrounds/*/*.jpg || exit 1
  read -t 10 -p "change background image. stop it? [<stop> or <C-c>]" key
  echo -e -n "\r"
done
# EOF
