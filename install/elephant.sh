#!/bin/bash

yay -S --needed --noconfirm elephant
yay -S --needed --noconfirm elephant-desktopapplications
yay -S --needed --noconfirm elephant-menus
yay -S --needed --noconfirm elephant-websearch
yay -S --needed --noconfirm elephant-clipboard
yay -S --needed --noconfirm elephant-archlinuxpkgs

elephant service enable
