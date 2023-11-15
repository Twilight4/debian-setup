#!/usr/bin/env bash

# Remove redundant packages installed by CachyOS
#sudo pacman -Rns cachyos-fish-config fish-autopair fisher fish-pure-prompt fish cachyos-zsh-config oh-my-zsh-git cachyos-hello cachyos-kernel-manager exa alacritty micro cachyos-micro-settings btop cachyos-packageinstaller vim
# Remove redundant packages installed by pacman (on Hyprland)
#sudo pacman -Rns --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-desktop-portal-wlr

# First remove bloat that came with distro installation
cachyos_bloat=(
    b43-fwcutter
    iwd
    octopi
    bash-completion
    libvdcss
    mlocate
    alsa-firmware
    alsa-plugins
    alsa-utils
    pavucontrol
    nano-syntax-highlighting
    vi
    micro
    nano
    fastfetch
    sddm
    linux
    linux-headers
    cachyos-fish-config
    fish-autopair
    fisher
    fish-pure-prompt
    fish
    cachyos-zsh-config
    oh-my-zsh-git
    cachyos-hello
    cachyos-kernel-manager
    exa
    alacritty
    micro
    cachyos-micro-settings
    btop
    cachyos-packageinstaller
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    lib32-opencl-clover-mesa
    lib32-opencl-rusticl-mesa
)

for package in "${cachyos_bloat[@]}"; do
    if pacman -Qs "$package" > /dev/null 2>&1; then
        echo "Removing $package..."
        sudo pacman -Rsn --noconfirm "$package"
    else
        echo "$package is not installed."
    fi
done
