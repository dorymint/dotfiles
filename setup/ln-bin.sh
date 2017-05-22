#!/bin/sh
set -eu

# cds(change to script directory)
cd "$(dirname "$(readlink -f "$0")")"
cd ../share/bin

result=""
dst="$HOME"/bin
unset x
for x in *; do
  if [ ! -x "$x" ] || [ ! -f "$x" ]; then
    continue
  fi

  # fallthrough
  ln -s "$(pwd)/$x" "$dst" &&
    result="$result""$x " ||
    true
done

echo "--- result ---"
unset x
for x in $result; do
  echo "$x"
done
echo "--- created symlink to $dst ---"
# EOF
