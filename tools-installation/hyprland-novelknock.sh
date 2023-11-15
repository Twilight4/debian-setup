# Installing dependencies

# For eww-wayland package before installing make sure to fetch the signing keys from GitHub and import them before building
echo 'curl -sS https://github.com/elkowar.gpg | gpg --import -i -'
echo 'curl -sS https://github.com/web-flow.gpg | gpg --import -i -'

# Python dependencies
paru -S --needed --noconfirm python-pywal python-desktop-entry-lib python-poetry python-build python-pillow
# Base dependencies
sudo pacman -S --needed --noconfirm bc blueberry bluez boost boost-libs coreutils fish gawk gnome-control-center imagemagick libqalculate light networkmanager network-manager-applet nlohmann-json plasma-browser-integration procps sox starship udev util-linux xorg-xrandr yad
# AUR Dependencies
paru -S --needed --noconfirm eww-wayland lexend-fonts-git geticons gojq python-material-color-utilities swww ttf-material-symbols-git wlogout
# Keyring
sudo pacman -S --needed --noconfirm tesseract

# Clone repo
git clone --branch novelknock --single-branch --depth 1 https://github.com/end-4/dots-hyprland.git
# Copy the firefox theme to all firefox profiles
# Firefox optional theme check out: https://github.com/Godiesc/firefox-gx 
rsync -av dots-hyprland/Import\ Manually/firefox/GNOME_red/* ~/.mercury/*
# Clean up
rm -rf dots-hyprland

# Final message
clear
echo 'Hyprland novelknock style installed successfully'
echo 'in case the GTK theme or firefox theme did not apply, use the firefox-gx firefox theme'
