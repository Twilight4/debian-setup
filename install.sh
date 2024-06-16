#!/bin/bash

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

clear

# Welcome message
echo "$(tput setaf 6)Welcome to Debian Trixie/SID Hyprland Install Script!$(tput sgr0)"
echo
echo "$(tput setaf 166)ATTENTION: Run a full system update and Reboot first!! (Highly Recommended) $(tput sgr0)"
echo

read -p "$(tput setaf 6)Would you like to proceed? (y/n): $(tput sgr0)" proceed

if [ "$proceed" != "y" ]; then
    echo "Installation aborted."
    exit 1
fi

read -p "$(tput setaf 6)Have you edited your /etc/apt/sources.list? [Very Important] (y/n): $(tput sgr0)" proceed2

if [ "$proceed2" != "y" ]; then
    echo "Installation aborted. Kindly edit your sources.list first. Refer to README.md"
    exit 1
fi

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Function to colorize prompts
colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$(tput sgr0)"
}

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S).log"

# Export PKG_CONFIG_PATH for libinput
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig

# Define the directory where your scripts are located
script_directory=install-scripts

# Function to execute a script if it exists and make it executable
execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            "$script_path"
        else
            echo "Failed to make script '$script' executable."
        fi
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}

# Ensuring all in the scripts folder are made executable
chmod +x install-scripts/*

sudo apt update

# Install hyprland packages
execute_script "00-dependencies.sh"
execute_script "00-hypr-pkgs.sh"
execute_script "fonts.sh"
execute_script "imagemagick.sh"
execute_script "swappy.sh"
execute_script "swww.sh"
execute_script "rofi-wayland.sh"
execute_script "wallust.sh"
execute_script "ags.sh"
execute_script "hyprlang.sh"
execute_script "hyprlock.sh"
execute_script "hyprcursor.sh"
execute_script "hypridle.sh"
execute_script "hyprwayland-scanner.sh"
execute_script "hyprland.sh"
execute_script "hypr-eco.sh"
# execute_script "waybar-git.sh" only if waybar on repo is old


execute_script "gtk_themes.sh"
execute_script "bluetooth.sh"
execute_script "thunar.sh"
execute_script "xdph.sh"
execute_script "zsh.sh"
execute_script "InputGroup.sh"

clear

printf "\n${OK} Installation Completed Successfully.\n"
printf "\n"
sleep 2
printf "\n${NOTE} You can start Hyprland by typing Hyprland.\n"
printf "\n"
printf "\n${NOTE} It is highly recommended to reboot your system.\n\n"

read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

if [[ "$HYP" =~ ^[Yy]$ ]]; then
    systemctl reboot
fi
