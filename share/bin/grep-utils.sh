#!/bin/sh
set -eu
utilsmd="$HOME"/github.com/"$USER"/hello-world/md/utils.md
option="-A 3 -n --color=auto -e"
[ -r "$utilsmd" ]
grep $option "${1}" "$utilsmd"
# EOF
