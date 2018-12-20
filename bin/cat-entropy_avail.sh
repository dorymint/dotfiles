#!/bin/sh
set -eu
[ $# -eq 0 ] || exit 1
command cat /proc/sys/kernel/random/entropy_avail
