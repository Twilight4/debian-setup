#!/bin/bash

# Getting Back the Block Devices and the Boot Mode
uefi=$(cat /var_uefi); hd=$(cat /var_hd)

# Naming Your Newborn System
cat /comp > /etc/hostname && rm /comp

# Installing The Bootloader GRUB
pacman --noconfirm -S dialog
pacman -S --noconfirm grub
if [ "$uefi" = 1 ]; then
pacman -S --noconfirm efibootmgr
grub-install --target=x86_64 -efi \
--bootloader -id=GRUB \
--efi-directory=/boot/efi
else
grub-install "$hd"
fi
grub-mkconfig -o /boot/grub/grub.cfg

# Set hardware clock from system clock
hwclock --systohc
timedatectl set-timezone "<your_timezone >"

# Configuring the Locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Root Password and User Creation
function config_user() {
if [ -z "$1" ]; then
dialog --no-cancel --inputbox "Please enter your user name." \
10 60 2> name
else
echo "$1" > name
fi
dialog --no-cancel --passwordbox "Enter your password." \
10 60 2> pass1
dialog --no-cancel --passwordbox "Confirm your password." \
10 60 2> pass2
while [ "$(cat pass1)" != "$(cat pass2)" ]
do
dialog --no-cancel --passwordbox \
"The passwords do not match.\n\nEnter your password again." \
10 60 2> pass1
dialog --no-cancel --passwordbox \
"Retype your password." \
10 60 2> pass2
done
name=$(cat name) && rm name
pass1=$(cat pass1) && rm pass1 pass2
# Create user if doesn't exist
if [[ ! "$(id -u "$name" 2> /dev/null)" ]]; then
useradd -m -g wheel -s /bin/bash "$name"
fi
# Add password to user
echo "$name:$pass1" | chpasswd
}
dialog --title "Root password" \
--msgbox "It's time to add a password for the root user" \
10 60
config_user root
dialog --title "Add user" \
--msgbox "Let's create another user." \
10 60
config_user

# install all the applications
echo "$name" > /tmp/user_name
dialog --title "Continue installation" --yesno \
"Do you want to install all your apps and your dotfiles?" \
10 60 \
&& curl https://raw.githubusercontent.com/Twilight4 >\
/arch-install/master/install_apps.sh > /tmp/install_apps.sh \
&& bash /tmp/install_apps.sh
