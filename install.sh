#!/usr/bin/env -S bash -e

# Cleaning the TTY
clear

# Colours for text
BOLD='\e[1m'
BRED='\e[91m'
BBLUE='\e[34m'  
BGREEN='\e[92m'
BYELLOW='\e[93m'
RESET='\e[0m'

# Pretty print
info_print () {
    echo -e "${BOLD}${BGREEN}[ ${BYELLOW}•${BGREEN} ] $1${RESET}"
}

# Pretty print for input
input_print () {
    echo -ne "${BOLD}${BYELLOW}[ ${BGREEN}•${BYELLOW} ] $1${RESET}"
}

# Alert user of bad input
error_print () {
    echo -e "${BOLD}${BRED}[ ${BBLUE}•${BRED} ] $1${RESET}"
}

# Virtualization check
virt_check () {
    hypervisor=$(systemd-detect-virt)
    case $hypervisor in
        kvm )   info_print "KVM has been detected, setting up guest tools."
                pacstrap /mnt qemu-guest-agent &>/dev/null
                systemctl enable qemu-guest-agent --root=/mnt &>/dev/null
                ;;
        vmware  )   info_print "VMWare Workstation/ESXi has been detected, setting up guest tools."
                    pacstrap /mnt open-vm-tools >/dev/null
                    systemctl enable vmtoolsd --root=/mnt &>/dev/null
                    systemctl enable vmware-vmblock-fuse --root=/mnt &>/dev/null
                    ;;
        oracle )    info_print "VirtualBox has been detected, setting up guest tools."
                    pacstrap /mnt virtualbox-guest-utils &>/dev/null
                    systemctl enable vboxservice --root=/mnt &>/dev/null
                    ;;
        microsoft ) info_print "Hyper-V has been detected, setting up guest tools."
                    pacstrap /mnt hyperv &>/dev/null
                    systemctl enable hv_fcopy_daemon --root=/mnt &>/dev/null
                    systemctl enable hv_kvp_daemon --root=/mnt &>/dev/null
                    systemctl enable hv_vss_daemon --root=/mnt &>/dev/null
                    ;;
    esac
}

# Selecting a kernel to install
kernel_selector () {
    info_print "List of kernels:"
    info_print "1) Stable: Vanilla Linux kernel with a few specific Arch Linux patches applied"
    info_print "2) Zen Kernel: A Linux kernel optimized for desktop usage"
    input_print "Please select the number of the corresponding kernel: " 
    read -r kernel_choice
    case $kernel_choice in
        1 ) kernel="linux"
            return 0;;
        2 ) kernel="linux-zen"
            return 0;;
        * ) error_print "You did not enter a valid selection, please try again."
            return 1
    esac
}

# Selecting keyboard layout
keyboard_selector () {
    input_print "Please insert the keyboard layout to use in console (enter empty to use US, or \"/\" to look up for keyboard layouts): "
    read -r kblayout
    case "$kblayout" in
        '') kblayout="us"
            info_print "The standard US keyboard layout will be used."
            return 0;;
        '/') localectl list-keymaps
             clear
             return 1;;
        *) if ! localectl list-keymaps | grep -Fxq "$kblayout"; then
               error_print "The specified keymap doesn't exist."
               return 1
           fi
        info_print "Changing console layout to $kblayout."
        loadkeys "$kblayout"
        return 0
    esac
}

# User chooses the locale
locale_selector () {
    input_print "Please insert the locale you use (format: xx_XX. Enter empty to use en_US, or \"/\" to search locales): " locale
    read -r locale
    case "$locale" in
        '') locale="en_US.UTF-8"
            info_print "$locale will be the default locale."
            return 0;;
        '/') sed -E '/^# +|^#$/d;s/^#| *$//g;s/ .*/ (Charset:&)/' /etc/locale.gen | less -M
                clear
                return 1;;
        *)  if ! grep -q "^#\?$(sed 's/[].*[]/\\&/g' <<< "$locale") " /etc/locale.gen; then
                error_print "The specified locale doesn't exist."
                return 1
            fi
            return 0
    esac
}

