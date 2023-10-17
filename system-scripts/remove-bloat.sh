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
    paru
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
    vim
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
)

for package in "${cachyos_bloat[@]}"; do
    if pacman -Qs "$package" > /dev/null 2>&1; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Removing $package..."
        sudo pacman -Rsn --noconfirm "$package"
    else
        printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "$package is not installed."
    fi
done

