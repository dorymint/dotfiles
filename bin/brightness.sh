#!/bin/sh
set -eu

# require root permission

# path to sys backlight
# TODO: treat different location
brightness_root="/sys/class/backlight/intel_backlight"
test -d "$brightness_root"

# max brightness
max_brightness="$brightness_root"/max_brightness
test -f "$max_brightness"

# current brightness
current_brightness="$brightness_root"/brightness
test -f "$current_brightness"

# for debug
dry_run=false

# TODO: consider name="$(basename "$(readlink -e "$0")")"
name="brightness.sh"

helpmsg() {
  cat >&1 <<END
Description:
  set brightness by "$brightness_root"

Usage:
  $name [Options]

Options:
  -h, -help                 Show this help
  -get [""|max|mid|min]     Get brightness information
  -state                    Get current state
  -set [NUMBER|max|mid|min] Set brightness
  -inc NUMBER               Increment brightness
  -dec NUMBER               Decrement brightness
  -inc10per                 Increment 10%
  -dec10per                 Decrement 10%

  -d, --dry-run             Dry run for debug, is need already specify before

Examples:
  \$ $name -get        # Get current brightness
  \$ $name -get max    # Get max brightness
  \$ $name -set 400    # Set brightness to 400
  \$ $name -set mid    # Set brightness to mid
  \$ $name -d -set mid # Only display write info

END
}

abort() {
  echo "$*" >&2
  exit 2
}

# $1=[""|max|mid|min]
get() {
  (
  # TODO: consider min and max
  max="$(cat "$max_brightness")"
  min="$(( "$max" / 10 ))"
  mid="$(( "$min" * 5 ))"
  current="$(cat "$current_brightness")"
  case "${1:-}" in
    max) echo "$max";;
    mid) echo "$mid";;
    min) echo "$min";;
    "") echo "$current";;
    *) abort "unexpected arguments $*";;
  esac
  )
}

# get current state
state() {
  echo "current: $(get)"
  echo "max: $(get max)"
  echo "min: $(get min)"
}

# increment
inc() {
  (
  n=$(( $(get) + $1 ))
  main $n
  )
}

# decrement
dec() {
  (
  n=$(( $(get) - $1 ))
  main $n
  )
}

# increment 10%
inc10per() {
  (
  n=$(( $(get) + $(get min) ))
  main $n
  )
}

# decrement 10%
dec10per() {
  (
  n=$(( $(get) - $(get min) ))
  main $n
  )
}

write() {
  if [ "$dry_run" = true ]; then
    echo "[DRY_RUN]: write \"$1\" to \"$current_brightness\""
  else
    echo -n "$1" > "$current_brightness"
  fi
}

# set brightness $1=[NUMBER|max|mid|min]
main() {
  (
  # expected brightness
  exp="$1"

  current=$(get)
  max=$(get max)
  mid=$(get mid)
  min=$(get min)
  case "$1" in
    max) exp="$max";;
    min) exp="$min";;
    mid) exp="$mid";;
  esac

  state

  # check
  case "$exp" in
    ''|*[!0-9]*) abort "invalid arguments $*";;
    *) ;; # valid number
  esac
  if [ $exp -lt $min ] || [ $exp -gt $max ]; then
    abort "invalid length $exp"
  fi

  echo "set brightness to $exp"
  write "$exp"
  )
}

while [ $# -ne 0 ]; do
  case "$1" in
  -h|--help|-help)
    helpmsg
    exit 0
    ;;
  -get)
    shift
    get "${1:-}"
    exit 0
    ;;
  -state)
    state
    exit 0
    ;;
  -set)
    shift
    main "$1"
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
  -inc10per)
    inc10per
    exit 0
    ;;
  -dec10per)
    dec10per
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

helpmsg
echo "expected arguments"
exit 2