# User enters a hostname
hostname_selector () {
    input_print "Please enter the hostname: "
    read -r hostname
    if [[ -z "$hostname" ]]; then
        error_print "You need to enter a hostname in order to continue."
        return 1
    fi
    return 0
}

# Setting up a password for the root account
rootpass_selector () {
    input_print "Please enter a password for the root user: "
    read -r -s rootpass
    if [[ -z "$rootpass" ]]; then
        echo
        error_print "You need to enter a password for the root user, please try again."
        return 1
    fi
    echo
    return 0
}

# Setting up the user account
userpass_selector () {
    input_print "Please enter name for a user account (leave empty to skip): "
    read -r username
    if [[ -z "$username" ]]; then
        return 0
    fi
    input_print "Please enter a password for $username user: "
    read -r -s userpass
    if [[ -z "$userpass" ]]; then
        echo
        error_print "You need to enter a password for $username, please try again."
        return 1
    fi
    echo
    return 0
}

# Microcode detector
microcode_detector () {
    CPU=$(grep vendor_id /proc/cpuinfo)
    if [[ "$CPU" == *"AuthenticAMD"* ]]; then
        info_print "An AMD CPU has been detected, the AMD microcode will be installed."
        microcode="amd-ucode"
    else
        info_print "An Intel CPU has been detected, the Intel microcode will be installed."
        microcode="intel-ucode"
    fi
}


######################################################################
# Welcome screen - starting installation
######################################################################
echo -ne "${BOLD}${BYELLOW}
======================================================================
TTTTTTT            iii lll iii         hh      tt     OOOOO   SSSSS  
  TTT   ww      ww     lll      gggggg hh      tt    OO   OO SS      
  TTT   ww      ww iii lll iii gg   gg hhhhhh  tttt  OO   OO  SSSSS  
  TTT    ww ww ww  iii lll iii ggggggg hh   hh tt    OO   OO      SS 
  TTT     ww  ww   iii lll iii      gg hh   hh  tttt  OOOO0   SSSSS  
                                ggggg                                
======================================================================
${RESET}"
info_print "Welcome to Twilight4s OS installation script made in order to simplify the process of installing Arch Linux."

# Choosing the target for the installation
info_print "Available disks for the installation:"
PS3="Please select the number of the corresponding disk: "
select ENTRY in $(lsblk -dpnoNAME|grep -P "/dev/sd|nvme|vd");
do
    DISK="$ENTRY"
    info_print "Arch Linux will be installed on the following disk: $DISK"
    break
done

# Setting up the kernel
until kernel_selector; do : ; done

# Setting up keyboard layout
until keyboard_selector; do : ; done

# User choses the locale
until locale_selector; do : ; done

# User choses the hostname
until hostname_selector; do : ; done

# User sets up the root/user accounts
until userpass_selector; do : ; done
until rootpass_selector; do : ; done

# formatting the disk - warn user about deletion of old partition scheme
input_print "This will delete the current partition table on $DISK once installation starts. Do you agree [y/N]?: "
read -r disk_response
if ! [[ "${disk_response,,}" =~ ^(yes|y)$ ]]; then
    error_print "Quitting."
    exit
fi

# Update live environment before using installation tools
pacman -Syy &>/dev/null
# Fixing the oudated keyring issue (not sure if it's needed)
pacman-key --init &>/dev/null
pacman-key --populate &>/dev/null
pacman -Syy &>/dev/null

info_print "Wiping $DISK."
wipefs -af "$DISK" &>/dev/null
sgdisk -Zo "$DISK" &>/dev/null

# Creating a new partition scheme
info_print "Creating new partition scheme on $DISK."
parted -s "$DISK" \
    mklabel gpt \
    mkpart ESP fat32 1MiB 513MiB \
    set 1 esp on \
    mkpart cryptroot 513MiB 100% \
    
sleep 0.1
ESP="/dev/$(lsblk $DISK -o NAME,PARTLABEL | grep ESP| cut -d " " -f1 | cut -c7-)"
cryptroot="/dev/$(lsblk $DISK -o NAME,PARTLABEL | grep cryptroot | cut -d " " -f1 | cut -c7-)"

