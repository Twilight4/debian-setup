#!bin/bash

# Warning: This script is supposed to be run on top of arch linux base system (post installation with arch-chroot). WARNING: The sequence order is substantial
pacman-key --init
pacman-key --populate
pacman -Syy

# Enable Chaotic-AUR keys and repos as well as Arcolinux keys and repos
######################################################################################################################

sudo pacman -S wget --noconfirm --needed

echo "Getting the ArcoLinux keys from the ArcoLinux repo - report if link is broken"
sudo wget https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-keyring-20251209-3-any.pkg.tar.zst -O
/tmp/arcolinux-keyring-20251209-3-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-keyring-20251209-3-any.pkg.tar.zst

echo "Getting the latest arcolinux mirrors file - report if link is broken"
sudo wget https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-mirrorlist-git-22.12-01-any.pkg.tar.zs
t -O /tmp/arcolinux-mirrorlist-git-22.12-01-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-mirrorlist-git-22.12-01-any.pkg.tar.zst

######################################################################################################################

if grep -q arcolinux_repo /etc/pacman.conf; then

    echo "ArcoLinux repos are already in /etc/pacman.conf"

else

echo '
#[arcolinux_repo_testing]
#SigLevel = Optional TrustedOnly
#Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo]
SigLevel = Optional TrustedOnly
Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo_3party]
SigLevel = Optional TrustedOnly
Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo_xlarge]
SigLevel = Optional TrustedOnly
Include = /etc/pacman.d/arcolinux-mirrorlist' | sudo tee --append /etc/pacman.conf

fi

pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/pacman.conf > /etc/pacman.conf
pacman -Syy


#####################################################################
# Security Enhancments
#####################################################################

##### Comment out if you are using systemd-boot instead of grub #######
# Enabling CPU Mitigations
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_cpu_mitigations.cfg >> /etc/grub.d/40_cpu_mitigations.cfg
# Distrusting the CPU
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_distrust_cpu.cfg >> /etc/grub.d/40_distrust_cpu.cfg
# Enabling IOMMU
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_enable_iommu.cfg >> /etc/grub.d/40_enable_iommu.cfg
# Enabling NTS
curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf >> /etc/chrony.conf
# Setting GRUB configuration file permissions
chmod 755 /etc/grub.d/*

# Blacklisting kernel modules
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf >> /etc/modprobe.d/30_security-misc.conf
chmod 600 /etc/modprobe.d/*

# Security kernel settings
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_security-misc.conf >> /etc/sysctl.d/30_security-misc.conf
sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=3/g' /etc/sysctl.d/30_security-misc.conf
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_silent-kernel-printk.conf >> /etc/sysctl.d/30_silent-kernel-printk.conf
chmod 600 /etc/sysctl.d/*

# Remove nullok from system-auth
sed -i 's/nullok//g' /etc/pam.d/system-auth

# Disable coredump
echo "* hard core 0" >> /etc/security/limits.conf

# Disable su for non-wheel users
bash -c 'cat > /etc/pam.d/su' <<-'EOF'
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
bash -c 'cat > /etc/systemd/zram-generator.conf' <<-'EOF'
[zram0]
zram-fraction = 1
max-zram-size = 8192
EOF

# Randomize Mac Address
bash -c 'cat > /etc/NetworkManager/conf.d/00-macrandomize.conf' <<-'EOF'
[device]
wifi.scan-rand-mac-address=yes
[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
connection.stable-id=${CONNECTION}/${BOOT}
EOF

chmod 600 /etc/NetworkManager/conf.d/00-macrandomize.conf

# Disable Connectivity Check
bash -c 'cat > /etc/NetworkManager/conf.d/20-connectivity.conf' <<-'EOF'
[connectivity]
uri=http://www.archlinux.org/check_network_status.txt
interval=0
EOF

chmod 600 /etc/NetworkManager/conf.d/20-connectivity.conf

# Enable IPv6 privacy extensions
bash -c 'cat > /etc/NetworkManager/conf.d/ip6-privacy.conf' <<-'EOF'
[connection]
ipv6.ip6-privacy=2
EOF

chmod 600 /etc/NetworkManager/conf.d/ip6-privacy.conf

# Improve virtual memory performance
bash -c 'cat > /etc/sysctl.d/98-misc.conf' <<-'EOF'
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

# Warning: These configs are correct for ext4 and GRUB bootloader. If you installed btrfs with snapper or systemd-boot then comment out these 4 lines
curl https://raw.githubusercontent.com/Twilight4/arch-install-old/main/grub > /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
# lz4 for fast compression - improved boot time performance
curl https://raw.githubusercontent.com/Twilight4/arch-install-old/master/mkinitcpio.conf > /etc/mkinitcpio.conf
sudo mkinitcpio -P                                                             

# Parallel compilation and building from files in memory tweak
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/makepkg.conf > /etc/makepkg.conf

# Giving wheel user sudo access
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/sudoers > /etc/sudoers

# Blacklist beep
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# Change audit logging group
echo "log_group = audit" >> /etc/audit/auditd.conf

# Disabling systemd-timesyncd
#systemctl disable systemd-timesyncd

# Installing user script
curl https://raw.githubusercontent.com/Twilight4/dotfiles/main/install.sh > /home/twilight/install.sh

# Finishing up
echo "Done, you may now reboot and afterward run user install.sh script and reboot again."
