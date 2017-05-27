#!/bin/bash
set -eu

protocol="https:"
repo="//go.googlesource.com/go"
#repo="//github.com/golang/go"
goroot="$HOME/github.com/golang/go"

goversion="go1.8.3"

#bootstrap="gcc-go"
bootstrap="go1.4.3"

# confirm $1=msg return bool
function confirm () {
  local key=""
  local counter=0
  while [ $counter -lt 3 ]; do
    counter=`expr $counter + 1`
    echo -n "$1 [yes:no]>"
    read -t 60 key || return 1
    case "$key" in
      "no"|"n") return 1;;
      "yes"|"y") return 0;;
    esac
  done
  return 1
}

# git
git version

# check goroot
if [[ ! -d "$goroot" ]]; then
  echo "from : $protocol$repo"
  echo "clone: $goroot"
  confirm "git clone ?"
  git clone "$protocol$repo" "$goroot"
fi

# update src
if confirm "update $goroot ?"; then
  cd "$goroot/src"
  git checkout master
  git pull
fi

# build
echo "bootstrap=$bootstrap"
confirm "build $goversion ?"
case "$bootstrap" in
  "go1.4.3")
    [[ ! -d "$HOME/$bootstrap" ]] && git clone --no-local "$goroot" "$HOME/$bootstrap"
    if confirm "build/update go1.4.3 ?"; then
      cd "$HOME/$bootstrap/src"
      git checkout master
      git pull
      git checkout $bootstrap
      # build go1.4.3
      clang --version > /dev/null
      clang++ --version > /dev/null
      CC=clang CXX=clang++ ./make.bash
    fi
    cd "$goroot/src"
    git checkout "$goversion"
    GOROOT_BOOTSTRAP="$HOME/$bootstrap" ./all.bash ;;
  "gcc-go")
    cd "$goroot/src"
    git checkout "$goversion"
    GOROOT_BOOTSTRAP="/usr" ./all.bash ;;
  *) echo "bootstrap=$bootstrap is invalid"; exit 1 ;;
esac

# EOF
