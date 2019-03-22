#!/bin/sh

set -eu

url_grml="https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc"
url_grml_local="https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc"
update=false

if [ $# -eq 1 ]; then
  case "$1" in
    -u|--update) update=true ;;
    *)
      echo "unexpected arguments: $*" >&2
      exit 1
      ;;
  esac
elif [ $# -ne 0 ]; then
    echo "unexpected arguments: $*" >&2
    exit 1
fi

sd="$(dirname "$(readlink -e "$0")")"
cd "$sd"

# depend
if ! ( command -v  wget > /dev/null 2>&1 ); then
  echo "require \"wget\"" >&2
  exit 1
fi

if [ ! -d ./new ]; then
  echo "not found taret directory" >&2
  exit 1
fi

wget -O ./new/zshrc.grml -- "$url_grml"
wget -O ./new/zshrc.grml.local -- "$url_grml_local"


if command -v diff > /dev/null 2>&1; then
  diff="command diff -u --color=always"

  echo "diff zshrc.grml <ENTER>"
  read -r && $diff ./zshrc.grml ./new/zshrc.grml | less -R

  echo "diff zshrc.grml.local <ENTER>"
  read -r && $diff ./zshrc.grml.local ./new/zshrc.grml.local | less -R
fi

[ "$update" = "true" ] &&
  cp -i ./new/zshrc.grml ./new/zshrc.grml.local ./

