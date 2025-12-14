##!/bin/bash
# GTK
# git clone https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme /home/arch/Downloads/gtk-tokyonight
# cd /home/arch/Downloads/gtk-tokyonight/themes
# ./install.sh


# QT
git clone https://github.com/0xsch1zo/Kvantum-Tokyo-Night.git /home/arch/Downloads/qt-tokyonight
cd /home/arch/Downloads/qt-tokyonight
mkdir -p ~/.config/Kvantum
cp -r Kvantum-Tokyo-Night ~/.config/Kvantum/


# Apply GTK icons theme - TODO: must run after stow of icons folder
gsettings set org.gnome.desktop.interface icon-theme "TokyoNight-SE"
