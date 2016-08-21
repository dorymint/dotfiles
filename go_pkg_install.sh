#!/bin/bash
# scriptencoding utr-8

echo require
echo --gawk-- --go--

# env check
if [[ -z $DOTFILES_ROOT ]]; then
  echo "do not find dotfiles directory"
  echo "please set environment"
  exit
fi
cd $DOTFILES_ROOT

# set env goroot
goroot=$(go env GOROOT)
echo "$goroot"

# go command
goget="$goroot/bin/go get"
options="-u"

# package set
pkglist="$DOTFILES_ROOT/go_pkglist.txt"
awkout=$(gawk '/^[^#].*/ { print $0 }' "$pkglist")

# package show
echo "--- install list ---"
for x in $awkout
do
  echo "$x"
done

# confirm
key=""
echo "install packages[yes:no]?"
while [[ -z $key ]] || [[ $key != "yes" ]]; do
  read key

  if [[ $key = "no" ]] || [[ $key = "n" ]]; then
    echo "ok... stop install process"
    exit
  fi
done

# install packages
echo "ok...start install"
for x in $awkout
do
  $goget $options $x
done

echo "...process exit"
# EOF
