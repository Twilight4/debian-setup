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
