#!/bin/bash

# Install the kernel module using DKMS
git clone -b rebase-6.2 https://github.com/ranisalt/hp-omen-linux-module
#sudo dkms install --force hp-omen-linux-module
#reboot

# You can now modify and read the RGB values
#ls /sys/devices/platform/hp-wmi/rgb_zones
#cd /sys/devices/platform/hp-wmi/rgb_zones
#echo db0b0b > zone02
#cat zone02
