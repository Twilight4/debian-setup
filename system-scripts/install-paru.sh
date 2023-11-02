#!/usr/bin/env bash

# Exit on error
set -e

# Install required dependencies
sudo pacman -S --needed --noconfirm git ccache

# Install paru package manager from AUR
if ! command -v paru &> /dev/null; then
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg --noconfirm -si
    cd -
    rm -rf paru-bin
fi

# Clean up unused dependencies
sudo pacman -Rns --noconfirm $(pacman -Qdtq)

# Check if paru is installed
if paru --version &>/dev/null; then
    echo "Package manager installed successfully."
else
    echo "Installation of package manager failed."
fi

