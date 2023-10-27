# Installing dependencies
# Python dependencies
paru -S --needed --noconfirm python-pywal python-desktop-entry-lib python-poetry python-build python-pillow
# Base dependencies
sudo pacman -S --needed --noconfirm bc blueberry bluez boost boost-libs coreutils curl findutils fish fuzzel fzf gawk gnome-control-center ibus imagemagick libqalculate light networkmanager network-manager-applet nlohmann-json pavucontrol plasma-browser-integration playerctl procps ripgrep socat sox starship udev upower util-linux xorg-xrandr waybar wget wireplumber yad
# AUR Dependencies
paru -S --needed --noconfirm cava eww-wayland-git lexend-fonts-git geticons gojq gtklock gtklock-playerctl-module gtklock-powerbar-module gtklock-userinfo-module hyprland-git python-material-color-utilities swww ttf-material-symbols-git xdg-desktop-portal-hyprland-git wlogout
# Keyring
sudo pacman -S --needed --noconfirm gnome-keyring polkit-gnome 
sudo pacman -S --needed --noconfirm tesseract cliphist grim slurp

# Clone repo
git clone --branch --single-branch novelknock https://github.com/end-4/dots-hyprland.git
# .config dir
rsync -av --exclude='hypr/' dots-hyprland/.config/ ~/.config
# icons, fonts and themes
rsync -av dots-hyprland/.local/share/icons/Bibata-Modern-Classic ~/.config/.local/share/
rsync -av dots-hyprland/.local/share/fonts ~/.config/.local/share/
rsync -av dots-hyprland/.themes ~/.config/.local/share/themes
# firefox/chromium theme
rsync -av dots-hyprland/chromethemes ~/.config/

# Copy the theme to all firefox profiles
rsync -av dots-hyprland/Import\ Manually/firefox/GNOME_red/* ~/.mozilla/firefox/*
# Firefox theme check out: https://github.com/Godiesc/firefox-gx 



# TODO Manually
# Get "Plasma browser integration" extension for your browser
# For Chromium Browser: Go to chrome:extensions, Click "Load Unpacked", choose ~/.config/chromethemes/desired-theme
