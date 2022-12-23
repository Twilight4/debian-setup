## Twilight4s Arch Install

### These are my scripts to install easily Arch Linux.
**Warning**: This set of scripts should be used for inspiration, don't run them on your system. If you want to try to install everything I would advise you to use a VM if you have to. System needs to support EFI, in VirtualBox there's an option for it in settings. Change the user to the username you want to name your account, in `install_chroot.sh` in line 152 and same with hostname in line 139 instead of `arch`, unfortunatelly there's no better way to do that. As a wiping disk method, the script uses [secure erase](https://wiki.archlinux.org/title/Solid_state_drive/Memory_cell_clearing). Using this procedure will destroy all data on the SSD and render it unrecoverable by even data recovery services.


## Instruction for checking possibility of secure erase on SATA drive
1. Inject the USB drive with Arch Linux ISO and change boot order in BIOS to: #1 `USB UEFI` and #2 `UEFI`
2. prepare disk for erase (check disk names with `lsblk` command)
```
wipefs -a /dev/sdX
sgdisk -Z /dev/sdX
pacman -Sy && pacman -S hdparm
```
Make sure the drive security is not frozen, if shows frozen then do `systemctl suspend` and check again:
```
hdparm -I /dev/sdX | grep frozen
```
enable security by setting user (temporary) password:
```
hdparm --user-master u --security-set-pass PasSWorD /dev/sdX
```
Issue the following command for sanity check:
```
hdparm -I /dev/sdX
```
- should display **enabled in Security** and output similar to this:
`2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.`
- `enhanced security erase` indicates that it performs a more elaborate wipe
- If the estimated completion time for both commands is equal it means that it uses the same function for both
- A short time (like 2 minutes) in turn indicates the device is self-encrypting and its BIOS function will wipe the internal encryption key instead of overwriting all data cells

### Warning:
- Triple check that the correct drive designation is used. There is **_no turning back_** once the command is confirmed. You have been warned.
- Ensure that the drive is not mounted when this is ran (`findmnt /mnt/sdX`). If a secure erase command is issued while the device is mounted, it will not erase properly.

~~- Issue the ATA Secure Erase command `hdparm --user-master u --security-erase PasSWorD /dev/sdX`. ~~
~~- After a successful erasure the drive security should automatically be set to disabled `hdparm -I /dev/sdX`.~~

### Launch the script
1. `curl` and execute the script `curl -LO https://raw.githubusercontent.com/Twilight4/arch-install/master/install_sys.sh`. Before launching the script do `pacman -Sy` in case the script would fail and then `bash install_sys.sh`
2. After rebooting and removing the iso, launch the script on your non-root acc `bash install_user.sh`

## Contents
Every scripts are called from `install_sys.sh`.

The first script `install_sys` will:
1. Erase everything on the disk of your choice
2. Install the Linux Kernel and modules
3. Set the Linux filesystem to ext4
4. Create partitions
   - Boot partition of 512mb
   - Swap partition default of 1gb
   - Root partition

The second script `install_chroot` will:
1. Set up locale / time
2. Set up Grub for the boot
3. Create a new user with password

The third script `install_user.sh` will:
1. Install every software specified in `paclist`
2. Install every software specified in `parulist`
3. Install my [dotfiles](https://github.com/Twilight4/dotfiles)
