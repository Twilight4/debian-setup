## Building custom Kali ISO
### Clone Repo
```bash
# Install packages
sudo apt update
sudo apt install -y git live-build simple-cdd cdebootstrap curl
git clone https://gitlab.com/kalilinux/build-scripts/live-build-config.git
```
### Customize packages
Edit packages for defualt installer: `nvim live-build-config/kali-config/installer-default`.

Build an updated installer image: `./build.sh --verbose --installer`
```bash
# Metapackages
# You can customize the set of Kali metapackages (groups of tools) available
# in the installer ISO.
# For the complete list see: https://tools.kali.org/kali-metapackages

# System Core Packages
kali-linux-firmware
kali-linux-core
#kali-linux-default
kali-linux-headless
kali-system-cli
kali-system-core

# Tools
kali-tools-exploitation
kali-tools-information-gathering
kali-tools-passwords
kali-tools-post-exploitation
kali-tools-respond
kali-tools-top10
kali-tools-windows-resources
#kali-tools-bluetooth
#kali-tools-802-11
#kali-tools-rfid
#kali-tools-sdr
#kali-tools-sniffing-spoofing
#kali-tools-social-engineering
#kali-tools-wireless
```

## Installing Hyprland and dotfiles on Kali Linux
### Preparation
1. Install default latest [kali linux](https://www.kali.org/get-kali/#kali-installer-images) iso image
2. Shrink disk space for kali
3. Install kali linux
    - Graphical install
    - Domain section empty
    - Guided - use entire disk
    - All files in one partition
    - Continue
    - Uncheck installing DE
4. While restarting PC, eject the pendrive and boot into kali

### Installing Hyprland
1. Update system
```bash
sudo apt update && sudo apt -y full-upgrade -y
```
2. Reboot
```bash
sudo reboot now
```
3. Modify apt sources list
```bash
sudo vim /etc/apt/sources.list
```
- uncomment the second line with deb-src
4. Update source list
```bash
sudo apt update
```
5. Install dependencies
```bash
sudo apt install libdrm-dev python3-pip
```
6. Install JaKooLit's dotfiles script
```bash
git clone --depth=1 https://github.com/JaKooLit/Debian-Hyprland.git
\cd Debian-Hyprland
chmod +x install.sh
./install.sh
```
7. Script installation
    - proceed - y
    - edited sources.list - y
    - have any nvidia gpu - n
    - GTK Themes - n
    - configure bluetooth - y
    - thunar file manager - y
    - configure SDDM - n
    - XDG_DESKTOP_PORTAL - y
    - zsh & oh-my-zsh - n
    - swaylock-effects - y
    - nwg-look - n
    - asus ROG - n 
    - Hyprland dotfiles? - n 
    - reboot - y

### Add myself to sudoers file
```bash
sudo vim /etc/sudoers
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL

# Make sure I'm in sudoers group
cat /etc/group | grep sudo

# If I'm not, execute this command
sudo usermod -aG sudo "$(whoami)"
```

### Core system configuration & dotfiles
```bash
git clone --depth 1 https://github.com/Twilight4/dotfiles ~/
\cd dotfiles
./install.sh
#cp -r ~/dotfiles/.config ~/
rm -rf dotfiles

# Download zsh config
curl -LO https://raw.githubusercontent.com/Twilight4/arch-setup/main/config-files/kali-zsh/.zshrc
curl -LO https://raw.githubusercontent.com/Twilight4/arch-setup/main/config-files/kali-zsh/aliases.zsh

mv .zshrc ~/.config/zsh/.zshrc
mv aliases.zsh ~/.config/zsh/aliases.zsh
```

## Installing more tools
```bash
# Installing [Meslo Fonts](https://www.nerdfonts.com/font-downloads)
unzip ~/downloads/meslo
cp ~/downloads/meslo /usr/share/fonts/meslo
fc-cache -fv

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

# Install NVChad
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

# Install pipmykali
sudo git clone https://github.com/Dewalt-arch/pimpmykali.git /opt/pipmykali
\cd /opt/pimpmykali
sudo ./pipmykali.sh
#Choose option: 0, =, @

# Install xh
curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh

# Install dog
curl -LO dog-v0.1.0-x86_64-unknown-linux-gnu.zip
extract dog-v0.1.0-x86_64-unknown-linux-gnu.zip
sudo cp dog-v0.1.0-x86_64-unknown-linux-gnu/bin/dog /bin
rm -rf dog-v0.1.0-x86_64-unknown-linux-gnu dog-v0.1.0-x86_64-unknown-linux-gnu.zip 
# Fix a problem: error while loading shared libraries: libssl.so.1.1: cannot open shared object file: No such file or directory
wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb

# Install xcp
cargo install xcp
# If xcp installation fails - Reinstall rust to get the newest version and install xcp
#sudo apt remove rustc
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
#cargo install xcp

# Install ledger (there's also emacs package)
sudo apt-get install build-essential cmake autopoint texinfo python3-dev \
     zlib1g-dev libbz2-dev libgmp3-dev gettext libmpfr-dev \
     libboost-date-time-dev libboost-filesystem-dev \
     libboost-graph-dev libboost-iostreams-dev \
     libboost-python-dev libboost-regex-dev libboost-test-dev
git clone git@github.com:ledger/ledger.git
\cd ledger && ./acprep update

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
# Use ~/.fzf/uninstall script to remove/reinstall fzf.

# Install pvpn stable version - https://protonvpn.com/support/official-linux-vpn-debian/
#wget https://repo2.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-3_all.deb
#sudo dpkg -i ./protonvpn-stable-release_1.0.3-3_all.deb && sudo apt update
#sudo apt install proton-vpn-gnome-desktop

# Install pvpn beta linux app - https://protonvpn.com/support/official-linux-vpn-debian/
# can't log in issue - https://www.reddit.com/r/ProtonVPN/comments/wogofb/cant_log_into_proton_vpn_linux_app_any_more/
# first try just rebooting, if doens't help - uninstall strongswan and related packages and reboot
wget https://repo.protonvpn.com/debian/dists/unstable/main/binary-all/protonvpn-beta-release_1.0.3-3_all.deb
sudo dpkg -i ./protonvpn-beta-release_1.0.3-3_all.deb && sudo apt update
sudo apt install proton-vpn-gnome-desktop

# Install cheat - check for newest version: https://github.com/cheat/cheat/blob/master/INSTALLING.md
\cd /tmp \
  && wget https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz \
  && gunzip cheat-linux-amd64.gz \
  && chmod +x cheat-linux-amd64 \
  && sudo mv cheat-linux-amd64 /bin/cheat

# Install Brave Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# Install freetube - https://github.com/FreeTubeApp/FreeTube/releases
wget https://github.com/FreeTubeApp/FreeTube/releases/download/v0.20.0-beta/freetube_0.20.0_amd64.deb
sudo dpkg -i sudo dpkg -i freetube_0.20.0_amd64.deb
rm freetube_0.20.0_amd64.deb

# Install GNOME authenticator from Flathub - https://flathub.org/apps/com.belmoussaoui.Authenticator
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.belmoussaoui.Authenticator

# Install sliver's pre-compiled versions of the server and client - https://github.com/BishopFox/sliver/releases/tag/v1.5.42
wget -q https://github.com/BishopFox/sliver/releases/download/v1.5.42/sliver-server_linux
chmod +x ./sliver-server_linux
sudo mv sliver-server_linux /bin/sliver-server
wget -q https://github.com/BishopFox/sliver/releases/download/v1.5.42/sliver-client_linux
chmod +x ./sliver-client_linux
sudo mv sliver-client_linux /bin/sliver-client

# Install nnn
sudo apt install libreadline-dev
git clone --depth 1 https://github.com/jarun/nnn.git
\cd nnn
sudo make O_NERD=1
# or
sudo make CFLAGS+=-march=native O_NORL=1 O_NOMOUSE=1 O_NOBATCH=1 O_NOSSN=1 O_NOFIFO=1 O_QSORT=1 O_NOUG=1 O_NERD=1
\cd ../
sudo mv nnn /opt
sudo ln -sf /opt/nnn /bin/nnn
# or
sudo cp /opt/nnn/nnn /bin

# Install delta - Download git-delta_0.17.0_amd64.deb from https://github.com/dandavison/delta/releases
sudo dpkg -i git-delta*.deb
rm git-delta*.deb

# Install newsboat
sudo apt update
# Install dependencies from https://github.com/newsboat/newsboat
sudo apt install libncursesw5-dev ncurses-term debhelper libxml2-dev libstfl-dev libsqlite3-dev perl pkg-config libcurl4-gnutls-dev librtmp-dev libjson-c-dev asciidoc libxml2-utils xsltproc docbook-xml docbook-xsl bc asciidoctor cargo
git clone --depth 1 https://github.com/newsboat/newsboat.git
\cd newsboat  
make
sudo make install
\cd ..
sudo mv newsboat /opt/
sudo ln -sf /opt/newsboat/newsboat /bin/newsboat

# Install bat - Download bat-musl_0.24.0_amd64.deb from https://github.com/sharkdp/bat/releases
wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-musl_0.24.0_amd64.deb -O ~/downloads/bat-musl_0.24.0_amd64.deb
\cd downloads
sudo dpkg -i bat*_amd64.deb
rm bat*_amd64.deb

# Download exa - Download exa-linux-x86_64-v0.10.1.zip from https://github.com/ogham/exa/releases
wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip -O ~/downloads/exa-linux-x86_64-v0.10.1.zip 
\cd downloads
unzip exa-linux-*.zip
sudo cp bin/exa /bin/
rm -rf man completions bin exa-linux*

# Install wire-desktop AppImage package for Linux from https://github.com/wireapp/wire-desktop/releases
\cd downloads
sudo chmod +x Wire*.AppImage
mv Wire*.AppImage wire-desktop
mv wire-desktop /bin/
```

## Performance tweaks
```bash
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
echo "vm.swappiness=20" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_background_ratio=15" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_ratio=40" | sudo tee -a /etc/sysctl.conf
echo "vm.oom_dump_tasks=0" | sudo tee -a /etc/sysctl.conf
echo "vm.oom_kill_allocating_task=1" | sudo tee -a /etc/sysctl.conf
echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf
echo "kernel.split_lock_mitigate=0" | sudo tee /etc/sysctl.d/99-splitlock.conf
```

### Add this to `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub`:
- `zswap.compressor=zstd zswap.max_pool_percent=10 mitigations=off amd_pstate=active` then `sudo update-grub`
