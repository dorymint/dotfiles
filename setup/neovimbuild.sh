#!/bin/bash

echo "nvim: start build process"

set -eu

repo="https://github.com/neovim/neovim"
srcroot="$HOME/github.com/neovim/neovim"
installdir="$HOME/opt/neovim"

if [[ ! -d "$srcroot" ]]; then
  git clone "$repo" "$srcroot"
fi

cd "$srcroot"
git checkout master
git pull

if [[ ! -d "$srcroot/.deps" ]]; then
  mkdir ".deps"
fi
pushd ".deps"
cmake "../third-party"
make
popd

if [[ ! -d "$srcroot/build" ]]; then
  mkdir "build"
fi
cd "build"
cmake -DCMAKE_INSTALL_PREFIX="$installdir" ..
make
make install

echo "nvim: exit build process"

# CREATE: 2017/01/16 09:20
# EOF
