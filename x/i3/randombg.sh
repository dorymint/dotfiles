#!/bin/sh

set -eu

current_bg_number=$(awk '/feh --bg-max/ { print $3 }' "${HOME}"/.fehbg |
  sed "s/^'\(.*\)'$/\1/" |
  awk -F / '{ print $NF }')
walldir="${HOME}"/Pictures/links
next_bg=""
with_bg_number="no"

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
  with-number, -with-number, --with-number
    Output current background image number
  show, -show
    Show current background image number

Examples:
  randombg.sh
    Display random background images
  randombg.sh next
    Display next background images
  randombg.sh previous
    Display previous background images
END
}

function main {
  if [ -f "${next_bg}" ]; then
    feh --bg-max -- "${next_bg}"
    [ "${with_bg_number}" = "yes" ] && echo ${current_bg_number}
    exit 0
  else
    errmsg "Invalid file path: ${next_bg}"
    exit 1
  fi
}

if [ -d "${walldir}" ]; then
  while true; do
    case ${1:-} in
      ""|random|-random)
        [ -z "${next_bg}" ] && next_bg="${walldir}"/"$(ls "${walldir}" | shuf -n 1)"
        main
        ;;
      next|-next)
        next_bg="${walldir}"/$(expr ${current_bg_number} + 1)
        ;;
      previous|-previous)
        next_bg="${walldir}"/$(expr ${current_bg_number} - 1)
        ;;
      with-number|-with-number|--with-number)
        with_bg_number="yes"
        ;;
      show|-show)
        echo "${current_bg_number}"
        exit 0
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
    shift
  done
else
  errmsg "Can not found ${walldir}"
  exit 1
fi
