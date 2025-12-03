#!/bin/bash

sudo pacman -S --needed --noconfirm uwsm


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

