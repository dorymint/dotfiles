#!/bin/bash

set -e

protocol="https:"
gofrom="//go.googlesource.com/go"
#gofrom="//github.com/golang/go"
goroot="$HOME/github.com/golang/go"
gover="go1.7.5"
buildlog="$( cd $(dirname "$0") ; pwd -P )/go-build.log"

# bootstrap
go version


# check git
echo 'require "git"'
git version

# check goroot
if [[ ! -d "$goroot" ]]; then
  echo -e "from\n  $protocol$gofrom\nto\n  $goroot"
  git clone "$protocol$gofrom" "$goroot"
fi

# build
cd "$goroot/src"
[ "$1" = "noup" ] || git fetch
git checkout "$gover"
GOROOT_BOOTSTRAP=/usr ./all.bash 2>&1 | tee "$buildlog" || exit 1
# EOF
