#!/bin/bash
loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true
pacman -Sy --noconfirm
mkfs.ext4 /dev/sda1 -L root
mkfs.ext4 /dev/sda2 -L linux
mkswap /dev/sda3 -L swap
#mkfs.ext4 dev/sda4 -L home
echo
mount /dev/sda1 /mnt
mkdir /mnt/home
mkdir /mnt/linux
mkdir /mnt/stock
mount /dev/sda2 /mnt/linux
mount /dev/sda4 /mnt/home
mount /dev/sdb5 /mnt/stock
swapon /dev/sda3
echo
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
echo
pacstrap /mnt base base-devel
genfstab -pU /mnt >> /mnt/etc/fstab
arch-chroot /mnt sh -c "$(curl -fsSL  spirt007.github.io/Install-Arch/arch1.2.sh)"
