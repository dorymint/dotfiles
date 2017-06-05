#!/bin/bash
set -eu
bare=""
# help
function helpmsg () {
  cat >&1 <<END
  ln-bare.bash for git bare repository, make symbolic link

  ln-bare.bash /path/to/repo.git
    make symbolic link /path/to/repo >> /path/to/repo.git
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   help|--help|-h) helpmsg; exit 0;;
   *)bare="$(readlink -f "$1")";;
  esac
  shift
done
unset -f helpmsg
if [ ! -d "$bare" ]; then
  echo "not directory: $bare"
  exit 1
fi
if [[ "$bare" != *.git ]]; then
  echo "not *.git: $bare"
  exit 1
fi
ln -s "$bare" "$(echo "$bare" | sed -e 's/\.git$//')"
# EOF
