#!/bin/bash

#TODO: add check for rust tool chain

# Install calendar TUI
git clone git@github.com:caduhigueras/kr_calendar_tui.git ~/.local/share/kr-calendar-tui
cd ~/.local/share/kr-calendar-tui
cargo build --release
sudo cp target/release/kr_calendar_tui /usr/local/bin

# Install impala
sudo pacman -S --needed --noconfirm impala

# Install Bluetui
sudo pacman -S --needed --noconfirm bluetui

# Install wiremix
sudo pacman -S --needed --noconfirm wiremix