# Informing the Kernel of the changes
info_print "Informing the Kernel about the disk changes."
partprobe "$DISK"

# Formatting the ESP as FAT32
info_print "Formatting the EFI Partition as FAT32."
mkfs.fat -F 32 -s 2 $ESP &>/dev/null

# Creating a LUKS Container for the root partition
info_print "Creating LUKS Container for the root partition."
cryptsetup luksFormat --type luks1 $cryptroot
info_print "Opening the newly created LUKS Container."
cryptsetup open $cryptroot cryptroot
BTRFS="/dev/mapper/cryptroot"

# Formatting the LUKS Container as BTRFS
info_print "Formatting the LUKS container as BTRFS."
mkfs.btrfs $BTRFS &>/dev/null
mount -o clear_cache,nospace_cache $BTRFS /mnt

# Creating BTRFS subvolumes
info_print "Creating BTRFS subvolumes."
btrfs su cr /mnt/@ &>/dev/null
btrfs su cr /mnt/@/.snapshots &>/dev/null
mkdir -p /mnt/@/.snapshots/1 &>/dev/null
btrfs su cr /mnt/@/.snapshots/1/snapshot &>/dev/null
btrfs su cr /mnt/@/boot/ &>/dev/null
btrfs su cr /mnt/@/home &>/dev/null
btrfs su cr /mnt/@/root &>/dev/null
btrfs su cr /mnt/@/srv &>/dev/null
btrfs su cr /mnt/@/var_log &>/dev/null
btrfs su cr /mnt/@/var_log_journal &>/dev/null
btrfs su cr /mnt/@/var_crash &>/dev/null
btrfs su cr /mnt/@/var_cache &>/dev/null
btrfs su cr /mnt/@/var_tmp &>/dev/null
btrfs su cr /mnt/@/var_spool &>/dev/null
btrfs su cr /mnt/@/var_lib_libvirt_images &>/dev/null
btrfs su cr /mnt/@/var_lib_machines &>/dev/null
btrfs su cr /mnt/@/var_lib_gdm &>/dev/null
btrfs su cr /mnt/@/var_lib_AccountsService &>/dev/null
btrfs su cr /mnt/@/cryptkey &>/dev/null

chattr +C /mnt/@/boot
chattr +C /mnt/@/srv
chattr +C /mnt/@/var_log
chattr +C /mnt/@/var_log_journal
chattr +C /mnt/@/var_crash
chattr +C /mnt/@/var_cache
chattr +C /mnt/@/var_tmp
chattr +C /mnt/@/var_spool
chattr +C /mnt/@/var_lib_libvirt_images
chattr +C /mnt/@/var_lib_machines
chattr +C /mnt/@/var_lib_gdm
chattr +C /mnt/@/var_lib_AccountsService
chattr +C /mnt/@/cryptkey

# Set the default BTRFS Subvol to Snapshot 1 before pacstrapping
btrfs subvolume set-default "$(btrfs subvolume list /mnt | grep "@/.snapshots/1/snapshot" | grep -oP '(?<=ID )[0-9]+')" /mnt

cat << EOF >> /mnt/@/.snapshots/1/info.xml
<?xml version="1.0"?>
<snapshot>
  <type>single</type>
  <num>1</num>
  <date>1999-03-31 0:00:00</date>
  <description>First Root Filesystem</description>
  <cleanup>number</cleanup>
</snapshot>
EOF

chmod 600 /mnt/@/.snapshots/1/info.xml

# Mounting the newly created subvolumes
umount /mnt
info_print "Mounting the newly created subvolumes."
mount -o ssd,noatime,space_cache,compress=zstd:15 $BTRFS /mnt
mkdir -p /mnt/{boot,root,home,.snapshots,srv,tmp,/var/log,/var/crash,/var/cache,/var/tmp,/var/spool,/var/lib/libvirt/images,/var/lib/machines,/var/lib/gdm,/var/lib/AccountsService,/cryptkey}
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodev,nosuid,noexec,subvol=@/boot $BTRFS /mnt/boot
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodev,nosuid,subvol=@/root $BTRFS /mnt/root
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodev,nosuid,subvol=@/home $BTRFS /mnt/home
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,subvol=@/.snapshots $BTRFS /mnt/.snapshots
mount -o ssd,noatime,space_cache=v2.autodefrag,compress=zstd:15,discard=async,subvol=@/srv $BTRFS /mnt/srv
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_log $BTRFS /mnt/var/log

