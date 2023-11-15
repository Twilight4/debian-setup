#!/usr/bin/env bash

# Check if nnn is installed
if command -v nnn >/dev/null; then
    # Installing plugins for nnn file manager if not installed
    echo "Installing plugins for nnn file manager..."
    plugins_dir="$HOME/.config/nnn/plugins"

    if [ -z "$(ls -A "$plugins_dir")" ]; then
        echo "Fetching nnn plugins..."

        sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

        echo "Plugins for nnn file manager installed successfully."
    else
        echo "nnn plugins directory is not empty."
    fi
else
    echo "nnn is not installed."
fi

# Install auto-cpufreq if not installed
if ! command -v auto-cpufreq >/dev/null; then
    echo "Installing auto-cpufreq..."

    git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    cd auto-cpufreq && sudo ./auto-cpufreq-installer
    sudo auto-cpufreq --install
    cd -
    sudo rm -rf ./auto-cpufreq

    echo "auto-cpufreq installed."
else
    echo "Installation of auto-cpufreq failed."
fi

# Disable the systemd-boot startup entry if systemd-boot is installed
if [ -d "/sys/firmware/efi/efivars" ] && [ -d "/boot/loader" ]; then
    echo "Disabling systemd-boot startup entry"
    sudo sed -i 's/^timeout/# timeout/' /boot/loader/loader.conf
    echo "Disabled systemd-boot startup entry"
else
    echo "systemd-boot is not being used."
fi

# Correct data locale to english
if [[ "$(localectl status)" != *"LC_TIME=en_US.UTF-8"* ]]; then
    echo "Setting LC_TIME to English..."
    sudo localectl set-locale LC_TIME=en_US.UTF-8
    sudo localectl set-locale LC_MONETARY=en_US.UTF-8
    sudo localectl set-locale LC_NUMERIC=en_US.UTF-8
    echo "LC_TIME set to English."
else
    echo "LC_TIME is already set to English."
fi

# Install GRUB theme if GRUB is installed
if command -v grub-install >/dev/null && ! command -v bootctl >/dev/null; then
    echo "Installing GRUB theme..."

    # Clone theme repository
    git clone https://github.com/HenriqueLopes42/themeGrub.CyberEXS
    mv themeGrub.CyberEXS CyberEXS

    # Move theme directory to GRUB themes directory
    sudo mv CyberEXS /boot/grub/themes/

    # Update GRUB configuration
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    # Set GRUB theme in GRUB configuration
    echo 'GRUB_THEME=/boot/grub/themes/CyberEXS/theme.txt' | sudo tee -a /etc/default/grub

    echo "GRUB theme installed."
else
    echo "GRUB bootloader is not installed, using systemd-boot."
fi

# Check if supergfxd is installed
if command -v supergfxd >/dev/null; then
    echo "Creating supergfxd configuration..."

    # Create supergfxd.conf
    sudo bash -c 'cat > /etc/supergfxd.conf' <<-'EOF'
    {
      "mode": "Hybrid",
      "vfio_enable": true,
      "vfio_save": false,
      "always_reboot": false,
      "no_logind": false,
      "logout_timeout_s": 180,
      "hotplug_type": "Asus"
    }
    EOF

    echo "supergfxd.conf created."
else
    echo "Supergfxd is not installed."
fi


# Create Hyprland desktop entry if Hyprland is installed
if command -v hyprland >/dev/null; then
    echo "Creating Hyprland desktop entry..."

    sudo bash -c 'cat > /usr/share/wayland-sessions/hyprland.desktop' <<-'EOF'
        [Desktop Entry]
        Name=Hyprland
        Comment=hyprland
        Exec="$HOME/.config/hypr/scripts/starth"   # IF CRASHES TRY: bash -c "$HOME/.config/hypr/scripts/starth"
        Type=Application
        EOF

    echo "Hyprland desktop entry created."
else
    echo "Hyprland is not installed."
fi

# Apply river settings if river is installed
if command -v river >/dev/null; then
    echo "Creating river desktop entry..."

    sudo bash -c 'cat > /usr/share/wayland-sessions/river.desktop' <<-'EOF'
        [Desktop Entry]
        Name=River
        Comment=A dynamic tiling Wayland compositor
        Exec="$HOME/.config/river/scripts/startr"
        Type=Application
        EOF

    # Modify clipboard.sh script
    sed -i 's/if \[\[ "$XDG_CURRENT_DESKTOP" == "Hyprland" \]\]; then/if \[\[ "$XDG_CURRENT_DESKTOP" == "river" \]\]; then/' ~/.config/rofi/applets/bin/clipboard.sh

    echo "River settings applied."
else
    echo "River is not installed."
fi

# Configure login manager if installed
# if command sddm exists then:
    echo "Creating /etc/sddm.conf file..."

    sudo bash -c 'cat > /etc/sddm.conf' <<-'EOF'
    # Use autologin if have problems with sddm
    #[Autologin]
    #Session=hyprland
    #User=twilight

    [Theme]
    Current=astronaut
    CursorSize=24
    CursorTheme=Numix-Cursor-Light
    Font=JetBrains Mono
    ThemeDir=/usr/share/sddm/themes
    EOF

    echo "/etc/sddm.conf file created."
else
    echo "Login manager configured."
fi

# Define the desired button layout value (remove buttons - none)
desired_button_layout=":"

# Get the current button layout value using gsettings
current_button_layout=$(gsettings get org.gnome.desktop.wm.preferences button-layout)

# Compare the current value with the desired value using an if statement
if [ "$current_button_layout" != "$desired_button_layout" ]; then
    # If they don't match, update the button layout using the gsettings command
    gsettings set org.gnome.desktop.wm.preferences button-layout "$desired_button_layout"
    # Enable transparency in emacs - will move it later
    sed -i '/;(add-to-list.*For all new frames henceforth/s/;//' your_file_name
    echo "Button layout has been updated."
else
    # If they match, display a message indicating that the value is already as desired
    echo "Button layout is already set as desired."
fi
