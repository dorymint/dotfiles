#!/bin/bash

set -e

protocol="https:"
gofrom="//go.googlesource.com/go"
#gofrom="//github.com/golang/go"
goroot="$HOME/github.com/golang/go"

goversion="go1.8"
buildlog="$( cd $(dirname "$0") ; pwd -P )/go-build.log"

#bootstrap="gcc-go"
#bootstrap="go1.4.3"
bootstrap="release-branch.go1.4"
bootup="yes"


# check git
echo 'require "git"'
git version

# check goroot
if [[ ! -d "$goroot" ]]; then
  echo -e "from\n  $protocol$gofrom\nto\n  $goroot"
  git clone "$protocol$gofrom" "$goroot"
elif [[ "$1" != "noup" ]]; then
  # update src
  cd "$goroot/src"
  git checkout master
  git pull
fi

# bootstrap
if [[ "$bootstrap" == "go1.4.3" ]] || [[ "$bootstrap" == "release-branch.go1.4" ]]; then
  [[ ! -d "$HOME/$bootstrap" ]] && git clone --no-local $goroot $HOME/$bootstrap
  if [[ ! -f "$HOME/$bootstrap/bin/go" ]] || [[ "$bootup" == "yes" ]]; then
    cd $HOME/$bootstrap/src
    git checkout master
    git pull
    git checkout $bootstrap
    #./make.bash
    CC=clang CXX=clang++ ./make.bash
  fi
fi


# build
cd "$goroot/src"
git checkout "$goversion"
case "$bootstrap" in
  "gcc-go") GOROOT_BOOTSTRAP="/usr" ./all.bash 2>&1 | tee "$buildlog" || exit 1;;
  "go1.4.3") GOROOT_BOOTSTRAP="$HOME/$bootstrap" ./all.bash 2>&1 | tee "$buildlog" || exit 1;;
  "release-branch.go1.4") GOROOT_BOOTSTRAP="$HOME/$bootstrap" ./all.bash 2>&1 | tee "$buildlog" || exit 1;;
  *) echo "bootstrap = $bootstrap is invalid"; exit 1;;
esac
# EOF
