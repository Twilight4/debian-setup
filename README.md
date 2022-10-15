## Twilight4s Arch Install

### These are my scripts to install easily Arch Linux.

**Warning**: This set of scripts should be used for inspiration, don't run them on your system. If you want to try to install everything I would advise you to use a VM if you have to. System needs to support EFI, in VirtualBox there's an option for it in settings. In few lines of script you have to change the user to the username you want to name your account, in `install_apps.sh` in line 64 and in `install.sh` in lines 46, 75-93, 115-125
1. `curl` and execute the script `curl -LO https://raw.githubusercontent.com/Twilight4/arch-install/master/install_sys.sh && bash install_sys.sh`
2. After reboot launch the script with sudo `sudo bash install.sh`

## Contents
Every scripts are called from `install_sys.sh`.

The first script `install_sys` will:
1. Erase everything on the disk of your choice
2. Create partitions
   - Boot partition of 200MB
   - Swap partition
   - Root partition

The second script `install_chroot` will:
1. Set up locale / time
2. Set up Grub for the boot
3. Create a new user with password

The third and forth scripts `install_apps` and `install.sh` will:
1. Install every software specified in `paclist`
2. Install every software specified in `yalist`
3. Install my [dotfiles](https://github.com/Twilight4/dotfiles)
