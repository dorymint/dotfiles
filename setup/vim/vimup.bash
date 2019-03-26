#!/bin/bash

# build script for vim

set -eu

vimrepo="https://github.com/vim/vim"
vimdir="$HOME/src/github.com/vim/vim"
prefix="$HOME/opt/vim"
ignore_confirm=false

# TODO: consider to remove
cc_clang=false
logfile=""

buildoption=""
case "$(uname)" in
  Linux)
    buildoption="--enable-fail-if-missing
      --enable-luainterp=dynamic
      --enable-perlinterp=dynamic
      --enable-python3interp=dynamic
      --enable-rubyinterp=dynamic
      --disable-gui
      --without-x
      --prefix=$prefix"
    ;;
  *)
    buildoption="--enable-fail-if-missing
      --prefix=$prefix
      --with-features=huge"
    ;;
esac

helpmsg() {
  cat >&1 <<END
Usage:
  vimup.bash [Options]

Options:
  -h, --help      Display this message
  -d, --default   Set default configure options
  -y, --yes       Ignore confirm
  --with-log FILE With build log
  --cc-clang      Use CC=clang
END
}

# confirm $1=message
confirm() {
  (
  [ "$ignore_confirm" = "true" ] && return 0
  msg="${1:-} [yes|no]?> "
  key=""
  count=0
  while true; do
    [ $count -gt 3 ] && return 1
    count=$(( count + 1 ))
    case "$key" in
      y|yes) return 0;;
      n|no) return 1;;
    esac
    echo -n "$msg"
    read -r key
  done
  )
}

main() {
  echo "Starting build scripts"

  # src
  if [ -d "$vimdir" ]; then
    cd "$vimdir"
    git checkout master
    if confirm "git fetch && git merge origin/master"; then
      git fetch
      git merge origin/master
      # fail through
      if [ "$ignore_confirm" = "false" ]; then
        if confirm "git log -p"; then
          git log -p || :
        fi
      fi
    fi
  else
    echo "not found vim src directory"
    confirm "git clone" || exit 2
    git clone "$vimrepo" "$vimdir"
    cd "$vimdir"
    git checkout master
  fi

  # information
  echo ""
  echo "configure options"
  for x in $buildoption; do
    echo "$x"
  done
  echo "\$cc_clang=$cc_clang"

  cd "$vimdir/src"

  # configure
  confirm "make distclean && ./configure"
  make distclean
  if [ "$cc_clang" = "true" ]; then
    CC="clang" CXX="clang++" ./configure $buildoption
  else
    ./configure $buildoption
  fi

  # make
  confirm "make clean && make"
  if [ -n "$logfile" ]; then
    date > "$logfile"
    make clean && make 2>&1 | tee --append -- "$logfile"
  else
    make clean && make
  fi
  echo "install to $prefix"
  confirm "make install"
  make install
  make clean

  echo ""
  echo "Finishing build scripts"
  echo ""
}

while [ $# -ne 0 ]; do
  case "$1" in
    -h|--help|-help|help)
      helpmsg
      exit 0
      ;;
    -d|--default)
      buildoption="--enable-fail-if-missing --prefix=$prefix"
      ;;
    -y|--yes)
      ignore_confirm=true
      ;;
    --with-log)
      shift
      logfile="$(readlink -f "$1")"
      if [ -e "$logfile" ];then
        echo "specified file exists: $1" >&2
        exit 1
      fi
      ;;
    -cc-clang|--cc-clang)
      cc_clang=true
      ;;
    *)
      helpmsg
      echo "invalid arguments: $*"
      exit 1
      ;;
  esac
  shift
done

main

