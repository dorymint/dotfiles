#!/bin/sh
set -eu
utilsmd="$HOME"/github.com/"$USER"/hello-world/md/utils.md
option="-A 2 -n -e"
[ -r "$utilsmd" ]
grep $option "${1}" "$utilsmd"
# EOF
