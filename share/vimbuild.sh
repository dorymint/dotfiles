#!/bin/bash

echo "hi!"
echo "Start Local vim install proccess!"

vimbuilddir=$HOME/github.com/src/vim/vim

# test
if [[ -d "$vimbuilddir" ]]; then
  pushd $vimbuilddir || exit 1
  git checkout build || exit 1
  git fetch || exit 1
  git merge origin/master || exit 1
else
  echo "do not find vim src directory"
  exit 1
fi

if [[ -r ./configure ]]; then
  make --version || exit 1
  make clean || exit 1
  ./configure \
    --enable-fail-if-missing \
    --enable-luainterp \
    --enable-perlinterp \
    --enable-pythoninterp \
    --enable-python3interp \
    --enable-rubyinterp \
    --prefix=$HOME/opt/vim \
    --with-features=huge \
    --with-luajit \
    || exit 1
  make || exit 1
  make install || exit 1
  echo "Local vim, build and install successful!!"
else
  echo "do not find ./configure"
  exit 1
fi
