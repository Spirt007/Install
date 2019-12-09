#!/bin/bash


loadkeys ru
setfont cyr-sun16


echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

echo '2.4 создание разделов'
(
  echo o;

  echo n;
  echo;
  echo;
  echo;
  echo +30G;

  echo n;
  echo;
  echo;
  echo;
  echo +30G;

  echo n;
  echo;
  echo;
  echo;
  echo +8G;

  echo n;
  echo p;
  echo;
  echo;
  echo a;
  echo 1;

  echo w;
) | fdisk /dev/sda

echo 'Ваша разметка диска'
fdisk -l

echo '2.4.2 Форматирование дисков'
mkfs.ext2  /dev/sda1 -L root
mkswap /dev/sda3 -L swap


echo '2.4.3 Монтирование дисков'
mount /dev/sda1 /mnt
mkdir /mnt/{root,kali,stock,home}
mount /dev/sda2 /mnt/kali
swapon /dev/sda3
mount /dev/sda4 /mnt/home
mount /dev/sdb5 /mnt/stock

echo '3.1 Выбор зеркал для загрузки. Ставим зеркало от Яндекс'
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel

echo '3.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL spirt007.github.io/Install/arch1.2.sh) "
