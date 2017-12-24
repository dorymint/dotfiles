#!/bin/bash
# vim install to local enviroment script

set -eu

vimrepo="https://github.com/vim/vim"
vimdir="${HOME}/github.com/vim/vim"
prefix="${HOME}/opt/vim"
ignore_confirm="no"
case "$(uname)" in
  "Linux")
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
function helpmsg () {
  cat >&1 <<END
  vim-build.bash

  --help -help -h	show help
  --simple -simple	symple configure options
  --yes -yes -y	ignore confirm
END
}
while [ -n "${1:-}" ]; do
  case "${1}" in
   help|--help|-help|-h) helpmsg; exit 0;;
   --simple|-simple)
     buildoption="--enable-fail-if-missing
       --enable-terminal
       --prefix=${prefix}"
     ;;
   --yes|-yes|-y)
     ignore_confirm="yes"
     ;;
  esac
  shift
done
unset -f helpmsg

# $1=message of confirm, $2=exit message, if "$2" != "" ; then exit 1
function confirm() {
  if [ "${ignore_confirm}" = "yes" ]; then
    return 0
  fi
  local key=""
  local count=0
  while [ "${key}" != "yes" ] && [ "${key}" != "y" ]; do
    if [ "${key}" = "no" ] || [ "${key}" = "n" ] || [ ${count} -gt 2 ]; then
      echo "${2}"
      return 1
    fi
    count=$(expr ${count} + 1)
    echo -n "${1}"
    read key
  done
  return 0
}

echo "hi!"
echo "Start Local vim install proccess!"

# update src
if [ -d ${vimdir} ]; then
  cd ${vimdir}
  git checkout master
  if confirm "update vim source? [yes:no]:>" ""; then
    git fetch
    git merge origin/master
    # ignore exit code
    if [ "${ignore_confirm}" != "yes" ]; then
      confirm "check: git log -p [yes:no]?:>" "" && git log -p || true
    fi
  fi
else
  echo "not found vim src directory"
  confirm "git clone? [yes:no]:>" "stop process"
  git clone ${vimrepo} ${vimdir}
  cd ${vimdir}
  git checkout master
fi


# build
cd "${vimdir}/src"
if [ -r "./configure" ]; then
  # show configure
  echo ""
  echo "configure options"
  for x in ${buildoption}; do
    echo ${x}
  done
  confirm "make distclean && ./configure? [yes:no]:>" "stop process"
  make distclean && ./configure ${buildoption}

  confirm "make clean && make? [yes:no]:>" "stop process"
  make clean && make
  echo "install to ${prefix}"
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
