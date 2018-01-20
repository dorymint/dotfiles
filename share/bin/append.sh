#!/bin/sh
set -eu

list="next.list"

# help
helpmsg() {
  cat >&1 <<END
append.sh

options:
  -help
  -exec
END
}

append() {
  if grep -w "${1}" -- "${list}" &> /dev/null; then
    echo "duplicated: ${1}"
    exit 2
  fi

  echo "${1}" >> "${list}"
  echo "appended: ${1}"
  echo "cat:"
  cat "${list}"
}

cmd() {
  for x in "$(cat "${list}")"; do
    ${*} -- ${x}
    sleep $(shuf -i 20-180 -n 1)
  done
  # trunc
  : > "${list}"
}

while [ -n "${1:-}" ]; do
  case "${1}" in
   help|-help|--help|-h) helpmsg; exit 0;;
   # TODO: fix cmd
   exec|-exec) cmd "echo" "-n"; exit 0;;
   *) append "${1}"; exit 0;;
  esac
  shift
done
unset -f helpmsg
# EOF
