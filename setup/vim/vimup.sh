#!/bin/sh

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
  msg="$1 [yes|no]?> "
  key=""
  count=0
  while true; do
    [ $count -gt 3 ] && return 1
    count=$(( count + 1 ))
    case "$key" in
      y|yes) return 0;;
      n|no) return 1;;
    esac
    printf "%s" "$msg"
    read -r key
  done
  )
}

main() {
  echo "Starting build scripts"

  echo "--- get latest source ---"
  if [ -d "$vimdir" ]; then
    cd "$vimdir"
    git checkout master
    git fetch
    if confirm "git reset --hard && git clean -f -d on $PWD"; then
      git reset --hard
      git clean -f -d
    fi
    if confirm "merge"; then
      git merge
    fi
    if [ "$ignore_confirm" = "false" ]; then
      # ignore fail
      if confirm "git log -p"; then
        git log -p || :
        confirm "continue" || exit 2
      fi
    fi
  else
    confirm "git clone to $vimdir" || exit 2
    git clone "$vimrepo" "$vimdir"
    cd "$vimdir"
    git checkout master
  fi

  echo "--- configure ---"
  # information and confirm
  for x in $buildoption; do
    echo "$x"
  done
  echo "\$cc_clang=$cc_clang"
  confirm "continue" || exit 2

  # configure
  cd "$vimdir/src"
  if [ "$cc_clang" = "true" ]; then
    CC="clang" CXX="clang++" ./configure $buildoption
  else
    ./configure $buildoption
  fi

  echo "--- make ---"
  if [ -n "$logfile" ]; then
    echo "logfile $logfile"
    confirm "continue" || exit 2
    date > "$logfile"
    make 2>&1 | tee --append -- "$logfile"
  else
    make
  fi

  echo "--- install ---"
  confirm "install to $prefix" || exit 2
  make install

  echo "... complete"
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

