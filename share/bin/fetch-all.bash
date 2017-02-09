#!/bin/bash

# fetch reps scripts
# $1 = <path/to/reps.list>

set -e

[ -z $1 ] && exit 1

echo "fetch reps"

for x in `cat $1`; do
  [ -z "$x" ] && continue
  echo "fetch ...$x"
  cd "$(eval echo "$x")" && git fetch || continue
  echo -e "done\n"
done

echo "all fetch done"
# EOF
