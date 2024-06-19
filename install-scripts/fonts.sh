#!/bin/bash

# Fonts required
fonts=(
fonts-firacode
fonts-font-awesome
fonts-noto
fonts-noto-cjk
fonts-noto-color-emoji
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_fonts.log"

# Installation of main components
printf "\n%s - Installing fonts.... \n" "${NOTE}"

for PKG1 in "${fonts[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done


# Jetbrains nerd font - necessary for waybar
printf "\n%s - Downloading and Extracting Jetbrains Mono Nerd Font.... \n" "${NOTE}"
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
# Maximum number of download attempts
MAX_ATTEMPTS=3
for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
    curl -OL "$DOWNLOAD_URL" 2>&1 | tee -a "$LOG" && break
    echo "Download attempt $ATTEMPT failed. Retrying in 2 seconds..." 2>&1 | tee -a "$LOG"
    sleep 2
done

# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d ~/.config/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf ~/.config/.local/share/fonts/JetBrainsMono 2>&1 | tee -a "$LOG"
fi

mkdir -p ~/.config/.local/share/fonts/JetBrainsMono

# Extract the new files into the JetBrainsMono folder and log the output
tar -xJkf JetBrainsMono.tar.xz -C ~/.config/.local/share/fonts/JetBrainsMono 2>&1 | tee -a "$LOG"


# Meslo nerd font
printf "\n%s - Downloading and Extracting Meslo Nerd Font.... \n" "${NOTE}"
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.tar.xz"
# Maximum number of download attempts
MAX_ATTEMPTS=3
for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
    curl -OL "$DOWNLOAD_URL" 2>&1 | tee -a "$LOG" && break
    echo "Download attempt $ATTEMPT failed. Retrying in 2 seconds..." 2>&1 | tee -a "$LOG"
    sleep 2
done

# Check if the Meslo folder exists and delete it if it does
if [ -d ~/.config/.local/share/fonts/Meslo ]; then
    rm -rf ~/.config/.local/share/fonts/Meslo 2>&1 | tee -a "$LOG"
fi

mkdir -p ~/.config/.local/share/fonts/Meslo

# Extract the new files into the Meslo folder and log the output
tar -xJkf Meslo.tar.xz -C ~/.config/.local/share/fonts/Meslo 2>&1 | tee -a "$LOG"


# Update font cache and log the output
fc-cache -v 2>&1 | tee -a "$LOG"

clear
