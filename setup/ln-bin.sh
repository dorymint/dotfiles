#!/bin/sh
set -eu

# cds(change to script directory)
cd "$(dirname "$(readlink -f "$0")")"
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
  pushd "$1" 1> /dev/null
  unset x
  for x in *; do
    if [ -d "$x" ]; then
      links "$x"
    fi
    if [ ! -x "$x" ] || [ ! -f "$x" ]; then
      continue
    fi

    # make link fallthrough
    ln $option "$(pwd)/$x" "$dst" &&
      result="$result""$x " ||
      true
  done
  popd 1> /dev/null
}

# path to utils
links ../share/bin

echo "--- result ---"
unset x
for x in $result; do
  echo "$x"
done
echo "--- created symlink to $dst ---"
# EOF
