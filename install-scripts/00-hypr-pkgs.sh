#!/bin/bash

# Hyprland Twilight4/dotfiles Packages
# edit your packages desired here. 
# WARNING! If you remove packages here, dotfiles may not work properly.
# and also, ensure that packages are present in Debian Official Repo

# add packages wanted here
Extra=(

)

# packages neeeded
hypr_package=( 
  libayatana-appindicator3-1
  gir1.2-ayatanaappindicator3-0.1
  lsd
  swaybg
  wdisplays
  ripgrep
  silversearcher-ag
  irqbalance
  acpi
  emacs
  translate-shell
  duf
  speedtest-cli
  gnome-weather
  gnome-keyring
  cpufetch
  fd-find
  trash-cli
  linux-cpupower
  mingw-w64
  zathura
  zathura-pdf-poppler
  grc
  poppler-utils
  gnome-maps
  wf-recorder
  thefuck
  libsecret-tools
  chafa
  alsa-utils
  pipewire
  pipewire-alsa
  pipewire-audio
  pipewire-jack
  pipewire-pulse
  wireplumber
  gtk2-engines-murrine
  freerdp2-wayland
  proxychains
  dunst
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  rsync
  git
  cliphist
  grim
  gvfs
  gvfs-backends
  inxi
  kitty
  pavucontrol
  playerctl
  polkit-kde-agent-1
  python3-requests
  python3-pip
  qt5ct
  qt6ct
  slurp
  waybar
  wget
  wl-clipboard
  wlogout
  xdg-user-dirs
  xdg-utils
  yad
)
# Pip packages
#sudo pip3 install pywal pyftpdlib

# the following packages can be deleted. however, dotfiles may not work properly
hypr_package_2=(
  qt5-style-kvantum
  qt5-style-kvantum-themes
  brightnessctl
  btop
  cava
  eog
  gnome-system-monitor
  mousepad
  mpv
  mpv-mpris
  nvtop
  pamixer
  qalculate-gtk
  vim
)

# List of packages to uninstall
uninstall=(
  sway-notification-center
  fdclone
  chromium
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hypr-pkgs.log"

# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}" "${hypr_package_2[@]}" "${Extra[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

for PKG in "${uninstall[@]}"; do
  uninstall_package "$PKG" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG uninstallation had failed, please check the log"
    exit 1
  fi
done

## making brightnessctl work
sudo chmod +s $(which brightnessctl) 2>&1 | tee -a "$LOG" || true

clear
