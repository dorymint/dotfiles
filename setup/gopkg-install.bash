#!/bin/bash
# scriptencoding utr-8
# go package install script

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
localgo="$HOME/github.com/golang/go"
if [[ -d "$localgo" ]]; then
  goroot="$localgo"
else
  goroot=$(go env GOROOT)
fi
echo "goroot is $goroot"

# go command
goget="$goroot/bin/go get"
#options="-u -v"
options="-v"

# set packages
pkglist="$DOTFILES_ROOT/setup/gopkg-list.txt"
if [[ -r $pkglist ]]; then
  awkout=$(gawk '/^[^#].*/ { print $0 }' "$pkglist")
else
  echo 'not found gopkg-list.txt'
  exit 1
fi

# show the packages
echo "--- install list ---"
for x in $awkout; do
  echo "$x"
done
echo ""

sleep 1

echo "--- go env ---"
$goroot/bin/go env

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

echo "...done"
# EOF
