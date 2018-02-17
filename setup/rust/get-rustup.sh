#!/bin/sh

set -eu

# cds(change to script directory)
cd "$(dirname "$(readlink -f "${0}")")"

curl -f https://sh.rustup.rs > rust.sh

p=$(pwd)/rust.sh
cat <<END
	output: ${p}
	check: vim ${p}
END
