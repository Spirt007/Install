#!/bin/bash
loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true
echo 'Форматирование'
pacman -Sy --noconfirm
mkfs.ext4 /dev/sda4 -L home
mkfs.ext4 /dev/sda1 -L root
mkswap /dev/sda3 -L swap
mkfs.ext4 /dev/sda2 -L Linux
echo 'Монтирование'
mount /dev/sda1 /mnt
mkdir /mnt/home
mkdir /mnt/Linux
mkdir /mnt/Stock
mount /dev/sda4 /mnt/home
mount /dev/sda2 /mnt/Linux
mount /dev/sdb5 /mnt/Stock
swapon /dev/sda3
echo 'Установка основных пакетов'
pacstrap /mnt base base-devel
echo 'Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab
arch-chroot /mnt sh -c "$(curl -fsSL  spirt007.github.io/Install-Arch/arch1.2.sh)"
