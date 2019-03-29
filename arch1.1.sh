#!/bin/bash
loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true

echo 'Форматирование'
echo
pacman -Sy --noconfirm
mkfs.ext4 /dev/sda4 -L home
mkfs.ext4 /dev/sda1 -L root
mkswap /dev/sda3 -L swap
mkfs.ext4 /dev/sda2 -L Linux

echo 'Монтирование'
echo
mount /dev/sda1 /mnt
mkdir /mnt/home
mkdir /mnt/Linux
mkdir /Stock
mount /dev/sda4 /mnt/home
mount /dev/sda2 /mnt/Linux
swapon /dev/sda3
mount /dev/sdb /mnt/Stock
echo
echo 'Выбор зеркал для загрузки. Ставим зеркало от Яндекс'
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo 'Установка основных пакетов'
pacstrap /mnt base base-devel

echo 'Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL spirt007.io/arch1.2.sh)"
