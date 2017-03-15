#!/bin/bash
set -eu

# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<'END'
show connection to between 100 count

  ss10.bash [word]

    [word] for grep (default "")

END
}
case "${1:-}" in
  "-h"|"--help") helpmsg; exit 0;;
esac
unset -f helpmsg

delay=20
limit=100
word=${1:-}
if [ -z "$word" ];then
  for x in `seq $limit`; do
    ss -a
    echo "$x"
    which "fortune" &> /dev/null && fortune -a
    sleep $delay
  done
else
  for x in `seq $limit`; do
    ss -a | grep "$word" || echo "not found $word"
    echo "count $x"
    which "fortune" &> /dev/null && fortune -a
    sleep $delay
  done
fi
# EOF
