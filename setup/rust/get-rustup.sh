#!/bin/sh
set -eu

cd "$(dirname "$(readlink -e "$0")")"

url="https://sh.rustup.rs"
curl -f -- "$url" > rust.sh

p="$(readlink -e rust.sh)"
cat <<END
  output: $p
  check: vim $p
END
