## User Post Installation After CachyOS Installer (No Desktop)
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
bash <(curl -s https://raw.githubusercontent.com/Twilight4/arch-setup/main/install-tweaks.sh)
```
### Optional - GNOME Customization
If a user choosed GNOME Installation then you can check out my [gnome-settings](https://github.com/Twilight4/gnome-settings/) repository

### Optional - Installing tools
Additional tools can be installed using scripts in the [tools-scripts](https://github.com/Twilight4/arch-setup/tree/main/tools-scripts) directory
