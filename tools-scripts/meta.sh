#!/bin/bash

# Update system
sudo pacman -Syu

# Install necessary packages
sudo pacman -S metasploit postgresql

# RVM single-user installation
curl -L get.rvm.io > rvm-install
bash < ./rvm-install
echo 'Now, close out your current shell or terminal session and open a new one to set up your PATH and the rvm function'

