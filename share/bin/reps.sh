#!/bin/sh

# TODO: consider to remove

set -eu

path_list="$HOME"/dotfiles/etc/reps.list
subcmd="status"

helpmsg() {
  cat >&1 <<END
Description:
  Repositories tracker

Usage:
  reps.sh [Options]

Options:
  -h, -help, help Display this message
  -file           Specify path to repository lists (default: $path_list)
  show            Show tracked repositories
  e, -e, -edit    Edit reps.list
  f, fetch        Running of git fetch
  s, status       Running of git status

END
}

errmsg() {
  echo "$@" 1>&2
}

main() {
  if [ ! -f "$path_list" ] || [ ! -r "$path_list" ]; then
    errmsg "can not read $path_list"
    exit 1
  fi

  echo "path_list=$path_list"

  # NOTE: ('-' * 79)
  echo -e "-------------------------------------------------------------------------------\n"
  for x in $(cat "$path_list"); do
    [ -z "$x" ] && continue
    echo "$x"
    cd "$x"
    git "$subcmd"
    echo -e "-------------------------------------------------------------------------------\n"
  done
}

while true; do
  case "${1:-}" in
    -h|-help|help)
      helpmsg
      exit 0
      ;;
    -file)
      shift
      path_list="$1"
      ;;
    show)
      cat "$path_list"
      exit 0
      ;;
    e|-e|-edit)
      ${EDITOR:-vim} "$path_list"
      exit 0
      ;;
    f|fetch)
      subcmd="fetch"
      ;;
    s|status)
      subcmd="status"
      ;;
    "")
      main
      exit 0
      ;;
    *)
      helpmsg
      errmsg "Unknown option: $*"
      exit 1
      ;;
  esac
  shift
done
