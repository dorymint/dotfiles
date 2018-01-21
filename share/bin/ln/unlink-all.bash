#!/bin/bash
set -eu
cd "$1"
echo -n "remove all symboliclinks in $(pwd) [yes:no]?>"
read -t 60 key
[ "$key" == yes ]
for x in *; do
	if [ ! -L "$x" ]; then
		continue
	fi
	rm "$x"
done
