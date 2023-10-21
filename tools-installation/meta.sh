#!/bin/bash

# Update system
sudo pacman -Syu

# Install necessary packages
sudo pacman -S metasploit postgresql

# RVM single-user installation
#curl -L get.rvm.io > rvm-install
#bash < ./rvm-install
#rm rvm-install
curl -sSL https://get.rvm.io | bash -s stable --path /opt/rvm

# Add rvm custom directory to PATH
echo 'export PATH="/opt/rvm/bin:$PATH"' >> "$HOME/.config/zsh/.zshrc"

# Informational message
echo 'Now, close out your current shell or terminal session and open a new one to set up your PATH and the rvm function.'
