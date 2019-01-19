#!/bin/bash
set -eu

# links directory
links_dir="$HOME"/Pictures/links
[ -d "$links_dir" ]

# wall images
wallpaper="$HOME"/Pictures/wallpaper
[ -d "$wallpaper" ]
getter="$HOME"/Pictures/getter
[ -d "$getter" ]

helpmsg() {
  cat >&1 <<END
Description:
  update symbolic links for wallpaper

Usage:
  update-wall.bash [Options]

Options:
  -h, --help Display this message
END
}

abort() {
  echo "$*" >&2
  exit 2
}

# confirm $1=msg return bool
confirm() {
  (
  # which one?
  msg="${1:-} [yes:no]?> "
  #msg="${1:-}"
  key=""
  count=1
  while true; do
    [ $count -gt 3 ] && return 1
    count=$(( count + 1 ))
    case "$key" in
      n|no) return 1;;
      y|yes) return 0;;
    esac
    echo -n "$msg"
    read -r key
  done
  echo "unreachable" >&2; exit 99
  )
}

# treat sub directory
mklinks() {
  (
  from_dir="$(readlink -e "$1")"
  [ -d "$from_dir" ] || return

  ln_count=$(find "$links_dir" -type l | wc -l)
  for x in "$from_dir"/*; do
    if [ -f "$x" ]; then
      ln -s "$x" "$links_dir"/"$ln_count"
      ln_count=$(( ln_count + 1 ))
    fi
  done

  # sub directory
  for x in "$from_dir"/*; do
    if [ -d "$x" ]; then
      mklinks "$x"
    fi
  done
  )
}

rmlinks() {
  (
  dir="$(readlink -e "$1")"
  [ -d "$dir" ] || abort "not directory $1"
  for x in "$dir"/*; do
    if [ ! -L "$x" ]; then
      continue
    fi
    rm "$x"
  done
  )
}

main() {
  confirm "remove all symbolic links in $links_dir" || abort "stopped"
  echo "remove links in $links_dir ..."
  rmlinks "$links_dir"

  echo "link $wallpaper to $links_dir"
  mklinks "$wallpaper"
  echo "link $getter to $links_dir"
  mklinks "$getter"
  echo "finished"
}

while [ $# -ne 0 ]; do
  case "$1" in
    -h|--help|-help)
      helpmsg
      exit 0
      ;;
    *)
      abort "invalid arguments $*"
      ;;
  esac
  shift
done

main

