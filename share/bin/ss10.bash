#!/bin/bash
set -eu
word=${1-:}
if [ -z "$word" ];then
  for x in `seq 100`; do ss -a && echo "$x" && sleep 10; done
else
  for x in `seq 100`; do
    ss -a | grep "$word"
    echo "$x"
    sleep 10
  done
fi
# EOF
