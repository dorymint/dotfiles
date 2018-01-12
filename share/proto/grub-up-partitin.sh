#!/bin/sh
set -eu

# confirm $1=msg return bool
confirm() {
  local key=""
  local counter=0
  while [ $counter -lt 3 ]; do
    counter=`expr $counter + 1`
    echo -n "$1 [yes:no]?>"
    read -t 60 key || return 1
    case "$key" in
      "no"|"n") return 1;;
      "yes"|"y") return 0;;
    esac
  done
  return 1
}

# to /dev/sd[X]
confirm "install device root $1"

chattr -i /boot/grub/i386-pc/core.img
grub-install --target=i386-pc --debug --force $1
chattr +i /boot/grub/i386-pc/core.img

#arch-chroot /mnt
#pacman -S linux
#grub-mkconfig -o /boot/grub/grub.cfg

# output for boot.img
# dd count=1 bs=512 if="$1" of="$2"

# EOF
