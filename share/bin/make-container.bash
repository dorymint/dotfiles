#!/bin/bash
set -eu

### variable
# destination directory path
dst=""
# if need then fix
additional_pkg=" \
  base \
  rxvt-unicode-terminfo \
  --ignore linux \
  "
# locale
sed_locale_option=" \
  -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/' \
  -e 's/^#\(ja_JP.UTF-8 UTF-8\)/\1/' \
  "
locale_conf="LANG=en_US.UTF-8
LANGUAGE=en_US:ja_JP
LC_MESSAGES=C"

### function
# help
function helpmsg () {
  cat >&1 <<END
  make-container.bash
    make container for systemd-nspawn

  usage:
    make-container.bash [option] [additional packages]
    make-container.bash -dir [name of new container] [additional pkg]

  option:
    -help
    -dir {specify name of new continer directory}

  defaults packages:
    ${additional_pkg}

  example:
    cd workdir && sudo make-container.bash -dir ./new-container base-devel vim
END
}

### parse
while [ -n "${1:-}" ]; do
  case "$1" in
    help|--help|-help|-h) helpmsg; exit 0;;
    --dir|-dir) shift; dst=${1};;
    *) additional_pkg="${additional_pkg} ${1}";;
  esac
  shift
done
unset -f helpmsg

### check
echo "--- use commands ---"
command -v pacman
command -v pacstrap
command -v mkdir
command -v sed
echo "--------------------"
if ! [ ${EUID:-${UID}} = 0 ]; then
  echo "require root"
  exit 1
fi
if [ -z ${dst} ]; then
  echo "not specify name of new container directory"
  echo "require: -dir [name of new container directory]"
  exit 1
fi
if [ -x ${dst} ]; then
  echo "directory is exists: -dir ${dst}"
  exit 1
fi

### create container
mkdir ${dst}
pacstrap -i -c -d ${dst} ${additional_pkg}
# locale
sed ${sed_locale_option} "${dst}/etc/locale.gen" | cat > "${dst}/etc/locale.gen"
echo "${locale_conf}" > "${dst}/etc/locale.conf"
# host
hostname="$(basename ${dst})"
echo "${hostname}" > "${dst}/etc/hostname"

### msg
echo "-----------------------------------"
echo "new container was created in ${dst}"
echo "use: systemd-nspawn -b -D ${dst}"
echo "--- require after login on root ---"
echo "run: locale-gen"
echo "add: '127.0.1.1 ${hostname}.localdomain ${hostname}' to /etc/hosts"
echo "--- if need network-bridge ---"
echo "run: systemctl enable nftables"
echo "run: systemctl enable systemd-networkd"
echo "fix: /etc/nftables.conf"
echo "fix: /etc/resolv.conf"
echo "-----------------------------------"
# EOF
