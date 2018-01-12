#!/bin/bash

set -eu

# make or cmake
use="make"
#use="cmake"
repo="https://github.com/neovim/neovim"
srcroot="$HOME/github.com/neovim/neovim"
installdir="$HOME/opt/neovim"

# confirm $1=msg return bool
confirm() {
  local key=""
  local counter=0
  while [ $counter -lt 3 ]; do
    counter=`expr $counter + 1`
    echo -n "$1 [yes:no]?>"
    read -t 60 key || return 1
    case "$key" in
      no|n) return 1;;
      yes|y) return 0;;
    esac
  done
  return 1
}

if [ ! -d "$srcroot" ]; then
  git clone "$repo" "$srcroot"
fi

cd "$srcroot"
git checkout master

confirm "update src?"
git pull

echo "use=$use"
confirm "build?"
case "$use" in
  make)
    test -d "build" && rm -r "build/"
    make clean
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$installdir" CMAKE_BUILD_TYPE="RelWithDebInfo"
    make install
  exit 0;;

  cmake)
    if [ ! -d "$srcroot/.deps" ]; then
      mkdir ".deps"
    fi
    cd ".deps"
    cmake "../third-party"
    make
    cd ..

    if [ ! -d "$srcroot/build" ]; then
      mkdir "build"
    else
      rm -r "build/*"
    fi
    cd "build"
    cmake -DCMAKE_INSTALL_PREFIX="$installdir" ..
    make
    make install
  exit 0;;
esac

# EOF
