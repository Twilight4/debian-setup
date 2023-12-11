#!/usr/bin/env bash

# Remove garuda bloat if garuda linux was installed on the system
bloat=(
garuda-dracut-support
garuda-hotfixes
garuda-libs
garuda-hooks
garuda-migrations
#garuda-browser-settings
#garuda-setup-assistant
#garuda-common-settings
#garuda-system-maintenance
#garuda-boot-options
#garuda-network-assistant
#mhwd-garuda-git
#garuda-assistant
#garuda-welcome
garuda-icons
garuda-gamer
#grub-theme-garuda
#garuda-settings-manager
garuda-hyprland-settings
garuda-wallpapers
garuda-wallpapers-extra
# Other bloat that can come with distro installation
adobe-source-han-sans-cn-fonts
adobe-source-han-sans-jp-fonts
adobe-source-han-sans-kr-fonts
alsa-utils
archlinux-themes-sddm
armcord-git
asciinema
bash-completion
blesh-git
bless
broadcom-wl-dkms
bashtop
dialog
edex-ui-bin
edk2-shell
eog
espeakup
flameshot
gparted
grub-customizer
hexedit
lvm2
most
myman
nautilus
nbd
netctl
nss-mdns
octopi
orca
os-prober
sl
)

for package in "${bloat[@]}"; do
   if pacman -Qs "$package" > /dev/null 2>&1; then
       echo "Removing $package..."
       sudo pacman -Rsn --noconfirm "$package"
   else
       echo "$package is not installed."
   fi
done

echo "All garuda bloat removed successfully!"
