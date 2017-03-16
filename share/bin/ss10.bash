#!/bin/bash
set -eu

delay="10"
word=""
limit="100"
option="-a"

# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
show connection to between 100 count

  ss10.bash [flag] [arg]
    --help	show help then exit
    --delay	delay second	(default $delay)
    --word	grep word	(default "$word")
    --limit	limit count	(default $limit)
    --option	to ss flags	(default "$option")

END
}
while [ -n "${1:-}" ]; do
  case "$1" in
    "-h"|"--help")helpmsg; exit 0;;
    "-d"|"--delay")shift; delay="$1";;
    "-w"|"--word")shift; word="$1";;
    "-l"|"--limit")shift; limit="$1";;
    "-o"|"--option")shift; option="$1";;
    "") ;;
  esac
  shift
done
unset -f helpmsg

if [ -z "$word" ];then
  for x in `seq "$limit"`; do
    ss ${option}
    echo "$x"
    which "fortune" &> /dev/null && fortune -a
    sleep "$delay"
  done
else
  for x in `seq "$limit"`; do
    ss ${option} | grep "$word" || echo "not found $word"
    echo "count $x"
    which "fortune" &> /dev/null && fortune -a
    sleep "$delay"
  done
fi
# EOF
