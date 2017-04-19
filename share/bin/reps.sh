#!/bin/sh
set -eu

replist="$HOME/dotfiles/etc/reps.list"
sub="status"

# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
watch for git repositores

  reps.bash [command]

    [commnad]
      f -f fetch	git fetch
      s -s status	git status
      l -l list	show watch list
      h -h help	show this help

      --file	specify path/to/reps.list

    [/path/to/reps.list]
      $replist (default)
END
}
while [ -n "${1:-}" ]; do
  case "${1}" in
    "help"|"-h"|"h") helpmsg; exit 0;;
    "status"|"-s"|"s") sub="status";;
    "fetch"|"-f"|"f") sub="fetch";;
    "list"|"-l"|"l") cat "$replist"; exit 0;;
    "--file") shift; replist="$1";;
    "");;
    *)echo "invalid: $*"; helpmsg; exit 1;;
  esac
  shift
done
unset -f helpmsg

if [ ! -f "$replist" ] || [ ! -r "$replist" ]; then
  echo "can not read $replist"
  exit 1
fi

echo "replist=$replist"
# NOTE: 79
echo -e "-------------------------------------------------------------------------------\n"
for x in `cat "$replist"`; do
  [ -z "$x" ] && continue
  echo "$x"
  cd "$x" && git "$sub" || continue
  echo -e "-------------------------------------------------------------------------------\n"
done
# EOF
