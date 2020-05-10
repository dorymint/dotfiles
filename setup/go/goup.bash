#!/bin/bash

# doc: <https://golang.org/doc/install/source>

set -eu

url="https://go.googlesource.com/go"
#url="https://github.com/golang/go"

path="${url#https://}"

goroot="$HOME/src/$path"

#branch="release-branch.go1.13"
#branch="master"
branch="go1.14.2"

branch_bootstrap="release-branch.go1.4"
goroot_bootstrap="$HOME"/src/localhost/"$branch_bootstrap"

ignore_confirm=false
fetch_only=false

# confirm $1=msg return bool
confirm() {
	(
	[ "$ignore_confirm" = "true" ] && return 0
	key=""
	count=0
	while [ $count -lt 3 ]; do
		count=$(( count + 1 ))
		case "$key" in
			no|n) return 1;;
			yes|y) return 0;;
		esac
		echo -n "$1 [yes:no]?> "
		read -r key
	done
	return 1
	)
}

helpmsg() {
	cat >&1 <<END
Usage:
  goup.bash [Options]

Options:
  -h, --help   Display this message
  -b, --branch Specify build branch (default: $branch)
  -y, --yes    Ignore confirm
  --fetch      Only fetch

Examples:
  goup.bash -branch master
  goup.bash -branch release-branch.go1.11
END
}

abort() {
	echo "$*" >&2
	exit 2
}

fetch() {
	(
	bra="$1"
	dir="$2"

	if [ -d "$dir" ]; then
		cd "$dir"
		git fetch
	elif [ ! -e "$dir" ]; then
		confirm "git clone $url $dir" || abort "stopped"
		git clone "$url" "$dir"
	else
		abort "already exist: $dir"
	fi
	git checkout "$bra"
	)
}

build() {
	(
	bra="$1"
	dir="$2"

	cd "$dir"/src

	out="$(git clean --force --dry-run)"
	if [ ! "$out" = "" ]; then
		echo "--- git clean --force --dry-run ---"
		echo "$out"
		echo "-----------------------------------"
		if confirm "$bra prebuild: git clean --force"; then
			git clean --force
		fi
	fi

	case "$bra" in
		"$branch")
			GOROOT_BOOTSTRAP="$goroot_bootstrap" ./all.bash
		;;
		"$branch_bootstrap")
			CC=clang CXX=clang++ CGO_ENABLED=0 ./make.bash
		;;
		*) abort "invalid branche: $bra";;
	esac
	)
}

main() {
	(
	command -v clang > /dev/null || abort "command not found \"clang\""
	command -v clang++ > /dev/null || abort "command not found \"clang++\""
	echo "--- clang --version ---"
	clang --version
	echo "--- clang++ --version ---"
	clang++ --version
	echo "---------------------"

	fetch "$branch" "$goroot"
	fetch "$branch_bootstrap" "$goroot_bootstrap"
	if [ "$fetch_only" = "true" ]; then
		return
	fi

	if [ -d "$goroot_bootstrap" ]; then
		if confirm "rebuild bootstrap $branch_bootstrap"; then
			build "$branch_bootstrap" "$goroot_bootstrap" || abort "stopped"
		fi
	else
		build "$branch_bootstrap" "$goroot_bootstrap"
	fi

	confirm "build $branch" || abort "stopped"
	build "$branch" "$goroot"
	)
}

while [ $# -ne 0 ]; do
	case "$1" in
		help|-help|--help|-h)
			helpmsg
			exit 0
			;;
		-b|--branch)
			shift
			branch="$1"
			;;
		-y|--yes)
			ignore_confirm=true
			;;
		--fetch)
			fetch_only=true
			;;
		*)
			abort "unexpected arguments $*"
			;;
	esac
	shift
done

main

# vim:noexpandtab:shiftwidth=2:tabstop=2:softtabstop=2:
