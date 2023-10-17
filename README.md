## Personal User System Configuration Bootstrap scripts
These scripts automate the installation of user packages and configuration of system settings and services.
It streamlines the setup process, saving time and effort for system administrators and power users and ensuring a consistent and efficient setup experience across multiple systems.

### Warning
I recommend utilizing the CachyOS calamares installation of Arch Linux (No Desktop) and unchecking the X-System and (in my case) intel-ucode packages categories
for optimal performance and streamlined setup experience.

Prior to executing this script, it is imperative that users have previously run the `install-tweaks.sh` script.
This preliminary step ensures the successful application of necessary system tweaks and optimizations, adding additional pacman repositories and 
enhancing system security and the overall performance and stability.




## Post-Installation for Bare Arch Linux Install (No Desktop)
### Connect to internet
```bash
nmcli dev wifi
nmcli dev wifi connect "wifi_ssid" password "wifi_password"
nmcli dev status
```

### Run `install-tweaks.sh` script as root
```bash
su -
bash <(curl -s https://raw.githubusercontent.com/Twilight4/arch-setup/main/install-tweaks.sh)
exit
```

### Run `install.sh`
```bash
bash <(curl -s https://raw.githubusercontent.com/Twilight4/arch-setup/main/install.sh)
```
### Optional - GNOME Customization
If a user choosed GNOME Installation, users can check out my [gnome-settings](https://github.com/Twilight4/gnome-settings/) repository

### Optional - Installing tools
Additional tools can be installed using scripts in the [tools-scripts](https://github.com/Twilight4/arch-setup/tree/main/tools-scripts) directory
