#!/bin/bash
set -eu
#cd `dirname $0`

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
  "-h"|"--help") helpmsg; exit 0;;
esac

prof="$(pwd)"/cover.prof
if [ -f "$prof" ]; then
  echo -e "$prof\noverride [yes:no]?>"
  read -t 60 key
  [ "$key" = "yes" ] || exit 1
fi

go="$GOROOT"/bin/go
"$go" test -race -cover -coverprofile "$prof"
"$go" tool cover -html "$prof"
# EOF
