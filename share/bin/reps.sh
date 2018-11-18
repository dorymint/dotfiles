#!/bin/sh
set -eu

replist="$HOME"/dotfiles/etc/reps.list
sub="status"

# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
reps.sh
  watch for git repositores
  reps.bash [command]

options:
  f -f fetch
    git fetch
  s -s status
    git status
  l -l list
    show watch list
  h -h help
    show this help
  e -e edit
    edit reps.list
  --file
    specify path/to/reps.list

defaults:
  reps.list
    $replist
END
}
while [ -n "${1:-}" ]; do
  case "${1}" in
    help|-h|h) helpmsg; exit 0;;
    status|-s|s) sub="status";;
    fetch|-f|f) sub="fetch";;
    list|-l|l) cat "$replist"; exit 0;;
    edit|-e|e) ${EDITOR:-vim} "$replist"; exit 0;;
    --file) shift; replist="$1";;
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
