#!/bin/sh
set -eu

# require root permission

# check
test -x /usr/bin/cat
cat='/usr/bin/cat'
test -x /usr/bin/expr
expr='/usr/bin/expr'

# path to sys backlight
# TODO: case of different name of directory
brroot="/sys/class/backlight/intel_backlight"
builtin test -d ${brroot}

# max brightness
brmax=${brroot}/max_brightness
builtin test -f ${brmax}

# current brightness
br=${brroot}/brightness
builtin test -f ${br}

# help
helpmsg() {
  $cat >&1 <<END
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
    set the brightness: brightness.sh -set \${number}
  -setmax
    set to max: brightness.sh -setmax
  -setmid
    set to mid: brightness.sh -setmid
  -setmin
    set to min: brightness.sh -setmin
  -inc
    increment: brightness.sh -inc \${number}
  -dec
    decrement: brightness.sh -dec \${number}
  -incper
    increment ten percent: brightness.sh -incper
  -decper
    decrement ten percent: brightness.sh -decper
END
}

# get current brightness
getbr() {
  $cat "${br}"
}

# get max brightness
getmax() {
  $cat "${brmax}"
}

# get mid brightness
getmid() {
  $expr $(getmin) \* 5
}

# get min brightness
getmin() {
  local max=$(getmax)
  # TODO: consider minimum lengths
  $expr ${max} / 10
}

# get current state
state() {
  echo "current: $(getbr)"
  echo "max: $(getmax)"
  echo "min: $(getmin)"
}

# set brightness
setbr() {
  local current=$(getbr)
  local max=$(getmax)
  local min=$(getmin)

  builtin echo "brightness:"
  builtin echo -e "\tcurrent=${current}"
  builtin echo -e "\tmax=${max}"
  builtin echo -e "\tmin=${min}"

  # check
  if builtin test ${1} -lt ${min} || builtin test ${1} -gt ${max}; then
    builtin echo "invalid length ${1}"
    return 1
  fi

  # set
  builtin echo "set brightness to ${1}"
  builtin echo -n ${1} > ${br}
}

# set max
setmax() {
  local max=$(getmax)
  setbr ${max}
}

setmid() {
  local mid=$(getmid)
  setbr ${mid}
}

# set min
setmin() {
  local min=$(getmin)
  setbr ${min}
}

# increment
inc() {
  local n=$($expr $(getbr) + ${1})
  setbr ${n}
}

# decrement
dec() {
  local n=$($expr $(getbr) - ${1})
  setbr ${n}
}

# increment ten percentage
incper() {
  local n=$($expr $(getbr) + $(getmin))
  setbr ${n}
}

# decrement ten percentage
decper() {
  local n=$($expr $(getbr) - $(getmin))
  setbr ${n}
}

while [ -n "${1:-}" ]; do
  case "${1}" in
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
    setbr ${1}
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
    inc ${1}
    exit 0
    ;;
  -dec)
    shift
    dec ${1}
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
  *)
    helpmsg
    echo "invalid arguments: [${*}]"
    exit 1
    ;;
  esac
  shift
done

# TODO: consider
helpmsg
echo "expected arguments"
exit 2
