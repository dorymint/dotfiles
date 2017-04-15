#!/bin/sh
set -eu

# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<'END'
watch for git repositores

  reps.bash [command] [/path/to/reps.list]

    [commnad]
      f -f fetch	git fetch
      s -s status	git status
      l -l list	show watch list
      h -h help	show this help

    [/path/to/reps.list]
      $HOME/dotfiels/etc/reps.list (default)
END
}
case "${1:-}" in
  "h"|"-h"|"help"|"") helpmsg; exit 0;;
esac
unset -f helpmsg

replist="${2:-$HOME/dotfiles/etc/reps.list}"
[ -f "$replist" ] || exit 1

if [ ! -r "$1" ] && [ ! -r "$replist" ]; then
  echo "require: reps.bash [sf] <path/to/reps.list>"
  exit 1
fi

sub=""
case "$1" in
  "status"|"-s"|"s") sub="status";;
  "fetch"|"-f"|"f") sub="fetch";;
  "list"|"-l"|"l") cat "$replist"; exit 0;;
  *) exit 1;;
esac

echo "replist=$replist"
# NOTE: 79
echo -e "-------------------------------------------------------------------------------\n"
for x in `cat "$replist"`; do
  [ -z "$x" ] && continue
  echo "$x"
  cd "$x" && git $sub || continue
  echo -e "-------------------------------------------------------------------------------\n"
done
# EOF
