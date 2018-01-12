#!/bin/sh
set -eu

path="next.txt"

# help
helpmsg() {
  cat >&1 <<END
  append.sh
END
}

main() {
  if grep -w "${1}" "${path}"; then
    echo "duplicated: ${1}"
    exit 2
  fi

  echo "${1}" >> "${path}"
  echo "appended: ${1}"
  echo "cat:"
  cat "${path}"
}

while [ -n "${1:-}" ]; do
  case "$1" in
   help|-help|--help|-h) helpmsg; exit 0;;
   *) main "${1}"; exit 0;;
  esac
  shift
done
unset -f helpmsg
# EOF
