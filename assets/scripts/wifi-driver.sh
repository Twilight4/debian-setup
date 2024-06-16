#!/usr/bin/env bash

# Clone rtl8192eu-linux-driver repository
git clone https://github.com/Mange/rtl8192eu-linux-driver
cd rtl8192eu-linux-driver

# Add the driver to DKMS and install it
sudo dkms add .
sudo dkms install rtl8192eu/1.0
cd -

# Create a blacklist file to prevent conflicting driver from loading
echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/rtl8xxxu.conf

# Add the driver module names to the modules file
echo -e "8192eu\n\nloop" | sudo tee /etc/modules

# Configure driver options using modprobe.d
echo "options 8192eu rtw_power_mgnt=0 rtw_enusbss=0" | sudo tee /etc/modprobe.d/8192eu.conf

# Update GRUB configuration
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Remove the cloned rtl8192eu-linux-driver directory
rm -rf rtl8192eu-linux-driver

# Informational message
echo 'To check the installed WiFi chipset, you can issue the command:'
echo 'sudo hwinfo --network | grep Driver'
