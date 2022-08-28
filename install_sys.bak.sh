#!/bin/bash

# Never run pacman -Sy on your system!
pacman -Sy dialog

# Time is correct
timedatectl set-ntp true

# Greetings
dialog --defaultno \
      --title "Are you sure?" \
      --yesno "This is my personnal arch linux install. \n\n\
      It will just DESTROY EVERYTHING on the hard disk of your choice. \n\n\
      Don't say YES if you are not sure about what you're doing! \n\n\
      Are you sure?"  15 60 || exit

# What name the uesr of script want for their new system
dialog --no-cancel --inputbox "Enter a name for your computer." \
10 60 2> comp

# Verify boot (UEFI or BIOS)
uefi=0
ls /sys/firmware/efi/efivars 2> /dev/null && uefi=1

# Choosing The Hard Disk
devices_list=($(lsblk -d | awk '{print "/dev/" $1 " " $4 " on"}' \ 
| grep -E 'sd|hd|vd|nvme|mmcblk'))
dialog --title "Choose your hard drive" --no-cancel --radiolist \
"Where do you want to install your new system? \n\n\
Select with SPACE, valid with ENTER. \n\n\
WARNING: Everything will be DESTROYED on the hard disk!" \
15 60 4 "${devices_list[@]}" 2> hd
hd=$(cat hd) && rm hd

# Size of the partitions
default_size="8"
dialog --no-cancel --inputbox \
"You need three partitions: Boot, Root and Swap \n\
The boot partition will be 512M \n\
The root partition will be the remaining of the hard disk \n\n\
Enter below the partition size (in Gb) for the Swap. \n\n\
If you don't enter anything , it will default to ${default_size}G. \n" \
20 60 2> swap_size
size=$(cat swap_size) && rm swap_size
[[ $size =~ ^[0-9]+$ ]] || size=$default_size

# Erasing the Hard Disk
dialog --no-cancel \
--title "!!! DELETE EVERYTHING !!!" \
--menu "Choose the way you'll wipe your hard disk ($hd)" \
15 60 4 \
1 "Use dd (wipe all disk)" \
2 "Use schred (slow & secure)" \
3 "No need - my hard disk is empty" 2> eraser
hderaser=$(cat eraser); rm eraser
function eraseDisk() {
case $1 in
1) dd if=/dev/zero of="$hd" status=progress 2>&1 \
| dialog \
--title "Formatting $hd..." \
--progressbox --stdout 20 60;;
2) shred -v "$hd" \
| dialog \
--title "Formatting $hd..." \
--progressbox --stdout 20 60;;
3) ;;
esac
}
eraseDisk "$hderaser"

# Creating partitions
boot_partition_type=1
[[ "$uefi" == 0 ]] && boot_partition_type=4

# Automating fdisk
#g - create non empty GPT partition table
#n - create new partition
#p - primary partition
#e - extended partition
#w - write the table to disk and exit
partprobe "$hd"
fdisk "$hd" << EOF
g
n



+512M
t
$boot_partition_type
n



+${size}G
n



w
EOF
partprobe "$hd"

# Formatting partitions
# General Case
mkswap "${hd}2"
swapon "${hd}2"
mkfs.ext4 "${hd}3"
mount "${hd}3" /mnt

# Special Case
if [ "$uefi" = 1 ]; then
mkfs.fat -F32 "${hd}1"
mkdir -p /mnt/boot/efi
mount "${hd}1" /mnt/boot/efi
fi

# Generating fstab And Installing Arch Linux
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# Persist important values for the next script
echo "$uefi" > /mnt/var_uefi
echo "$hd" > /mnt/var_hd
mv comp /mnt/comp
curl https://raw.githubusercontent.com/<your_github_user_name >\
/arch_installer/master/install_chroot.sh > /mnt/install_chroot.sh
arch-chroot /mnt bash install_chroot.sh
rm /mnt/var_uefi
rm /mnt/var_hd
rm /mnt/install_chroot.sh

# The end of install_sys script
dialog --title "To reboot or not to reboot?" --yesno \
"Congrats! The install is done! \n\n\
Do you want to reboot your computer?" 20 60
response=$?
case $response in
0) reboot;;
1) clear;;
esac
