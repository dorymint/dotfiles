#!/bin/bash
# vim install to local enviroment script

set -eu

echo "hi!"
echo "Start Local vim install proccess!"

# $1=message of confirm, $2=exit message, if "$2" != "" ; then exit 1
function confirm() {
  local key=""
  local count=0
  while [[ "$key" != "yes" ]] && [[ "$key" != "y" ]]; do
    if [[ "$key" = "no" ]] || [[ "$key" = "n" ]] || [[ $count -gt 2 ]]; then
      if [[ ! -z "$2" ]];then
        echo "$2"
        exit 1
      fi
      return 1
    fi
    count=$(expr $count + 1)

    echo -n "$1"
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
      --enable-luainterp=dynamic
      --enable-perlinterp=dynamic
      --enable-python3interp=dynamic
      --enable-rubyinterp=dynamic
      --enable-terminal
      --disable-gui
      --prefix=$installdir
      --without-x
      --with-features=huge"
  ;;
  *)
    buildoption="--enable-fail-if-missing
      --prefix=$installdir
      --with-features=huge"
    echo "undefined platform"
    sleep 5
  ;;
esac

# update src
if [[ -d "$vimbuilddir" ]]; then
  cd $vimbuilddir
  git checkout master
  if confirm "update vim source? [yes:no]:>" ""; then
    git fetch
    git merge origin/master
  fi
else
  echo "not found vim src directory"
  confirm "git clone? [yes:no]:>" "stop process"
  git clone $vimrepo $vimbuilddir
  cd $vimbuilddir
  git checkout master
fi

# show configure
echo 'configure options'
for x in $buildoption; do
  echo $x
done

# build
if [[ -r ./configure ]]; then
  confirm "configure? [yes:no]:>" "stop process"
  ./configure $buildoption
  confirm "make clean && maek? [yes:no]:>" "stop process"
  make clean && make
  echo "install to $installdir"
  confirm "make install? [yes:no]:>" "stop process"
  make install
  make clean

  echo ""
  echo "Local vim, build and install successful!!"
  echo ""
else
  echo "not found ./configure"
  exit 1
fi
# EOF
