#!/bin/bash

set -eu

repo="https://go.googlesource.com/go"
branch="release-branch.go1.11"
#branch="master"
goroot="$HOME/github.com/golang/go"

bootstrap_branch="release-branch.go1.4"
bootstrap_dir="$HOME"/"$bootstrap_branch"

ignore_confirm=false

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
  go-build.bash [Options]

Options:
  -h, --help   Display this message
  -b, --branch Specify build branch (default: $branch)
  -y, --yes    Ignore confirm

Examples:
  go-build.bash -branch master
  go-build.bash -branch release-branch.go1.11
END
}

abort() {
	echo "$*" >&2
	exit 2
}

up_bootstrap() {
	(
	# cd  "$bootstrap_dir"
	if [ -d "$bootstrap_dir" ]; then
		cd "$bootstrap_dir"
		git fetch
	elif [ ! -e "$bootstrap_dir" ]; then
		git clone "$repo" "$bootstrap_dir"
		cd "$bootstrap_dir"
	else
		abort "invalid path of bootstrap: $bootstrap_dir"
	fi

	git checkout "$bootstrap_branch"
	git merge

	# NOTE: build with gcc is failed
	command -v clang > /dev/null || abort "command not found \"clang\""
	command -v clang++ > /dev/null || abort "command not found \"clang++\""
	echo "--- clang version ---"
	echo "clang --version"
	clang --version
	echo "clang++ --version"
	clang++ --version
	echo "---------------------"

	cd "$bootstrap_dir"/src

	echo "--- git clean --force --dry-run ---"
	git clean --force --dry-run
	echo "-----------------------------------"
	if confirm "$bootstrap_branch prebuild: git clean --force"; then
		git clean --force
	fi

	CC=clang CXX=clang++ CGO_ENABLED=0 ./make.bash
	)
}

build() {
	(
	# cd "$goroot"
	if [ ! -e "$goroot" ];then
		echo "not found $goroot"
		confirm "git clone $repo $goroot" || abort "stopped"
		git clone "$repo" "$goroot"
		cd "$goroot"
	elif [ -d "$goroot" ]; then
		cd "$goroot"
		git fetch
	else
		abort "invalid path of goroot: $goroot"
	fi

	git checkout "$branch"
	git merge

	cd "$goroot"/src

	echo "--- git clean --force --dry-run ---"
	git clean --force --dry-run
	echo "-----------------------------------"
	if confirm "$branch prebuild: git clean --force"; then
		git clean --force
	fi

	GOROOT_BOOTSTRAP="$bootstrap_dir" ./all.bash
	)
}

main() {
	(
	if [ -d "$bootstrap_dir" ]; then
		if confirm "build bootstrap $bootstrap_branch"; then
			up_bootstrap || abort "stopped"
		else
			abort "stopped"
		fi
	else
		up_bootstrap
	fi

	confirm "build $branch" || abort "stopped"
	build
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
		*)
			abort "unexpected arguments $*"
			;;
	esac
	shift
done

main

# vim: noexpandtab shiftwidth=2 tabstop=2 softtabstop=2
