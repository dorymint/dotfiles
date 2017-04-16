#!/bin/sh
set -eu

# TODO: add flag for modify in grep-utils.path

# TODO: reconsider, exchange $USER
utilsmd="$HOME"/github.com/"$USER"/hello-world/md/utils.md
# TODO: reconsider, bit confused, utilsmd utilspath
# for reset utilsmd, see --local
utilspath="$HOME"/dotfiles/etc/grep-utils.path
context="-A 5"
option="$context -n --color=auto -i -e"
word=""

# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  grep utils.md

  -h --help	show help then exit
  -f --file	path to target file (default $utilsmd)
  -l --local	use seved target file path (default $utilspath)
  -e --edit	edit target file, (default editor is vim)
  -u --update	git add && commit for $utilsmd
  -s --show	show path to target file
  -B [N]	before context
  -A [N]	after context
  -C [N]	context
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
    "-h"|"--help")helpmsg; exit 0;;
    "-f"|"--file")shift; utilsmd="$1";;
    "-l"|"--local")utilsmd="$(cat "$utilspath")";;
    "-e"|"--edit")vim "$utilsmd"; exit 0;;
    "-s"|"--show")echo "$utilsmd"; exit 0;;
    "-u"|"--update")
      cd "$(dirname "$utilsmd")"
      git add "$utilsmd"
      git commit -m "up $(basename "$utilsmd")" -- "$utilsmd"
      exit 0;;
    "-A")shift;context="-A $1";;
    "-B")shift;context="-B $1";;
    "-C")shift;context="-C $1";;
    *)word="$1";;
  esac
  shift
done
unset -f helpmsg
# update option for context
option="$context -n --color=auto -i -e"

if [ ! -r "$utilsmd" ] || [ ! -f "$utilsmd" ]; then
  echo "invalid filepath: $utilsmd"
  exit 1
fi
grep $option "$word" "$utilsmd"
# EOF
