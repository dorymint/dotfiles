#!/bin/bash
# feh test script
for i in `seq 0 100`
do
  feh --randomize --recursive --bg-scale /usr/share/backgrounds/*/*.jpg || echo "failed!!"
  sleep 5
done
# EOF
