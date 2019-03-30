#!/bin/bash
read -p "Введите имя компьютера: " hostname
read -p "Введите имя пользователя: " username
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Europa/Moscow /etc/localtime
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
locale-gen
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
mkinitcpio -p linux
pacman -Syy
pacman -S grub --noconfirm 
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S dialog wpa_supplicant --noconfirm 
echo 'Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username
echo 'Создаем root пароль'
passwd
echo 'Устанавливаем пароль пользователя'
passwd $username
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
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
pacman -S ttf-liberation ttf-dejavu opendesktop-fonts ttf-bitstream-vera ttf-arphik-ukai ttf-arphik-uming ttf-hanazono --noconfirm 
pacman -S networkmanager network-manager-applet ppp --noconfirm
systemctl enable NetworkManager
  pacman -S sddm sddm-kcm --noconfirm
  systemctl enable sddm.service -f
 echo 'Установка завершена! Перезагрузите систему.'
exit
