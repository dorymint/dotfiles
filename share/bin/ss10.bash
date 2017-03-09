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

word=${1:-}
if [ -z "$word" ];then
  for x in `seq 100`; do ss -a && echo "$x" && sleep 10; done
else
  for x in `seq 100`; do
    ss -a | grep "$word"
    echo "count $x"
    sleep 10
  done
fi
# EOF
