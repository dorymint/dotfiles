#!/bin/sh
set -eu

# cds(change to script directory)
cd "$(dirname "$(readlink -f "$0")")"
result=""
dst="$HOME"/bin

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
    ln -s "$(pwd)/$x" "$dst" &&
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
