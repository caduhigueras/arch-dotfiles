#!/bin/bash

# Install neovim 
sudo pacman -S --needed --noconfirm neovim
# Clone nvim config from git
git clone git@github.com:caduhigueras/nvim2.conf.git /home/arch/.config/
