#!/bin/bash
set -eu

helpmsg() {
  cat >&1 <<END
  for golang
    go test current directory
    test && race && cover && to browser

    create or override
      ./cover.prof
END
}

case "${1:-}" in
  -h|-help|--help) helpmsg; exit 0;;
esac

prof="$(pwd)"/cover.prof
if [ -f "${prof}" ]; then
  echo -e -n "${prof}\noverride [yes:no]?>"
  read -t 60 key
  [ "${key}" = "yes" ] || exit 1
fi

go test -race -cover -coverprofile "${prof}"
go tool cover -html "${prof}"
# EOF
