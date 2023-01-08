# this file is supposed to be run on top of arch linux base system (post installation with arch-chroot). WARNING: The sequence order is substantial
pacman-key --init
pacman-key --populate
pacman -Syy

# Enable Chaotic-AUR
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/pacman.conf > /mnt/etc/pacman.conf
# Enable BlackArch repo

pacman -Syy
