#!/bin/sh

set -eu

current_bg=$(awk '/feh --bg-max/ { print $3 }' "${HOME}"/.fehbg |
  sed "s/^'\(.*\)'$/\1/" |
  awk -F / '{ print $NF }')
walldir="${HOME}"/Pictures/links
next_bg=""

function errmsg {
  echo "$@" 1>&2
}

helpmsg() {
  cat >&1 <<END
Usage: randombg.sh [Options]

Options:
  help, -help
    Show this help
  next, -next
    Display next background images
  previous, -previous
    Display previous backgroud images
  random, -random (Default)
    Display random background images

Examples:
  randombg.sh
    Display random background images
  randombg.sh next
    Display next background images
  randombg.sh previous
    Display previous background images
END
}

if [ -d "${walldir}" ]; then
  case ${1:-} in
    ""|random|-random)
      next_bg="${walldir}"/"$(ls "${walldir}" | shuf -n 1)"
      ;;
    next|-next)
      next_bg="${walldir}"/$(expr ${current_bg} + 1)
      ;;
    previous|-previous)
      next_bg="${walldir}"/$(expr ${current_bg} - 1)
      ;;
    help|-help)
      helpmsg
      exit 0
      ;;
    *)
      errmsg "Unexpected option: $*"
      exit 1
      ;;
  esac
else
  errmsg "Can not found ${walldir}"
  exit 1
fi

if [ -f "${next_bg}" ]; then
  feh --bg-max -- "${next_bg}"
else
  errmsg "Invalid file path: ${next_bg}"
  exit 1
fi
