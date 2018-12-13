#!/bin/bash
set -eu

# depends bash for "read -n 1"

#name="$(basename "$0")"
name="chfont-urxvt.bash"

# TODO: consider
font="xft:Inconsolata"
tcode="\e]710;%s\007"
defsize=11
maxsize=40
minsize=8
size=$defsize

helpmsg() {
  cat >&1 <<END
Description:
  change font for rxvt-unicode

Usage:
  $name [Options]

Options:
  -h, --help                 Display this message
  -s, --size SIZE|[Keywords] Change font size (SIZE=number)

Keywords:
  max            Size to max
  min            Size to min
  i, interactive Size change on interactive

Examples:
  $name --help # Display help message
  $name -s 14  # Change font size to 14
  $name -s i   # Start interactive size change
END
}

errmsg() {
  echo "$name: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

chsize_inter() {
  (
  echo "change size on interactive"
  echo "press \"n\" to size up "
  echo "press \"p\" to size down"
  echo "press \"d\" to size default"
  echo "press \"Enter\" to exit"
  while read -r -n 1 x; do
    printf "\r"
    [ "$x" = "n" ] && size=$(( $size + 1 ))
    [ "$x" = "p" ] && size=$(( $size - 1 ))
    [ "$x" = "d" ] && size=$defsize
    [ "$x" = "" ] && break
    chsize "$size"
    printf "Current Size $size > "
  done
  )
}

chsize() {
  case "$1" in
    def|default)
      size=$defsize
      ;;
    min)
      size=$minsize
      ;;
    max)
      size=$maxsize
      ;;
    # too lazy
    i|interactive)
      chsize_inter
      return
      ;;
    ''|*[!0-9]*)
      abort "invalid size parameter \"$1\""
      ;;
    *)
      size=$1
      ;;
  esac
  [ $size -lt $minsize ] && abort "invalid size parameter \"$*\" minsize=$minsize"
  [ $size -gt $maxsize ] && abort "invalid size parameter \"$*\" maxsize=$maxsize"
  printf "$tcode" "$font:size=$size"
}

main() {
  echo "not implemented \"$*\""
}

case "$TERM" in
  rxvt-unicode-256color);;
  *) abort "not implemented for $TERM";;
esac

while true; do
  case "${1:-}" in
    --)
      shift
      break
      ;;
    -h|--help|h|help|-help)
      helpmsg
      shift
      [ $# -eq 0 ] || abort "invalid arguments: $*"
      exit 0
      ;;
    -s|--size)
      shift
      [ $# -eq 1 ] || abort "invalid arguments $*"
      chsize "$1"
      exit 0
      ;;
    *)
      break
      ;;
  esac
  shift
done

main "$@"

