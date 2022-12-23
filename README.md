## Twilight4s Arch Install

### These are my scripts to install easily Arch Linux.
**Warning**: This set of scripts should be used for inspiration, don't run them on your system. If you want to try to install everything I would advise you to use a VM if you have to. System needs to support EFI, in VirtualBox there's an option for it in settings. Change the user to the username you want to name your account, in `install_chroot.sh` in line 152 and same with hostname in line 139 instead of `arch`, unfortunatelly there's no better way to do that.

**Warning**: As a wiping disk method, the script uses [Secure erase](https://wiki.archlinux.org/title/Solid_state_drive/Memory_cell_clearing). Using this procedure will destroy all data on the SSD and render it unrecoverable by even data recovery services.

### Instruction for checking capabilities of secure erase on SATA drive (do it on real hardware)
1. Inject the USB drive with Arch Linux ISO and change boot order in BIOS to: #1 `USB UEFI` and on #2 `UEFI`
2. prepare disk for erase
`wipefs -a /dev/sdX`
`sgdisk -Z /dev/sdX`

# SATA drive
`pacman -Sy`
`pacman -S hdparm`
##### if shows frozen then do `systemctl suspend` and check again
`hdparm -I /dev/sdX | grep frozen`
##### enable security by setting user (temporary) password
`hdparm --user-master u --security-set-pass PasSWorD /dev/sdX`
##### Issue the following command for sanity check
`hdparm -I /dev/sdX` 
- should display **enabled in Security** and output similar to this:
`2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.`
- `enhanced security erase` indicates that it performs a more elaborate wipe
- If the estimated completion time for both commands is equal it means that it uses the same function for both
- A short time (like 2 minutes) in turn indicates the device is self-encrypting and its BIOS function will wipe the internal encryption key instead of overwriting all data cells

### Warning:
- Triple check that the correct drive designation is used. There is **no turning back** once the command is confirmed. You have been warned.
- Ensure that the drive is not mounted when this is ran (`findmnt /mnt/sdX`). If a secure erase command is issued while the device is mounted, it will not erase properly.

Issue the ATA Secure Erase command `hdparm --user-master u --security-erase PasSWorD /dev/sdX`. 
After a successful erasure the drive security should automatically be set to disabled `hdparm -I /dev/sdX`.
I̶s̶s̶u̶e̶ t̶h̶e̶ A̶T̶A̶ S̶e̶c̶u̶r̶e̶ E̶r̶a̶s̶e̶ c̶o̶m̶m̶a̶n̶d̶ `̶h̶d̶p̶a̶r̶m̶ -̶-̶u̶s̶e̶r̶-̶m̶a̶s̶t̶e̶r̶ u̶ -̶-̶s̶e̶c̶u̶r̶i̶t̶y̶-̶e̶r̶a̶s̶e̶ P̶a̶s̶S̶W̶o̶r̶D̶ /d̶e̶v̶/s̶d̶X̶`̶.  
A̶f̶t̶e̶r̶ a̶ s̶u̶c̶c̶e̶s̶s̶f̶u̶l̶ e̶r̶a̶s̶u̶r̶e̶ t̶h̶e̶ d̶r̶i̶v̶e̶ s̶e̶c̶u̶r̶i̶t̶y̶ s̶h̶o̶u̶l̶d̶ a̶u̶t̶o̶m̶a̶t̶i̶c̶a̶l̶l̶y̶ b̶e̶ s̶e̶t̶ t̶o̶ d̶i̶s̶a̶b̶l̶e̶d̶ `̶h̶d̶p̶a̶r̶m̶ -̶I̶ /d̶e̶v̶/s̶d̶X̶`̶.

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
