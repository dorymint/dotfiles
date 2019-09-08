#!/bin/bash
set -eu

# TODO: consider to remove

echo "exit"
exit 1

### variable
# destination directory path
dst=""
# if need then fix
additional_pkg=" \
  base \
  rxvt-unicode-terminfo \
  --ignore linux \
  "
# accept override for -dir
force="no"

# locale
# TODO: fix sed_locale_option
#sed_locale_option=" \
#  -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/' \
#  -e 's/^#\(ja_JP.UTF-8 UTF-8\)/\1/' \
#  "

locale_conf="LANG=en_US.UTF-8
LANGUAGE=en_US:ja_JP
LC_MESSAGES=C"

### function
# help
helpmsg() {
  cat >&1 <<END
make-container.bash
  make container for systemd-nspawn

usage:
  make-container.bash [option] [additional packages]
  make-container.bash -dir [name of new container] [additional pkg]

option:
  -help
  -dir {specify name of new continer directory}
  -force

defaults packages:
  ${additional_pkg}

example:
  cd workdir && sudo make-container.bash -dir ./new-container base-devel vim
END
}

### parse
while [ -n "${1:-}" ]; do
  case "$1" in
    --help|-help|-h) helpmsg; exit 0;;
    --dir|-dir) shift; dst=${1};;
    --force|-force) force="yes";;
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
if [ -x ${dst} ] && [ "${force}" != "yes" ]; then
  echo "directory is exists: -dir ${dst}"
  exit 1
fi

### create container
[ -x ${dst} ] || mkdir ${dst}
pacstrap -i -c -d ${dst} ${additional_pkg}
# locale
sed -i.back \
  -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/' \
  -e 's/^#\(ja_JP.UTF-8 UTF-8\)/\1/' \
 "${dst}/etc/locale.gen"
echo "${locale_conf}" > "${dst}/etc/locale.conf"
# host
hostname="$(basename ${dst})"
echo "${hostname}" > "${dst}/etc/hostname"

### msg
cat <<END
-----------------------------------
new container was created in ${dst}
use: systemd-nspawn -b -D ${dst}
--- require after login on root ---
run: locale-gen
consider: add '127.0.1.1 ${hostname}.localdomain ${hostname}' to /etc/hosts
--- if need network-bridge ---
run: systemctl enable nftables
run: systemctl enable systemd-networkd
fix: /etc/nftables.conf
fix: /etc/resolv.conf
-----------------------------------
END


### make script
init_dir="${dst}/root/init"
back_dir="${dst}/root/back"
[ -x ${init_dir} ] || mkdir -p "${init_dir}"
[ -x ${back_dir} ] || mkdir -p "${back_dir}"
cat <<END > "${init_dir}/set-locale.bash"
#!/bin/bash
set -eu

# locale
sed -i.back \
  -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/' \
  -e 's/^#\(ja_JP.UTF-8 UTF-8\)/\1/' \
 "/etc/locale.gen"
echo "${locale_conf}" > "/etc/locale.conf"

# host
echo "${hostname}" > "/etc/hostname"
echo "consider add '127.0.1.1 ${hostname}.localdomain ${hostname}' to /etc/hosts"

locale-gen
END

nameserver=$(grep -e 'nameserver' /etc/resolv.conf)
cat <<END > "${init_dir}/enable-networkd.bash"
#!/bin/bash
set -eu

cp "/etc/resolv.conf" "${back_dir}"
echo "${nameserver}" > /etc/resolv.conf

# consider
#systemctl enable nftables

systemctl enable systemd-networkd
END
