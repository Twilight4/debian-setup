## Twilight4s Arch Install

This is my script to easily install a basic Arch Linux environment with snapshots and encryption by using a fully automated process (UEFI only).
**Warning**: This script should be used for inspiration, don't run it on your system. If you want to try to install everything I would advise you to use a VM if you have to.

### How to use the script on real machine
1. Inject the USB drive with [Arch Linux ISO](https://archlinux.org/download/) and change boot order to: #1 `UEFI USB Key` and #2 `UEFI Hard Disk`.
2. After booting to the live environment connect to the internet.
3. `curl` and execute the script `bash <(curl -s https://raw.githubusercontent.com/Twilight4/arch-install-1/master/all-in-one.sh)`.
4. After succeded install and reboot, you can launch another script for deploying my desktop envorinoment on your non-root acc `./install.sh`.

## Contents
The script `install.sh` will:
1. Erase everything on the disk of your choice
2. Set the Linux filesystem to btrfs
3. Encrypt /boot with LUKS1
4. Create partitions using SUSE-like partition layout and fully working snapper snapshots & rollback
5. Install the Linux kernel of your choice and modules
6. Set up locale / time
7. Set up Grub for the boot
8. Create a new user with password
#### 9. Add security enhancements such as:
- AppArmor
- Firewalld
- Default umask to 077
- Randomize Mac Address and disable Connectivity Check for privacy
- Kernel/grub settings from [Whonix](https://github.com/Whonix/security-misc/tree/master/etc/default)
- Udev rules from [Garuda](https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-common-settings/-/tree/master/etc/udev/rules.d)
#### 10. Add performance tweaks such as:
- **Parallel** code compilation
- Building from **files in RAM**
- **OOM** handling
- Improved **kernel** characteristics:
  - Dirty Ratio
  - Dirty Background Ratio
  - OOM Dump Tasks
  - OOM Kill Allocating Task
  - Overcommit Memory
  - Swappiness
  - VFS Cache Pressure
