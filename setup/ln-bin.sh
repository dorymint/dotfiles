#!/bin/sh
set -eu

result=""
option="-s "
dst="$HOME"/bin

# help
function helpmsg () {
  cat >&1 <<END
  -f	accept override exists files
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   help|--help|-h) helpmsg; exit 0;;
   -f) option="$option"" -f "
  esac
  shift
done
unset -f helpmsg

function links() {
  [ -d "$1" ]
  cd "$1" 1> /dev/null
  local result=""
  local x
  for x in *; do
    if [ -d "$x" ]; then
      result="$result""$(links "$x")"
    fi
    if [ ! -x "$x" ] || [ ! -f "$x" ]; then
      continue
    fi

    # make link fallthrough
    ln $option "$(pwd)/$x" "$dst" &&
      result="$result""$x " ||
      true
  done
  return $result
}

# cds(change to script directory)
cd "$(dirname "$(readlink -f "$0")")"
# make links
result="$(links ../share/bin)"

echo "--- result ---"
unset x
for x in $result; do
  echo "$x"
done
echo "--- created symlink to $dst ---"
# EOF
