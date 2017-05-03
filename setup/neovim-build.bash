#!/bin/bash

set -eu

# make or cmake
use="make"
#use="cmake"
repo="https://github.com/neovim/neovim"
srcroot="$HOME/github.com/neovim/neovim"
installdir="$HOME/opt/neovim"

if [ ! -d "$srcroot" ]; then
  git clone "$repo" "$srcroot"
fi

cd "$srcroot"
git checkout master
git pull

case "$use" in
  "make")
    test -d "build" && rm -r "build/"
    make clean
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$installdir" CMAKE_BUILD_TYPE="RelWithDebInfo"
    make install
  exit 0;;

  "cmake")
    if [ ! -d "$srcroot/.deps" ]; then
      mkdir ".deps"
    fi
    pushd ".deps"
    cmake "../third-party"
    make
    popd

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
