#!/bin/bash

TODO: add all together
sudo pacman -S --needed --noconfirm uwsm

sudo pacman -S --needed --noconfirm ripgrep
sudo pacman -S --needed --noconfirm evince

##################################
#              CRON              #
##################################

# Instal Cron implementation
sudo pacman -S --needed --noconfirm cronie

# Add it to systemd
sudo systemctl enable cronie.service
sudo systemctl start cronie.service


##################################
#          PROGRAMING            #
##################################
# TODO: add here: docker, mysql client, rust toolchain, python, go, php, node and npm





sudo pacman -S --needed --noconfirm sysstat

pacman -S --needed --noconfirm gum # for prompts

