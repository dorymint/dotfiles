#!/bin/sh
set -eu
[ -x "$(command which getter)" ]
[ -x "$(command which feh)" ]
feh --scale-down "$(getter)"
# EOF
