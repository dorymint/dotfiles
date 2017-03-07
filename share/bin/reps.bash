#!/bin/bash

set -eu

# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<'END'
bind for git

  reps.bash [command] [/path/to/reps.list]

    [commnad]
      f -f fetch
      s -s status
      l -l list
      h -h help

    [/path/to/reps.list]
      $HOME/local/reps.list (default)

END
}
case "${1:-}" in
  "h"|"-h"|"help"|"") helpmsg; exit 0;;
esac
unset -f helpmsg

replist="${2:-$HOME/local/reps.list}"
[ -f "$replist" ] || exit 1

if [ ! -r "$1" ] && [ ! -r "$replist" ]; then
  echo "require: reps.bash [sf] <path/to/reps.list>"
  exit 2
fi

sub=""
case "$1" in
  "status"|"-s"|"s") sub="status";;
  "fetch"|"-f"|"f") sub="fetch";;
  "list"|"-l"|"l") less -N "$replist"; exit 0;;
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
