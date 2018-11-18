#!/bin/sh
set -eu

cmd=""
# help
helpmsg() {
  cat >&1 <<END
with-notify.sh
  run command with notify-send
options:
  -help
END
}
case "$1" in
  help|-help|--help|-h) helpmsg; exit 0;;
  *) cmd=${1}; shift;;
  "") echo "command not specified"; exit 1;;
esac
unset -f helpmsg

if ! command -v notify-send; then
  echo "not found: notify-send"
  exit 1
fi
if ! command -v $cmd; then
  echo "not found: $cmd"
  exit 1
fi

notify-send "command start: $cmd $*"
$cmd $*
notify-send "command finished: $cmd $*"
