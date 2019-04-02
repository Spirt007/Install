#!/bin/bash
loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true

echo 'Разметка диска'
fdisk -l

echo '2.4.2 Форматирование дисков'
mkfs.ext4 /dev/sda1 -L root
mkfs.ext4 /dev/sda2 -L linux
mkswap /dev/sda3 -L swap
mkfs.ext4 dev/sda4 -L home

echo '2.4.3 Монтирование дисков'
mount /dev/sda1 /mnt
mkdir /mnt/{linux,home,stock}
mount /dev/sda2 /mnt/linux
mount /dev/sda4 /mnt/home
swapon /dev/sda3

echo '3.1 Выбор зеркал для загрузки. Ставим зеркало от Яндекс'
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstarp /mnt base base-devel

echo '3.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL  spirt007.github.io/Install-Arch/arch1.2.sh)"
