#!/bin/bash
# vim install to local enviroment script

set -eu

echo "hi!"
echo "Start Local vim install proccess!"

function confirm() {
  local key=""
  local count=0
  while [[ "$key" != "yes" ]] && [[ "$key" != "y" ]]; do
    if [[ "$key" = "no" ]] || [[ "$key" = "n" ]] || [[ $count -gt 2 ]]; then
      echo "ok... stop process"
      exit 1
    fi
    count=$(expr $count + 1)

    echo "$1"
    read key
  done
  return 0
}

vimbuilddir="$HOME/github.com/vim/vim"
vimrepo="https://github.com/vim/vim"
installdir="$HOME/opt/vim"
case "$(uname)" in
  "Linux")
  buildoption="--enable-fail-if-missing
      --enable-luainterp
      --enable-perlinterp
      --enable-pythoninterp
      --enable-python3interp
      --enable-rubyinterp
      --with-luajit
      --prefix=$installdir
      --with-features=huge"
    ;;
  *)
  buildoption="--enable-fail-if-missing
      --prefix=$installdir
      --with-features=huge"
    echo "undifined platform"
    sleep 5
    ;;
esac

# update src
if [[ -d "$vimbuilddir" ]]; then
  confirm "update vim source? [yes:no]"
  pushd $vimbuilddir
  git checkout master
  git fetch
  git merge origin/master
else
  echo "not found vim src directory"
  confirm "git clone? [yes:no]"
  git clone $vimrepo $vimbuilddir
fi

# show configure
echo 'configure options'
for x in $buildoption; do
  echo $x
done
confirm "configure? [yes:no]"

# build
if [[ -r ./configure ]]; then
  make clean
  ./configure $buildoption

  confirm "make? [yes:no]"
  make

  echo "install to $installdir"
  confirm "make install? [yes:no]"
  make install

  echo ""
  echo "Local vim, build and install successful!!"
  echo ""
else
  echo "not found ./configure"
  exit 1
fi
