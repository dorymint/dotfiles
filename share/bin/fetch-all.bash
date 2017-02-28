#!/bin/bash

# fetch reps scripts
# $1 = <path/to/reps.list>

set -e

replist="${1:-$HOME/local/reps.list}"
[ -f "$replist" ] || exit 2

if [ ! -r $1 ] && [ ! -r "$replist" ]; then
  echo "require: fetch-all.bash <path/to/reps.list>"
  exit 1
fi

echo "replist=$replist"
echo -e "fetch reps\n"
for x in `cat "$replist"`; do
  [ -z "$x" ] && continue
  echo "fetch ...$x"
  cd "$(eval echo "$x")" && git fetch || continue
  echo -e "done\n"
done
echo "fetch-all done"
# EOF
