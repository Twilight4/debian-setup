#!/bin/bash

# Welcome message
echo "$(tput setaf 6)This scripts is going to install a list of defined pentesting tools.$(tput sgr0)"
echo
echo "$(tput setaf 166)ATTENTION: It is highly recommended to edit this script to install only defined set of tools.$(tput sgr0)"
echo
read -p "$(tput setaf 6)Would you like to proceed? (y/n): $(tput sgr0)" proceed

if [ "$proceed" != "y" ]; then
    echo "Installation aborted."
    exit 1
fi

read -p "$(tput setaf 6)Did you add kali repos to your /etc/apt/sources.list? [Very Important] (y/n): $(tput sgr0)" proceed2

if [ "$proceed2" != "y" ]; then
    echo "Installation aborted. Edit your sources.list first."
    exit 1
fi

# add packages wanted here
Extra=(

)

# packages neeeded
pen_package=( 
)

# the following packages can be deleted. however, dotfiles may not work properly
pen_package_2=(
)

# Installation of main components
printf "\n%s - Installing pentesting packages.... \n"

for PKG1 in "${pen_package[@]}" "${pen_package_2[@]}" "${Extra[@]}"; do
  sudo apt install "$PKG1"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

clear
