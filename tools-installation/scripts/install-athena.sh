#!/usr/bin/env bash

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
htb-tools
athena-welcome
)

for package in "${tools[@]}"; do
    if ! pacman -Qi "$package" > /dev/null; then
        echo "Installing $package..."
        sudo pacman -S --noconfirm "$package"
    else
        echo "$package is already installed."
    fi
done

echo "All packages installed successfully!"
