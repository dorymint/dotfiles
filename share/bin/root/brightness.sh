#!/bin/sh
set -eu

# TODO: rewrite

# require root permission

# path to sys backlight
# TODO: case of different name of directory
brroot="/sys/class/backlight/intel_backlight"
test -d "$brroot"

# max brightness
brmax="$brroot"/max_brightness
test -f "$brmax"

# current brightness
br="$brroot"/brightness
test -f "$br"

# for debug
dry_run=false

# help
helpmsg() {
  cat >&1 <<END
brightness.sh
  for set the brightness

options:
  -help
    show this help
  -get
    get current brightness: brightness.sh -get
  -getmax
    get max brightness: brightness.sh -getmax
  -getmid
    get mid brightness: brightness.sh -getmid
  -getmin
    get min brightness: brightness.sh -getmin
  -state
    get current state
  -set
    set the brightness: brightness.sh -set \$number
  -setmax
    set to max: brightness.sh -setmax
  -setmid
    set to mid: brightness.sh -setmid
  -setmin
    set to min: brightness.sh -setmin
  -inc
    increment: brightness.sh -inc \$number
  -dec
    decrement: brightness.sh -dec \$number
  -incper
    increment ten percent: brightness.sh -incper
  -decper
    decrement ten percent: brightness.sh -decper

  -d, --dry-run
    dry run
END
}

# get current brightness
getbr() {
  cat "$br"
}

# get max brightness
getmax() {
  cat "$brmax"
}

# get mid brightness
getmid() {
  echo "$(( $(getmin) * 5 ))"
}

# get min brightness
getmin() {
  (
  max=$(getmax)
  # TODO: consider minimum lengths
  echo "$(( $max / 10 ))"
  )
}

# get current state
state() {
  echo "current: $(getbr)"
  echo "max: $(getmax)"
  echo "min: $(getmin)"
}

write() {
  if [ "$dry_run" = true ]; then
    echo "dry run: write \"$1\" to \"$br\""
  else
    echo -n "$1" > "$br"
  fi
}

# set brightness
setbr() {
  (
  current=$(getbr)
  max=$(getmax)
  min=$(getmin)

  echo "brightness:"
  echo "  current=$current"
  echo "  max=$max"
  echo "  min=$min"

  # check
  if test $1 -lt $min || test $1 -gt $max; then
    echo "invalid length $1"
    return 1
  fi

  echo "set brightness to $1"
  write "$1"
  )
}

# set max
setmax() {
  (
  max=$(getmax)
  setbr $max
  )
}

setmid() {
  (
  mid=$(getmid)
  setbr $mid
  )
}

# set min
setmin() {
  (
  min=$(getmin)
  setbr $min
  )
}

# increment
inc() {
  (
  n=$(( $(getbr) + $1 ))
  setbr $n
  )
}

# decrement
dec() {
  (
  n=$(( $(getbr) - $1 ))
  setbr $n
  )
}

# increment ten percentage
incper() {
  (
  n=$(( $(getbr) + $(getmin) ))
  setbr $n
  )
}

# decrement ten percentage
decper() {
  (
  n=$(( $(getbr) - $(getmin) ))
  setbr $n
  )
}

while [ -n "${1:-}" ]; do
  case "$1" in
  -help)
    helpmsg
    exit 0
    ;;
  -get)
    getbr
    exit 0
    ;;
  -getmax)
    getmax
    exit 0
    ;;
  -getmid)
    getmid
    exit 0
    ;;
  -getmin)
    getmin
    exit 0
    ;;
  -state)
    state
    exit 0
    ;;
  -set)
    shift
    setbr "$1"
    exit 0
    ;;
  -setmax)
    setmax
    exit 0
    ;;
  -setmid)
    setmid
    exit 0
    ;;
  -setmin)
    setmin
    exit 0
    ;;
  -inc)
    shift
    inc "$1"
    exit 0
    ;;
  -dec)
    shift
    dec "$1"
    exit 0
    ;;
  -incper)
    incper
    exit 0
    ;;
  -decper)
    decper
    exit 0
    ;;
  -d|--dry-run)
    dry_run=true
    ;;
  *)
    helpmsg
    echo "invalid arguments: $*"
    exit 1
    ;;
  esac
  shift
done

# TODO: consider
helpmsg
echo "expected arguments"
exit 2
