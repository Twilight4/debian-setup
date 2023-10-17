## Personal User System Configuration Bootstrap scripts
These scripts automate the installation of user packages and configuration of system settings and services.
It streamlines the setup process, saving time and effort for system administrators and power users and ensuring a consistent and efficient setup experience across multiple systems.

### Warning
I recommend utilizing the CachyOS calamares installation of Arch Linux (No Desktop) and unchecking the X-System and (in my case) intel-ucode packages categories
for optimal performance and streamlined setup experience.

Prior to executing this script, it is imperative that users have previously run the `install-tweaks.sh` script.
This preliminary step ensures the successful application of necessary system tweaks and optimizations, adding additional pacman repositories and 
enhancing system security and the overall performance and stability.
Recommended sequence of running the scripts:
1. `install-paru.sh`
2. `remove-bloat.sh`
3. `install-packages.sh`
4. `set-user-groups.sh`
5. `enable-services.sh`
6. `install-dotfiles.sh`
7. `set-leftovers.sh`
8. `check-results.sh`

## Post-Installation for Bare Arch Linux Install (No Desktop)
### Connect to internet
```bash
nmcli dev wifi
nmcli dev wifi connect "wifi_ssid" password "wifi_password"
nmcli dev status
```

### Clone the repo and run `install-tweaks.sh` script as `root`
```bash
git clone https://github.com/Twilight4/arch-setup.git
su -
bash arch-setup/system-scripts/install-tweaks.sh
exit
```

### Optional - GNOME Customization
If a user choosed GNOME Installation, users can check out my [gnome-settings](https://github.com/Twilight4/gnome-settings/) repository

### Optional - Installing tools
Additional tools can be installed using scripts in the [tools-scripts](https://github.com/Twilight4/arch-setup/tree/main/tools-scripts) directory
