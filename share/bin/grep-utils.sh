#!/bin/sh
set -eu
utilsmd="$HOME"/github.com/"$USER"/hello-world/md/utils.md
[ -r "$utilsmd" ]
grep -e "${1}" "$utilsmd"
# EOF
