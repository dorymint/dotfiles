#!/bin/sh
set -eu

list="next.list"
log="log.txt"

# TODO: fix exe
# use in exec_cmd
exe="echo"

# sleep sec
delay="1200-1800"

# help
helpmsg() {
  cat >&1 <<END
append.sh
  TODO: fix cmd name
  append arguments to ${list}

options:
  -help
    show this help
  -exec
    exec cmd
  -dry-run
    check results for -exec
  -xclip
    append from xclip
  -show
    cat ${list}
END
}

# cat $list
show() {
  [ -f "${list}" ] || return 1
  echo "--- cat ${list} ---"
  local l=$(cat "${list}")
  echo "${l}"
  echo -n "[wc -l]: "
  echo "${l}" | wc -l
}

isvalid() {
  if echo "${1:-}" | grep -e '^https\?://*' &> /dev/null; then
    return 0
  fi
  return 1
}

# append to ${list}
# ${1}=${string}
append() {
  if ! isvalid "${1}"; then
    echo "invalid arguments: ${1}"
    return 2
  fi
  if grep -w "${1}" -- "${list}" &> /dev/null; then
    echo "duplicated: ${1} in ${list}"
    return 2
  fi

  echo "${1}" >> "${list}"
  echo "appended: ${1}"
  show
}

dryrun() {
  local l=$(cat "${list}")
  for x in ${l}; do
    echo "${exe} ${x}"
    local d=$(shuf -i ${delay} -n 1)
    echo "delay: ${d}"
  done
}

exec_cmd() {
  local l=$(cat "${list}")
  local left=$(echo "${l}" | wc -l)
  : > ${log}
  for x in ${l}; do
    if ${exe} ${x}; then
      echo "${x}" >> ${log}
    else
      echo "[err]: ${x}" >> ${log}
    fi
    echo "left: ${left}" >> ${log}

    local d=$(shuf -i ${delay} -n 1)
    local left=$(expr ${left} - 1)
    echo "left: ${left}"
    echo "delay: ${d}"
    sleep ${d}
  done
  # trunc
  : > "${list}"
}

while [ -n "${1:-}" ]; do
  case "${1}" in
    help|-help|--help|-h)
      helpmsg
      exit 0
      ;;
    exec|-exec)
      exec_cmd
      exit 0
      ;;
    dry-run|-dry-run)
      dryrun
      exit 0
      ;;
    xclip|-xclip)
      append "$(xclip -o)"
      exit 0
      ;;
    show|-show)
      show
      exit 0
      ;;
    *)
      append "${1}"
      exit 0
      ;;
  esac
  shift
done

helpmsg
exit 1
