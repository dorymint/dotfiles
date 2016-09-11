#!/bin/bash
# scriptencoding utr-8

echo "require"
echo "--gawk-- --go--"
echo "--git-- or any version cotrol systems"
echo ""

# env check
if [[ -z $DOTFILES_ROOT ]]; then
  echo "do not find dotfiles directory"
  echo "please set environment"
  exit 1
fi
cd "$DOTFILES_ROOT"

# set env goroot
goroot=$(go env GOROOT)
echo "goroot is $goroot"

# go command
goget="$goroot/bin/go get"
options="-u -v"

# package set
pkglist="$DOTFILES_ROOT/go_pkglist.txt"
awkout=$(gawk '/^[^#].*/ { print $0 }' "$pkglist")

# package show
echo "--- install list ---"
for x in $awkout; do
  echo "$x"
done
echo ""

# confirm
key=""
count=0
while [[ "$key" != "yes" ]]; do
  if [[ "$key" = "no" ]] || [[ "$key" = "n" ]] || [[ $count -gt 2 ]]; then
    echo "ok... stop install process"
    exit 1
  fi
  count=$(expr $count + 1)

  echo "install and update packages[yes:no]?"
  read key
done

# install packages
echo "ok...start install"
for x in $awkout; do
  $goget $options $x
done

echo "...process exit"
# EOF
