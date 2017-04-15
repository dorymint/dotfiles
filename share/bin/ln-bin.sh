#!/bin/sh
set -eu

cd $(dirname "$0")
result=""
dst="$HOME"/bin
unset x
for x in *; do
  [ ! -x "$x" ] && continue

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
