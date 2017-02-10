#!/bin/bash

# fetch reps scripts
# $1 = <path/to/reps.list>

set -e

if [ -z $1 ]; then
  echo "require: fetch-all.bash <path/to/reps.list>"
  exit 1
fi

echo "fetch reps"

for x in `cat $1`; do
  [ -z "$x" ] && continue
  echo "fetch ...$x"
  cd "$(eval echo "$x")" && git fetch || continue
  echo -e "done\n"
done

echo "all fetch done"
# EOF
