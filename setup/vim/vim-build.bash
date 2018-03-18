#!/bin/bash

# build script for vim

set -eu

vimrepo="https://github.com/vim/vim"
vimdir="${HOME}/github.com/vim/vim"
prefix="${HOME}/opt/vim"
ignore_confirm="no"
CC="clang"
# not use?
CXX="clang++"

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
	--help -help -h	show help
	--simple -simple	symple configure options
	--yes -yes -y	ignore confirm
	--cc-default	use default compiler
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
		-cc-default|--cc-default) CC=""; CXX="";;
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

echo "hi!"
echo "Start Local vim install proccess!"

# update src
if [ -d ${vimdir} ]; then
	cd ${vimdir}
	git checkout master
	if confirm "update vim source [yes:no]:>"; then
		git fetch
		git merge origin/master
		# ignore exit code
		if [ "${ignore_confirm}" != "yes" ]; then
			confirm "check: git log -p [yes:no]:>" && git log -p || true
		fi
	fi
else
	echo "not found vim src directory"
	confirm "git clone? [yes:no]:>"
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
	make clean && make
	echo "install to ${prefix}"
	confirm "make install [yes:no]:>"
	make install
	make clean

	echo ""
	echo "Local vim, build and install successful!!"
	echo ""
fi
