#!/usr/bin/env bash

# Remove athena tools - if athena was installed on the system
bloat=(
athena-neofetch-config
athena-nvchad
athena-theme-tweak
athena-tmux-config
athena-vim-config
athena-vscodium-themes
athena-system-config
athena-welcome
athena-zsh
athena-nighttab
athena-firefox-config
athena-akame-theme
athena-hyprland-config
athena-logo-grub-theme
athena-kitty-config
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

# Install athena tools
tools=(
athena-mirrorlist
athena-keyring
athena-fuzzdb
athena-osint
athena-forensic
athena-student
athena-redteamer
athena-payloadallthethings
athena-powershell-config
athena-auto-wordlists
athena-ssl-scanner
)

for package in "${tools[@]}"; do
    if ! pacman -Qi "$package" > /dev/null; then
        echo "Installing $package..."
        sudo pacman -S --noconfirm "$package"
    else
        echo "$package is already installed."
    fi
done

echo "All packages installed and bloat removed successfully!"
