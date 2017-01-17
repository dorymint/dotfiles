#!/bin/bash

set -eu

protocol="https:"
gofrom="//github.com/golang/go"
goroot="$HOME/github.com/golang/go"
bootstrap="$HOME/go1.4"
strapver="go1.4.3"
gover="go1.7.4"
buildlog="$( cd $(dirname "$0") ; pwd -P )/go_build.log"

# check git
echo 'require "git"'
git version

# check goroot
if [[ ! -d "$goroot" ]]; then
  echo -e "from\n  $protocol$gofrom\nto\n  $goroot"
  git clone "$protocol$gofrom" "$goroot"
fi

# for bootstrap
if [[ ! -d "$bootstrap" ]]; then
  echo "clone bootstrap from $goroot"
  git clone --no-hardlinks "$goroot" "$bootstrap"
fi

cd "$bootstrap"
git fetch
git checkout "$strapver"
# remind go1.4

if [[ "$(git describe --tags)" != "$strapver" ]]; then
  echo "tag $strapver don't found"
  exit 1
fi

# build bootstrap
if [[ ! -x "$bootstrap/bin/go" ]]; then
  pushd ./src
  ./all.bash
  popd
fi

# build
cd "$goroot/src" &&
  git fetch &&
  git checkout "$gover" &&
  ./all.bash 2>&1 | tee "$buildlog" || exit 1

# EOF
