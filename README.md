## System Configuration scripts
The provided scripts automate the installation of user packages and configuration of system settings and services.
It streamlines the setup process, saving time and effort for system administrators and power users and ensuring a consistent and efficient setup experience across multiple systems.

### Installation with CachyOS
For optimal performance and streamlined setup experience I recommend utilizing the **CachyOS** Calamares installer of Arch Linux (No Desktop). During the package selection process, I opt for essential packages only, including:
 - **Network**
 - **Fonts**
 - **Amd-ucode** (or relevant microcode for your system)

## Post-Installation for Bare Arch Linux Install (No Desktop)
### Connect to internet
```bash
nmcli dev wifi
nmcli dev wifi connect "wifi_ssid" password "wifi_password"
nmcli dev status
```

### Run `install-tweaks.sh` script as root
Prior to executing custom scripts, it is imperative that users have previously run the `install-tweaks.sh` script as **root**.
This preliminary step ensures the successful application of necessary system tweaks and optimizations, adding additional pacman repositories and 
enhancing system security and the overall performance and stability.

```bash
git clone https://github.com/Twilight4/arch-setup.git
su -
bash arch-setup/system-scripts/install-tweaks.sh
exit
```

#### Recommended sequence of running the scripts
1. `remove-bloat.sh`
2. `install-paru.sh`
3. `install-packages.sh`
4. `set-user-groups.sh`
5. `enable-services.sh`
6. `install-dotfiles.sh`
7. `set-leftovers.sh`

### Optional - GNOME Customization
If a user choosed GNOME Installation, users can check out my [gnome-settings](https://github.com/Twilight4/gnome-settings/) repository.

### Optional - Installing tools
Additional tools can be installed using scripts in the [tools-installation](https://github.com/Twilight4/arch-setup/tree/main/tools-installation) directory.
