#!/bin/bash
set -eu

unset -f helpmsg
helpmsg() {
  cat >&1 <<END
make symbolic link for wallpaper

  ln-wall [from] [dst]

    [from] wallpaper directory
    [dst] destination directory

    -h --help
      show help
END
}
case "${1:-}" in
  "-h"|"--help") helpmsg; exit 0;;
esac
unset -f helpmsg

walldir=${1:-}
dst=${2:-}
if [[ "$walldir" == "" ]] || [[ "$dst" == "" ]];then
  echo "invalid state"
  echo 'require $1=walldir $2=dst'
  exit 1
fi

dst=$(cd "$dst" && pwd)
count=$(find "$dst" -type l | wc -l)

walldir=$(cd "$walldir" && pwd)
cd "$walldir"
for x in * ; do
  [ -f "$x" ] &&
    ln -s "$walldir/$x" "$dst/$count" &&
    count=$(expr $count + 1)
done
# EOF