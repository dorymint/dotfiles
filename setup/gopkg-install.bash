#!/bin/bash
# scriptencoding utr-8
set -eu

function split () {
  echo "------- $1 -------"
}

# help
function helpmsg () {
  cat >&1 <<END
  go pkg install scripts

  help --help -h
    show help message
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   help|--help|-h) helpmsg; exit 0;;
   # TODO: make flags for exchange variable
  esac
  shift
done
unset -f helpmsg

# confirm $1=msg return bool
function confirm () {
  local key=""
  local counter=0
  while [ $counter -lt 3 ]; do
    counter=`expr $counter + 1`
    echo -n "$1 [yes:no]?>"
    read -t 60 key || return 1
    case "$key" in
      "no"|"n") return 1;;
      "yes"|"y") return 0;;
    esac
  done
  return 1
}

# check
split "require"
type go
type gawk

# variable
goget="go get"
options="-u -v"
cd "$(dirname "$(readlink -f "$0")")"
pkglist="./gopkg.list"
if  [ ! -r "$pkglist" ]; then
  echo "can't read $pkglist"
  exit 1
fi
awkout=$(gawk '/^[^#].*/ { print $0 }' "$pkglist")

# info && confirm
split "go env"
go version
go env
sleep 1
split "install list"
for x in $awkout; do
  echo "$x"
done
split "confirm"
confirm "install and update packages?"

# install && update
echo "START install && update"
for x in $awkout; do
  $goget $options $x
done
echo "...DONE"

# EOF
