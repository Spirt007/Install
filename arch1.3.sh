#!/bin/bash
mkdir ~/Downloads
cd ~/Downloads

echo 'Установка AUR (yay)'
sudo pacman -Syu
sudo pacman -S wget --noconfirm
wget git.io/yay-install.sh && sh yay-install.sh --noconfirm

echo 'Создаем нужные директории'
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

echo 'Установка программ'
sudo pacman -S firefox firefox-i18n-ru alsa-lib alsa-utils ttf-liberation ttf-dejavu bash-completion gpm opendesktop-fonts ttf-bitstream-vera ttf-arphic-ukai ttf-arphic-uming ttf-hanazono lib32-mesa-libgl os-prober doublecmd-gtk2 file-roller p7zip unrar gvfs aspell-ru pulseaudio gimp libreoffice libreoffice-fresh-ru filezilla kdenlive screenfetch vlc pidgin transmission-gtk transmission-cli djview4 gparted gnome-calculator conky conky-manager --noconfirm 
yay -S pamac-aur gksu flameshot-git sublime-text-dev downgrade sddm-config-editor-git zenity pidgin-mrim-prpl --noconfirm

echo 'Установка тем'
yay -S osx-arc-shadow papirus-maia-icon-theme-git breeze-default-cursor-theme --noconfirm
sudo pacman -S capitaine-cursors
  
echo 'Ставим лого ArchLinux в меню'
wget git.io/arch_logo.png
sudo mv -f ~/Downloads/arch_logo.png /usr/share/pixmaps/arch_logo.png


sudo rm -rf ~/Downloads
sudo rm -rf ~/arch3.sh

echo 'Установка завершена!'
