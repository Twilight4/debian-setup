## Arch Linux Configuration Setup
The provided configuration files automate the installation of system-wide configuration settings and services which are used by `install.sh` script in my [dotfiles](https://github.com/Twilight4/dotfiles/) repository.
It streamlines the setup process, saving time and effort for system administrators and power users and ensuring a consistent and efficient setup experience across multiple systems.

## Installation of Arch Linux with CachyOS (No Desktop)
For optimal performance and streamlined setup experience I recommend utilizing the **[Garuda Linux](https://garudalinux.org/)** Calamares installer of Arch Linux (No Desktop). During the package selection process, I opt for essential packages only, including:
- **Base Devel**:
  - **Network**
  - **Fonts**
  - **Paru** (optional)
- **Amd-ucode** (or relevant microcode for your system)

## Post-Installation
### Upon rebooting, connect to internet and choose dotfiles installation
```bash
nmcli dev wifi
nmcli dev wifi connect "wifi_ssid" password "wifi_password"
nmcli dev status
```

### Option 1 - Installing Hyprland and dotfiles
If a user choosed Hyprland Installation, users can then run my `install.sh` script for my [dotfiles](https://github.com/Twilight4/dotfiles/) installation.

### Option 2 - Installing River and dotfiles
If a user choosed River Installation, users can check out my [river-settings](https://github.com/Twilight4/river-settings/) repository.

### Option 3 - Installing GNOME and its customization settings
If a user choosed GNOME Installation, users can check out my [gnome-settings](https://github.com/Twilight4/gnome-settings/) repository.

### Optional - Installing tools
Additional tools can be installed using scripts in the [tools-installation](https://github.com/Twilight4/arch-setup/tree/main/tools-installation) directory.
