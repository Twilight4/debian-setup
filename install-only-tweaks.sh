#!bin/bash

#####################################################################
# Pacman configuration
#####################################################################

# Warning: This script is supposed to be run on top of arch linux base system (post installation with arch-chroot). WARNING: The sequence order is substantial
pacman-key --init
pacman-key --populate
pacman -Syy

# Copy my pacman configuration
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/pacman.conf > /etc/pacman.conf
pacman -Syy
# Enable Chaotic-AUR repo
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo '
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist' | sudo tee --append /etc/pacman.conf
pacman -Syy
## Enable Arcolinux repo
#bash <(curl -s https://raw.githubusercontent.com/arcolinux/arcolinux-spices/master/usr/share/arcolinux-spices/scripts/get-the-keys-and-repos.sh)
#pacman -Syy
# Enable Athena repo - currently he has broken keys so don't use it
#echo '
#[athena-repository]
#SigLevel = Optional TrustedOnly
#Server = https://athena-os.github.io/$repo/$arch' | sudo tee --append /etc/pacman.conf
#pacman-key --recv-keys A3F78B994C2171D5 --keyserver keyserver.ubuntu.com
#pacman -Syy
# Enable Black Arch repo
curl -O https://blackarch.org/strap.sh
echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
chmod +x strap.sh
sudo ./strap.sh
sudo pacman --noconfirm -Syu
rm strap.sh
# Update changes
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

# Warning: These configs are correct ONLY for ext4 and GRUB bootloader. I'm using my personal alis installer script with btrfs.
#curl https://raw.githubusercontent.com/Twilight4/arch-install-old/main/grub > /etc/default/grub
#grub-mkconfig -o /boot/grub/grub.cfg
# lz4 for fast compression - improved boot time performance
#curl https://raw.githubusercontent.com/Twilight4/arch-install-old/master/mkinitcpio.conf > /etc/mkinitcpio.conf
#sudo mkinitcpio -P                                                             

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