# GNOME requires /var/lib/gdm and /var/lib/AccountsService to be writeable when booting into a readonly snapshot. Thus we sadly have to split them.
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_lib_gdm $BTRFS /mnt/var/lib/gdm
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/var_lib_AccountsService $BTRFS /mnt/var/lib/AccountsService

# The encryption is splitted as we do not want to include it in the backup with snap-pac
mount -o ssd,noatime,space_cache=v2,autodefrag,compress=zstd:15,discard=async,nodatacow,nodev,nosuid,noexec,subvol=@/cryptkey $BTRFS /mnt/cryptkey

mkdir -p /mnt/boot/efi
mount -o nodev,nosuid,noexec $ESP /mnt/boot/efi


######################################################################
# Installing Base System
######################################################################
# Checking the microcode to install
microcode_detector

# Pacstrap (setting up a base sytem onto the new root)
info_print "Installing the base system (it may take a while)."
pacstrap /mnt base "$kernel" "$microcode" linux-firmware "$kernel"-headers grub grub-btrfs snapper snap-pac efibootmgr sudo reflector networkmanager apparmor zram-generator irqbalance firewalld chrony &>/dev/null

# Routing jack2 through PipeWire
#echo "/usr/lib/pipewire-0.3/jack" > /mnt/etc/ld.so.conf.d/pipewire-jack.conf

# Generating /etc/fstab
info_print "Generating a new fstab."
genfstab -U /mnt >> /mnt/etc/fstab
sed -i 's#,subvolid=258,subvol=/@/.snapshots/1/snapshot,subvol=@/.snapshots/1/snapshot##g' /mnt/etc/fstab


######################################################################
# Base System Configuration
######################################################################
# Setting up the hostname
echo "$hostname" > /mnt/etc/hostname

# Configure selected locale and console keymap
echo "$locale.UTF-8 UTF-8" > /mnt/etc/locale.gen
echo "LANG=$locale" > /mnt/etc/locale.conf
echo "KEYMAP=$kblayout" > /mnt/etc/vconsole.conf

# Setting hosts file
info_print "Setting hosts file."
cat > /mnt/etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain   $hostname
EOF

# Virtualization check
virt_check

# Configuring /etc/mkinitcpio.conf
info_print "Configuring /etc/mkinitcpio for ZSTD compression and LUKS hook."
sed -i 's,#COMPRESSION="zstd",COMPRESSION="zstd",g' /mnt/etc/mkinitcpio.conf
sed -i 's,modconf block filesystems keyboard,keyboard modconf block encrypt filesystems,g' /mnt/etc/mkinitcpio.conf

# Enabling LUKS in GRUB and setting the UUID of the LUKS container
UUID=$(blkid $cryptroot | cut -f2 -d'"')
sed -i 's/#\(GRUB_ENABLE_CRYPTODISK=y\)/\1/' /mnt/etc/default/grub
echo "" >> /mnt/etc/default/grub
echo -e "# Booting with BTRFS subvolume\nGRUB_BTRFS_OVERRIDE_BOOT_PARTITION_DETECTION=true" >> /mnt/etc/default/grub
sed -i 's#rootflags=subvol=${rootsubvol}##g' /mnt/etc/grub.d/10_linux
sed -i 's#rootflags=subvol=${rootsubvol}##g' /mnt/etc/grub.d/20_linux_xen


######################################################################
# Security Enhancments
######################################################################
# Enabling CPU Mitigations
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_cpu_mitigations.cfg >> /mnt/etc/grub.d/40_cpu_mitigations.cfg

