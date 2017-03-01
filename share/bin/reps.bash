#!/bin/bash

set -e

# bind for git
# fetch
# status
# list
# $1 = command
# $2 = <path/to/reps.list>

replist="${2:-$HOME/local/reps.list}"
[ -f "$replist" ] || exit 1

if [ ! -r "$1" ] && [ ! -r "$replist" ]; then
  echo "require: reps.bash [sf] <path/to/reps.list>"
  exit 2
fi

sub=""
case "$1" in
  "status"|"s") sub="status";;
  "fetch"|"f") sub="fetch";;
  "list"|"l") less -N "$replist"; exit 0;;
  *) exit 3;;
esac

echo "replist=$replist"
echo -e "reps.bash do ...\n\n"
for x in `cat "$replist"`; do
  [ -z "$x" ] && continue
  echo "-----| $x |-----"
  # NOTE: use eval for environment variable
  cd "$(eval echo "$x")" && git $sub || continue
  echo -e "-----| done |-----\n\n"
done
echo "reps.bash done ..."
# EOF
