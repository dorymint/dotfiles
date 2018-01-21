#!/bin/bash
set -eu

unset -f helpmsg
helpmsg() {
	cat >&1 <<END
ln-wall.bash
	make symbolic link for wallpaper
	ln-wall [from] [dst]
		[from] wallpaper directory
		[dst] destination directory
options:
	-h --help
		show this help
END
}
case "${1:-}" in
	-h|--help)
		helpmsg
		exit 0
		;;
esac
unset -f helpmsg

from=${1:-}
dst=${2:-}
if [[ "$from" == "" ]] || [[ "$dst" == "" ]];then
	echo "invalid state"
	echo 'require $1=from $2=dst'
	exit 1
fi

dst=$(cd "$dst" && pwd)
echo "ln-wall: dst=$dst"
count=$(find "$dst" -type l | wc -l)

from=$(cd "$from" && pwd)
echo "ln-wall: from=$from"
cd "$from"
for x in *; do
	if [ -f "$x" ]; then
		ln -s "$from/$x" "$dst/$count" && count=$(expr $count + 1)
	fi
done
