#!/bin/sh
set -eu

[ -x "$(which todogotcha)" ]
[ -x "$(which peco)" ]

word="TODO: "
types="${2:-".go .txt"}"
file=""

# help
function helpmsg () {
  cat >&1 <<'END'
  todovim.sh
    vim "$(todogotcha | peco)"
    $1=-root $2=-type
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   help|--help|-h) helpmsg; exit 0;;
   word|--word|-w)shift; word="$1";;
   *)break;;
  esac
  shift
done
unset -f helpmsg

file="$(todogotcha -root="$1" -word="$word" -type="$types" -result=true | peco)"
[ -z "$file" ] && exit 1
vim "$file"
# EOF
