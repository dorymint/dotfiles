#!/bin/sh
set -eu

user="$(git config --global user.name)"

utilsmd="$HOME"/github.com/"$user"/hello-world/md/utils.md
# TODO: reconsider, bit confused utilsmd utilspath
# for reset utilsmd, see --local
utilspath="$HOME"/dotfiles/etc/grep-utils.path
context="-A 5"
color="--color=auto"
option="$context -n $color -i -e"
word=""

# confirm $1=msg return bool
confirm() {
  local key=""
  local counter=0
  while [ $counter -lt 3 ]; do
    counter=`expr $counter + 1`
    echo -n "$1 [yes:no]?>"
    read -t 60 key || return 1
    case "$key" in
      no|n) return 1;;
      yes|y) return 0;;
    esac
  done
  return 1
}
# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  grep-utils.sh [flags] ["grep word"]

  -h --help	show help then exit
  -f --file	path to target file (default $utilsmd)
  -l --local	use seved target file path (default $utilspath)
  -e --edit	edit target file, (default editor is vim)
  -c --commit	git add && commit for $utilsmd
  -p --push-master	git push origin master
  -w --word	specify search word
  -d --diff	show diff $utilsmd
  -B [N]	before context
  -A [N]	after context
  -C [N]	context
  --color	always use color
  --dir	show target files directory
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
    -h|--help)helpmsg; exit 0;;
    -f|--file)shift; utilsmd="$1";;
    -l|--local)utilsmd="$(cat "$utilspath")";;
    -e|--edit)vim "$utilsmd"; exit 0;;
    -c|--commit)
      cd "$(dirname "$utilsmd")"
      git add "$utilsmd"
      git commit -m "up $(basename "$utilsmd")" -- "$utilsmd"
      exit 0;;
    -p|--push-master)
      cd "$(dirname "$utilsmd")"
      git status
      git diff origin master
      confirm "run [git push origin master]"
      git push origin master
     exit 0 ;;
    -w|--word)shift; word="$1";;
    -d|--diff)
      cd "$(dirname "$utilsmd")"
      git diff "$(basename "$utilsmd")"
      exit 0;;
    -A)shift;context="-A $1";;
    -B)shift;context="-B $1";;
    -C)shift;context="-C $1";;
    --color) color="--color=always";;
    # TODO: reconsider --dir
    --dir)echo "$(dirname "$utilsmd")"; exit 0;;
    *)if [ -n "$word" ]; then
        echo "invalid argument: $*"
        exit 1
      fi
      word="$1";;
  esac
  shift
done
unset -f helpmsg
# update option
option="$context -n $color -i -e"

if [ ! -r "$utilsmd" ] || [ ! -f "$utilsmd" ]; then
  echo "invalid filepath: $utilsmd"
  exit 1
fi
grep $option "$word" "$utilsmd"
# EOF
