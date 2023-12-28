#!/bin/bash

# Install the kernel module using DKMS
git clone -b rebase-6.2 https://github.com/ranisalt/hp-omen-linux-module
#sudo dkms install --force hp-omen-linux-module
#reboot

# Run my omen-keyboard script as root to set a color value to RGB zones
#su
#omen-keyboard

# You can now modify and read the RGB values manually
#ls /sys/devices/platform/hp-wmi/rgb_zones
#cd /sys/devices/platform/hp-wmi/rgb_zones
#echo db0b0b > zone02
#cat zone02
