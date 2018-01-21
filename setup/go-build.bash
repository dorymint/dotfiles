#!/bin/bash
set -eu

protocol="https:"
repo="//go.googlesource.com/go"
#repo="//github.com/golang/go"
goroot="$HOME/github.com/golang/go"

goversion="go1.9.2"
#goversion="master"

#bootstrap="gcc-go"
bootstrap="go1.4.3"
#bootstrap="go1.4-bootstrap"

# confirm $1=msg return bool
confirm() {
	local key=""
	local counter=0
	while [ $counter -lt 3 ]; do
		counter=`expr $counter + 1`
		echo -n "$1 [yes:no]>"
		read -t 60 key || return 1
		case "$key" in
			no|n) return 1;;
			yes|y) return 0;;
		esac
	done
	return 1
}
# help
helpmsg() {
	cat >&1 <<END
go-build.bash

options:
	-help
		show this help
	-target
		specify build tag (default: ${goversion})

example:
	go-build.bash -target master
	go-build.bash -target 1.9.2
END
}
while [ -n "${1:-}" ]; do
	case "$1" in
		help|-help|--help|-h) helpmsg; exit 0;;
		-target) shift; goversion=${1};;
	esac
	shift
done
unset -f helpmsg

# check goroot
if [[ ! -d "$goroot" ]]; then
	echo "from : $protocol$repo"
	echo "clone: $goroot"
	confirm "git clone ?"
	git clone "$protocol$repo" "$goroot"
fi

# update src
if confirm "fetch $goroot ?"; then
	cd "$goroot/src"
	git fetch
fi

# build
echo "bootstrap=$bootstrap"
case "$bootstrap" in
	"go1.4.3")
		[[ ! -d "$HOME/$bootstrap" ]] && git clone --no-local --branch="$bootstrap" "$goroot" "$HOME/$bootstrap"
		if confirm "build/update $bootstrap ?"; then
			type clang
			cd "$HOME/$bootstrap/src"
			git fetch
			git checkout $bootstrap
			# build go1.4.3
			clang --version > /dev/null
			clang++ --version > /dev/null
			CC=clang CXX=clang++ CGO_ENABLED=0 ./make.bash
			#./make.bash
		fi
		cd "$goroot/src"
		git checkout "$goversion"
		confirm "build $goversion ?"
		if confirm "$goversion prebuild: git clean ?"; then
			git clean --force
		fi
		GOROOT_BOOTSTRAP="$HOME/$bootstrap" ./all.bash
		;;
	"go1.4-bootstrap")
		if confirm "make go boot strap ?"; then
			cd "$HOME/$bootstrap/src"
			clang --version > /dev/null
			clang++ --version > /dev/null
			CC=clang CXX=clang++ CGO_ENABLED=0 ./make.bash
		fi
		cd "$goroot/src"
		git checkout "$goversion"
		confirm "build $goversion ?"
		if confirm "$goversion prebuild: git clean ?"; then
			git clean --force
		fi
		GOROOT_BOOTSTRAP="$HOME/$bootstrap" ./all.bash
		;;
	"gcc-go")
		confirm "build $goversion ?"
		cd "$goroot/src"
		git checkout "$goversion"
		GOROOT_BOOTSTRAP="/usr" ./all.bash
		;;
	*)
		echo "bootstrap=$bootstrap is invalid"; exit 1
		;;
esac
