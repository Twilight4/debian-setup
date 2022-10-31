## Twilight4s Arch Install

### These are my scripts to install easily Arch Linux.

**Warning**: This set of scripts should be used for inspiration, don't run them on your system. If you want to try to install everything I would advise you to use a VM if you have to. System needs to support EFI, in VirtualBox there's an option for it in settings. Change the user to the username you want to name your account, in `install_apps.sh` in line 64. Make sure to make a backup before changing anything in the script.
1. `curl` and execute the script `curl -LO https://raw.githubusercontent.com/Twilight4/arch-install/master/install_sys.sh && bash install_sys.sh`
2. After rebooting and removing the iso, launch the script on your non-root acc `bash install.sh`

## Contents
Every scripts are called from `install_sys.sh`.

The first script `install_sys` will:
1. Erase everything on the disk of your choice
2. Install the Linux ZEN Kernel and modules
3. Set the Linux filesystem to ext4
4. Create partitions
   - Boot partition of 512M
   - Swap partition default of 1G
   - Root partition

The second script `install_chroot` will:
1. Set up locale / time
2. Set up Grub for the boot
3. Create a new user with password

The third script `install_user.sh` will:
1. Install every software specified in `paclist`
2. Install every software specified in `parulist`
3. Install my [dotfiles](https://github.com/Twilight4/dotfiles)
