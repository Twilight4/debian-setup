#!/usr/bin/env bash

git clone https://github.com/Mange/rtl8192eu-linux-driver
cd rtl8192eu-linux-driver
sudo dkms add .
sudo dkms install rtl8192eu/1.0
cd -
echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/rtl8xxxu.conf
echo -e "8192eu\n\nloop" | sudo tee /etc/modules
echo "options 8192eu rtw_power_mgnt=0 rtw_enusbss=0" | sudo tee /etc/modprobe.d/8192eu.conf
sudo grub-mkconfig -o /boot/grub/grub.cfg
rm -rf rtl8192eu-linux-driver

echo 'to check installed wifi chipset you can issue a command: sudo hwinfo --network | grep Driver'
