#!/bin/sh

set -eu

url_grml="https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc"
url_grml_local="https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc"
update=false

# parse arguments
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

# cd to parent
sd="$(dirname "$(readlink -e "$0")")"
cd "$sd"

# wget
command -v wget >/dev/null
if [ ! -d ./new ]; then
  echo "not found \"./new/\"" >&2
  exit 2
fi
wget -O ./new/zshrc.grml -- "$url_grml"
wget -O ./new/zshrc.grml.local -- "$url_grml_local"

# diff
diff="command diff -u --color=always"
echo "diff zshrc.grml <ENTER>"
read -r && $diff ./zshrc.grml ./new/zshrc.grml | less -R
echo "diff zshrc.grml.local <ENTER>"
read -r && $diff ./zshrc.grml.local ./new/zshrc.grml.local | less -R

# update
[ "$update" = "true" ] && cp -i ./new/zshrc.grml ./new/zshrc.grml.local ./

echo "... finished"
