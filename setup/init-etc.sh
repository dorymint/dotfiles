#!/bin/sh
set -eu

# help
function helpmsg () {
  cat >&1 <<END
  make bind files to dotfiles etc
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
    help|--help|-h) helpmsg; exit 0;;
    *)echo "unknown option: $*"; exit 1;;
    "");;
  esac
  shift
done
unset -f helpmsg

# cds(change to script directory)
cd "$(dirname "$(readlink -f "$0")")"
cd ../etc

touch alias
touch grep-utils.path
touch reps.list

mkdir systemd
touch wallenv
touch currentvm

mkdir getter
touch getter/conf.json
touch getter/systemd-service-env

mkdir -p gomem/todo

mkdir zsh
touch zsh/localrc.zsh
# EOF
