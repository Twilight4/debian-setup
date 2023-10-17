#!/usr/bin/env bash

# Update system
sudo pacman --noconfirm -Syu

# Install required dependencies
sudo pacman -S --noconfirm git ccache

# Install paru package manager from AUR
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg --noconfirm -si
cd ..
rm -rf paru-bin

# Clean up unused dependencies
sudo pacman -Rns --noconfirm $(pacman -Qdtq)

# Check if paru is installed
if paru --version &>/dev/null; then
    printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Package manager installed successfully."
else
    printf '%b%s%b\n' "${FX_BOLD}${FG_RED}" "Installation of package manager failed."
fi

