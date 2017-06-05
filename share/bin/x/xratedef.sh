#!/bin/sh
set -eu
xset q | grep repeat
xset r rate 200 30
echo "---------- after ----------"
xset q | grep repeat
# EOF