# Distrusting the CPU
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_distrust_cpu.cfg >> /mnt/etc/grub.d/40_distrust_cpu.cfg

# Enabling IOMMU
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_enable_iommu.cfg >> /mnt/etc/grub.d/40_enable_iommu.cfg

# Enabling NTS
curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf >> /mnt/etc/chrony.conf

# Setting GRUB configuration file permissions
chmod 755 /mnt/etc/grub.d/*

# Adding keyfile to the initramfs to avoid double password
dd bs=512 count=4 if=/dev/random of=/mnt/cryptkey/.root.key iflag=fullblock &>/dev/null
chmod 000 /mnt/cryptkey/.root.key &>/dev/null
cryptsetup -v luksAddKey /dev/disk/by-partlabel/cryptroot /mnt/cryptkey/.root.key
sed -i "s#quiet#cryptdevice=UUID=$UUID:cryptroot root=$BTRFS lsm=landlock,lockdown,yama,apparmor,bpf cryptkey=rootfs:/cryptkey/.root.key#g" /mnt/etc/default/grub
sed -i 's#FILES=()#FILES=(/cryptkey/.root.key)#g' /mnt/etc/mkinitcpio.conf

# Blacklisting kernel modules
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf >> /mnt/etc/modprobe.d/30_security-misc.conf
chmod 600 /mnt/etc/modprobe.d/*

# Security kernel settings
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_security-misc.conf >> /mnt/etc/sysctl.d/30_security-misc.conf
sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=3/g' /mnt/etc/sysctl.d/30_security-misc.conf
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_silent-kernel-printk.conf >> /mnt/etc/sysctl.d/30_silent-kernel-printk.conf
chmod 600 /mnt/etc/sysctl.d/*

# Remove nullok from system-auth
sed -i 's/nullok//g' /mnt/etc/pam.d/system-auth

# Disable coredump
echo "* hard core 0" >> /mnt/etc/security/limits.conf

# Disable su for non-wheel users
bash -c 'cat > /mnt/etc/pam.d/su' <<-'EOF'
#%PAM-1.0
auth		sufficient	pam_rootok.so
# Uncomment the following line to implicitly trust users in the "wheel" group.
#auth		sufficient	pam_wheel.so trust use_uid
# Uncomment the following line to require a user to be in the "wheel" group.
auth		required	pam_wheel.so use_uid
auth		required	pam_unix.so
account		required	pam_unix.so
session		required	pam_unix.so
EOF

# ZRAM configuration
info_print "Configuring ZRAM."
bash -c 'cat > /mnt/etc/systemd/zram-generator.conf' <<-'EOF'
[zram0]
zram-fraction = 1
max-zram-size = 8192
EOF

# Randomize Mac Address
bash -c 'cat > /mnt/etc/NetworkManager/conf.d/00-macrandomize.conf' <<-'EOF'
[device]
wifi.scan-rand-mac-address=yes
[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
connection.stable-id=${CONNECTION}/${BOOT}
EOF

chmod 600 /mnt/etc/NetworkManager/conf.d/00-macrandomize.conf

# Disable Connectivity Check
bash -c 'cat > /mnt/etc/NetworkManager/conf.d/20-connectivity.conf' <<-'EOF'
[connectivity]
uri=http://www.archlinux.org/check_network_status.txt
interval=0
EOF

chmod 600 /mnt/etc/NetworkManager/conf.d/20-connectivity.conf

# Enable IPv6 privacy extensions
bash -c 'cat > /mnt/etc/NetworkManager/conf.d/ip6-privacy.conf' <<-'EOF'
[connection]
ipv6.ip6-privacy=2
EOF

chmod 600 /mnt/etc/NetworkManager/conf.d/ip6-privacy.conf

# Improve virtual memory performance
bash -c 'cat > /mnt/etc/sysctl.d/98-misc.conf' <<-'EOF'
vm.dirty_background_ratio=15
vm.dirty_ratio=40
vm.oom_dump_tasks=0
vm.oom_kill_allocating_task=1
vm.overcommit_memory=1
vm.swappiness=10
vm.vfs_cache_pressure=50
EOF

######################################################################
# Configuring the system
######################################################################
info_print "Configuring the system (timezone, system clock, initramfs, Snapper, GRUB)."
arch-chroot /mnt /bin/bash -e <<EOF
    # Setting up timezone
    ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime &>/dev/null
    
    # Setting up clock
    hwclock --systohc
    
    # Generating locales
    locale-gen &>/dev/null
    
    # Generating a new initramfs
    mkinitcpio -P &>/dev/null
    
    # Snapper configuration
    umount /.snapshots
    rm -r /.snapshots
    snapper --no-dbus -c root create-config /
    btrfs subvolume delete /.snapshots &>/dev/null
    mkdir /.snapshots
    mount -a &>/dev/null
    chmod 750 /.snapshots
    
    # Installing GRUB
    echo "Installing GRUB on /boot."
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --modules="normal test efi_gop efi_uga search echo linux all_video gfxmenu gfxterm_background gfxterm_menu gfxterm loadenv configfile gzio part_gpt cryptodisk luks gcry_rijndael gcry_sha256 btrfs" --disable-shim-lock &>/dev/null
    
    # Creating grub config file
    echo "Creating GRUB config file."
    grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null
    
    # Adding user with sudo privilege
    if [ -n "$username" ]; then
        echo "Adding $username with root privilege."
        useradd -m $username
        usermod -aG wheel $username
        groupadd -r audit
        gpasswd -a $username audit
    fi
EOF

# Setting root password
info_print "Setting root password."
echo "root:$rootpass" | arch-chroot /mnt chpasswd

# Setting user password
if [[ -n "$username" ]]; then
    info_print "Adding the user $username to the system with sudo access."
    arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$username"
    info_print "Setting user password for $username."
    echo "$username:$userpass" | arch-chroot /mnt chpasswd
fi

# Parallel compilation and building from files in memory tweak
info_print "Makepkg configuration file set."
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/makepkg.conf > /mnt/etc/makepkg.conf

# Giving wheel user sudo access
info_print "Sudoers configuration file set."
#sed -i 's/# \(%wheel ALL=(ALL\(:ALL\|\)) ALL\)/\1/g' /mnt/etc/sudoers
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/sudoers > /mnt/etc/sudoers

# Pacman configuration
info_print "Pacman configuration file set."
#sed -Ei 's/^#(Color)$/\1\nILoveCandy/;s/^#(ParallelDownloads).*/\1 = 10/' /mnt/etc/pacman.conf
# Enable Chaotic-AUR
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com &>/dev/null
pacman-key --lsign-key FBA220DFC880C036 &>/dev/null
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' &>/dev/null
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/pacman.conf > /mnt/etc/pacman.conf
# Updating repos
pacman -Syy &>/dev/null

# Blacklist beep
rmmod pcspkr
echo "blacklist pcspkr" > /mnt/etc/modprobe.d/nobeep.conf

# Change audit logging group
echo "log_group = audit" >> /mnt/etc/audit/auditd.conf

# Enabling various services
info_print "Enabling Reflector, automatic snapshots, BTRFS scrubbing and systemd-oomd."
services=(auditd fstrim.timer NetworkManager apparmor firewalld irqbalance reflector.timer systemd-oomd chronyd snapper-timeline.timer snapper-cleanup.timer gdm grub-btrfs.path )
for service in "${services[@]}"; do
    systemctl enable "$service" --root=/mnt &>/dev/null
done

# Disabling systemd-timesyncd
systemctl disable systemd-timesyncd --root=/mnt &>/dev/null

# Installing user script
input_print "Do you want to install Twilight4's user installation script [y/N]?: "
read -r script_response
if ! [[ "${script_response,,}" =~ ^(yes|y)$ ]]; then
    curl https://raw.githubusercontent.com/Twilight4/dotfiles/main/install.sh > /home/$username/install.sh
    info_print "Twilight4's dotfiles script installed"
fi

# Finishing up
info_print "Done, you may now wish to reboot (further changes can be done by chrooting into /mnt)."
exit
