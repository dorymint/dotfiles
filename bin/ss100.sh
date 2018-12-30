#!/bin/sh
set -eu
for x in $(seq 1 100); do
  ss -atn
  printf "%s\n" "$x"
  sleep 1
done

