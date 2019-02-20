#!/bin/sh
set -eu

# for Legacy MBR

# confirm $1=msg return bool
confirm() {
  (
  key=""
  counter=0
  while [ $counter -lt 3 ]; do
    counter=$(( counter + 1 ))
    printf "%s" "$1 [yes:no]?>"
    read -r key || return 1
    case "$key" in
      "no"|"n") return 1;;
      "yes"|"y") return 0;;
    esac
  done
  return 1
  )
}

if [ $# -ne 1 ]; then
  echo "not specify install device e.g. /dev/sd[X]"
  exit 1
fi

# to /dev/sd[X]
confirm "grub install to \"$1\""

# write to partition boot sector
sudo chattr -i /boot/grub/i386-pc/core.img
sudo grub-install --target=i386-pc --debug --force "$1"
sudo chattr +i /boot/grub/i386-pc/core.img

#arch-chroot /mnt
#pacman -S linux
#grub-mkconfig -o /boot/grub/grub.cfg

# output for boot.img
#dd count=1 bs=512 if="$1" of="$2"

