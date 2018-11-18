#!/bin/bash

# build script for vim

set -eu

vimrepo="https://github.com/vim/vim"
vimdir="${HOME}/github.com/vim/vim"
prefix="${HOME}/opt/vim"
ignore_confirm="no"
CC=""
# not use?
CXX=""
logfile=""

case "$(uname)" in
  Linux)
    buildoption="--enable-fail-if-missing
      --enable-luainterp=dynamic
      --enable-perlinterp=dynamic
      --enable-python3interp=dynamic
      --enable-rubyinterp=dynamic
      --enable-terminal
      --disable-gui
      --without-x
      --prefix=${prefix}"
    ;;
  *)
    buildoption="--enable-fail-if-missing
      --prefix=${prefix}
      --with-features=huge"
    echo "undefined platform"
    sleep 5
    ;;
esac

# help
helpmsg() {
  cat >&1 <<END
vim-build.bash
  build vim on master branch

options:
  --help -help -h
    Show help
  --simple -simple
    Symple configure options
  --yes -yes -y
    Ignore confirm
  --with-log
    With build log
  --cc-clang
    Use CC=clang
END
}

while [ -n "${1:-}" ]; do
  case "${1}" in
    help|-help|--help|-h)
      helpmsg; exit 0
      ;;
    -simple|--simple)
      buildoption="--enable-fail-if-missing
        --prefix=${prefix}"
      ;;
    -yes|--yes|-y)
      ignore_confirm="yes"
      ;;
    -with-log|--with-log)
      [ -d "${HOME}"/dotfiles/setup/vim ] || exit 1
      logfile="${HOME}/dotfiles/setup/vim/build.log"
      date > "${logfile}"
      ;;
    -cc-clang|--cc-clang) CC="clang"; CXX="clang++";;
    *) helpmsg; echo "unknown arguments: $*"; exit 1;;
  esac
  shift
done

# confirm $1=message
confirm() {
  if [ "${ignore_confirm}" = "yes" ]; then
    return 0
  fi
  local key=""
  local count=0
  while [ "${key}" != "yes" ] && [ "${key}" != "y" ]; do
    if [ "${key}" = "no" ] || [ "${key}" = "n" ] || [ ${count} -gt 2 ]; then
      return 1
    fi
    count=$(expr ${count} + 1)
    echo -n "${1}"
    read key
  done
  return 0
}

echo "Starting build script for vim"

# update src
if [ -d ${vimdir} ]; then
  cd ${vimdir}
  git checkout master
  if confirm "git fetch && git merge origin/master [yes:no]:>"; then
    git fetch
    git merge origin/master
    # ignore exit code
    if [ "${ignore_confirm}" != "yes" ]; then
      confirm "check: git log -p [yes:no]:>" && git log -p || true
    fi
  fi
else
  echo "not found vim src directory"
  confirm "git clone [yes:no]:>"
  git clone ${vimrepo} ${vimdir}
  cd ${vimdir}
  git checkout master
fi


# main
cd "${vimdir}/src"
if [ -r "./configure" ]; then
  # show configure
  echo ""
  echo "configure options"
  for x in ${buildoption}; do
    echo ${x}
  done
  echo "CC=$CC CXX=$CXX"
  confirm "make distclean && ./configure [yes:no]:>"

  # configure
  if [ "${CC}" = "clang" ] && [ "${CXX}" = "clang++" ]; then
    make distclean && CC="clang" CXX="clang++" ./configure ${buildoption}
  else
    make distclean && ./configure ${buildoption}
  fi

  # build
  confirm "make clean && make [yes:no]:>"
  if [ -n "${logfile}" ]; then
    make clean && make 2>&1 | tee --append -- ${logfile}
  else
    make clean && make
  fi
  echo "install to ${prefix}"
  confirm "make install [yes:no]:>"
  make install
  make clean

  echo ""
  echo "Finishing build scripts"
  echo ""
fi
