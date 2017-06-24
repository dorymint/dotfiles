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
  command pushd "$1" 1> /dev/null
  echo "link directory: $(pwd)"
  unset x
  for x in *; do
    if [ ! -x "$x" ] || [ ! -f "$x" ]; then
      continue
    fi
    # make link fallthrough
    if ln $option "$(pwd)/$x" "$dst"; then
      result="$result""$x "
    fi
  done
  unset x
  for x in *; do
    if [ -d "$x" ]; then
      links "$x"
    fi
  done
  command popd 1> /dev/null
}

# cds(change to script directory)
cd "$(dirname "$(readlink -f "$0")")"
# make links
links ../share/bin

echo "--- result ---"
unset x
for x in $result; do
  echo "$x"
done
echo "--- created symlink to $dst ---"
# EOF
