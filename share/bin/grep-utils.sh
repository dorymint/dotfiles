#!/bin/sh
set -eu
# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  grep utils.md

  -h --help	show help then exit
  -B [N]	before context
  -A [N]	after context
  -C [N]	context
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
    "-h"|"--help")helpmsg; exit 0;;
    "-A")shift;context="-A $1";;
    "-B")shift;context="-B $1";;
    "-C")shift;context="-C $1";;
    *)word="$1";;
  esac
  shift
done
unset -f helpmsg

utilsmd="${utilsmd:-"$HOME"/github.com/"$USER"/hello-world/md/utils.md}"
context="${context:--A 5}"
option="${option:-${context:-} -n --color=auto -e}"
word="${word:-}"
[ -r "$utilsmd" ]
grep $option "$word" "$utilsmd"
# EOF
