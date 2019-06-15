#!/bin/sh
set -eu
echo "---------- before ----------"
xset q | grep repeat
xset r rate 200 30
echo "---------- after -----------"
xset q | grep repeat
