#!/bin/bash
read -p "Введите имя компьютера: " hostname
read -p "Введите имя пользователя: " username

echo 'Прописываем имя компьютера'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Europa/Moscow /etc/localtime

echo 'Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Обновим текущую локаль системы'
locale-gen

echo 'Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Создадим загрузочный RAM диск'
mkinitcpio -p linux

echo 'Устанавливаем загрузчик'
pacman -Syy
pacman -S grub --noconfirm 
grub-install /dev/sda

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 

echo 'Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username

echo 'Создаем root пароль'
passwd

echo 'Устанавливаем пароль пользователя'
passwd $username

echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo "Устанавливем X"
pacman -S xorg-server xorg-drivers xorg-xinit xorg-apps mesa-ligl xterm lib32-mesa-libgl --noconfirm

echo "Какая видеокарта у вас?"
read -p "1 - Intel, 2 - Nvidia, 3 - AMD" vm_setting
if [[ $vm_setting == 1 ]]; then
  pacman -S xf86-video-intel --noconfirm
elif [[ $vm_setting == 2 ]]; then
  pacman -S xf86-video-nouveau --noconfirm
elif [[ $vm_setting == 3 ]]; then
  pacman -S  xf86-video-ati --noconfirm
fi

echo "Какое DE ставим?"
read -p "1 - XFCE, 2 - KDE,3 - Cinnammon" vm_setting
if [[ $vm_setting == 1 ]]; then
  pacman -S xfce4 xfce4-goodies --noconfirm
elif [[ $vm_setting == 2 ]]; then
  pacman -Sy plasma-meta kdebase --noconfirm
elif [[ $vm_setting == 3 ]]; then
  pacman -S  cinnamon nemo-fileroller --noconfirm
fi

echo 'Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu opendesktop-fonts ttf-bitstream-vera ttf-arphik-ukai ttf-arphik-uming ttf-hanazono --noconfirm 

echo 'Ставим сеть'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echo 'Установка SDDM'
  pacman -S sddm sddm-kcm --noconfirm
  systemctl enable sddm.service -f
  
echo 'Установка завершена! Перезагрузите систему.'
exit
