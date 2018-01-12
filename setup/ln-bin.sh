#!/bin/sh
set -eu

# TODO: consider to remove

result=""
option="-s "
dst="$HOME"/bin
withoutx="yes"

# help
helpmsg() {
  cat >&1 <<END
  -f	accept override exists files
  --with-x
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   help|-help|--help|-h) helpmsg; exit 0;;
   -f) option="-sf ";;
   --with-x) withoutx="";;
   *) echo "invalid argument $*"; exit 1;;
  esac
  shift
done
unset -f helpmsg

links() {
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
      if [ "$x" = "x" ] && [ "$withoutx" = "yes" ];then
         continue
      fi
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
