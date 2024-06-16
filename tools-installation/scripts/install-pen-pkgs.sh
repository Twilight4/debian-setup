#!/bin/bash

# Pentesting Packages
# Edit your packages desired here. 

# add packages wanted here
Extra=(

)

# packages neeeded
pen_package=( 
)

# the following packages can be deleted. however, dotfiles may not work properly
pen_package_2=(
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_pen-pkgs.log"

# Installation of main components
printf "\n%s - Installing pentesting packages.... \n" "${NOTE}"

for PKG1 in "${pen_package[@]}" "${pen_package_2[@]}" "${Extra[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

clear
