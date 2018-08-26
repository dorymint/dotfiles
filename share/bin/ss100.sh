#!/bin/sh
set -eu
for x in {1..100}; do
	ss -atn
	echo -e "$x\n"
	sleep 1
done
