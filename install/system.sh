#!/bin/bash
# TODO: Add disk mounts, pacstrap, kernel etc
# TODO: Add locales, users, hostnames, etc
sudo pacman -S --needed --noconfirm vim nano sudo iwd dhcpcd git base-devel networkmanager amd-ucode 

systemctl enable dhcpcd
systemctl enable NetworkManager
systemctl enable iwd

sudo pacman -Syy --noconfirm
sudo pacman -S --needed --noconfirm reflector rsync
sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
sudo pacman -S --needed --noconfirm nautilus pipewire wireplumber pipewire-audio pipewire-pulse dunst xdg-desktop-portal-hyprland hyprpolkitagent hyprpaper hyprlock qt5-wayland qt6-wayland waybar feh kvantum qt5ct qt6ct nwg-look bluez bluez-utils blueman sof-firmware wl-clipboard


sudo systemctl enable sddm
sudo systemctl enable bluetooth

yay -S --needed --noconfirm downgrade

sudo pacman -S --needed --noconfirm hyprland xorg


# need to install tokyo night theme
sudo pacman -S --needed --noconfirm gtk-engine-murrine 
