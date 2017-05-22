#!/bin/sh
set -eu

[ -x "$(which todogotcha)" ]
[ -x "$(which peco)" ]

word="TODO: "
types=".go .txt"
file=""
root="./"

# help
function helpmsg () {
  cat >&1 <<'END'
  todovim.sh
    vim "$(todogotcha | peco)"
    root --root -r
    word --wrod -w
    types --types -t

    $1 is same -root
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   help|--help|-h)helpmsg; exit 0;;
   word|--word|-w)shift; word="$1";;
   types|--types|-t)shift; types="$1";;
   root|-root|-r)shift; root="$1";;
   *)root="$1";;
  esac
  shift
done
unset -f helpmsg

file="$(todogotcha -root="$root" -word="$word" -type="$types" -result=true | peco)"
[ -z "$file" ] && exit 1
vim "$file"
# EOF
