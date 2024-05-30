## Installing Hyprland and dotfiles on Kali Linux
### Preparation
1. Install default latest [kali linux](https://www.kali.org/get-kali/#kali-installer-images) iso image
2. Shrink disk space for kali
3. Install kali linux
    - Graphical install
    - Domain section empty
    - Guided - Use the largest continous free space
    - All files in one partition
    - Continue
    - Keep default software selection
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
- delete the `#` on the lines with `deb-src`
4. Update source list
```bash
sudo apt update
```
5. Install timeshift
```bash
sudo apt install `timeshift`
```
6. Create system snapshot using `timeshift`
    - Choose which disk partition with kali installed on it to backup
    - User Home Directories: `Include All Files`
7. Install dependencies
```bash
sudo apt install libdrm-dev python3-pip
```
8. Install JaKooLit's dotfiles script
```bash
git clone --depth=1 https://github.com/JaKooLit/Debian-Hyprland.git
cd Debian-Hyprland
chmod +x install.sh
./install.sh
```
9. Script installation (personal preference)
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
10. Press `ctrl+alt+f2`, log in and launch `Hyprland`

### Add myself to sudoers file
```bash
sudo vim /etc/sudoers
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL

# Make sure I'm in sudoers group
cat /etc/group | rg sudo

# If I'm not, execute this command
sudo usermod -aG sudo "$(whoami)"
```

### Installing dotfiles
```bash
git clone --depth 1 https://github.com/Twilight4/dotfiles ~/
cp -r ~/dotfiles/.config ~/
rm -rf dotfiles

# Download zsh config
curl -LO https://raw.githubusercontent.com/Twilight4/arch-setup/main/config-files/kali-zsh/.zshrc
curl -LO https://raw.githubusercontent.com/Twilight4/arch-setup/main/config-files/kali-zsh/aliases.zsh

mv .zshrc ~/.config/zsh/.zshrc
mv aliases.zsh ~/.config/zsh/aliases.zsh
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

### Use aliases
- `sudo auto-cpufreq --force=performance`
- `sudo cpupower frequency-set -g performance`
  + if doesn't work: `echo power | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/performance`
- `watch fans`
- `fan-boost-on` (as root)
- `cat /sys/devices/system/cpu/amd_pstate/status - must be active`

## My setup
```bash
# Enable necessary services
./.config/.install/enable-services.sh

# Set necessary user groups
./.config/.install/set-user-groups.sh

# Install virtualization software
./.config/.install/qemu.sh

# Install wallpapers
./.config/.install/wallpaper.sh

# Clean up home dir
./.config/.install/cleanup-homedir.sh

# Other Services
./.config/.install/auto-cpufreq.sh
./.config/.install/supergfxd.conf

# Wordlists
./.config/.install/seclists.sh

# Adjustments
./.config/.install/button-layout.sh

# Locales
./.config/.install/locales.sh

# Reminder
./.config/.install/final-message.sh
```

### Configure Zsh
```bash
# Install zsh
sudo vim /etc/zsh/zshenv
#export ZDOTDIR="$HOME/.config/zsh"
chsh -s $(which zsh) $(whoami)
zsh
source ~/.config/zsh/.zshrc
```

### Install [Meslo Fonts](https://www.nerdfonts.com/font-downloads)
```bash
unzip ~/downloads/meslo
cp ~/downloads/meslo /usr/share/fonts/meslo
fc-cache -fv
```

### Remove GTK window buttons 
```bash
gsettings set org.gnome.desktop.wm.preferences button-layout ""
```

### Remove Firefox window Title bar
Right click on toolbar and click on `Customize Toolbar...` and in the bottom left uncheck `Title Bar`.

## Install tools
```bash
# Uninstall all the xfce gui bloat
sudo apt purge xfce4
apt list *xfce* --installed

# Install base packages
sudo apt install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 lsd swaybg wdisplays ripgrep silversearcher-ag irqbalance acpi emacs profile-sync-daemon dunst translate-shell duf speedtest-cli gnome-weather cpufetch fd-find trash-cli linux-cpupower mingw-w64 zathura grc poppler-utils gnome-maps wf-recorder thefuck libsecret-tools chafa
sudo apt remove python3-mako sway-notification-center fdclone

# Configure SDDM if you wanna use it
#sudo apt install sddm
#sudo systemctl enable sddm

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

# Install NVChad
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

# Install pipmykali
sudo git clone https://github.com/Dewalt-arch/pimpmykali.git /opt/pipmykali
cd /opt/pimpmykali
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

# Reinstall rust to get the newest version and install xcp
sudo apt remove rustc
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install xcp

# Install ledger (there's also emacs package)
sudo apt-get install build-essential cmake autopoint texinfo python3-dev \
     zlib1g-dev libbz2-dev libgmp3-dev gettext libmpfr-dev \
     libboost-date-time-dev libboost-filesystem-dev \
     libboost-graph-dev libboost-iostreams-dev \
     libboost-python-dev libboost-regex-dev libboost-test-dev
git clone git@github.com:ledger/ledger.git
cd ledger && ./acprep update

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
cd /tmp \
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

# Install nnn
sudo apt install libreadline-dev
git clone --depth 1 https://github.com/jarun/nnn.git
cd nnn
sudo make O_NERD=1
# or
sudo make CFLAGS+=-march=native O_NORL=1 O_NOMOUSE=1 O_NOBATCH=1 O_NOSSN=1 O_NOFIFO=1 O_QSORT=1 O_NOUG=1 O_NERD=1
cd ../
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
cd newsboat  
make
sudo make install
cd ..
sudo mv newsboat /opt/
sudo ln -sf /opt/newsboat/newsboat /bin/newsboat

# Install bat - Download bat-musl_0.24.0_amd64.deb from https://github.com/sharkdp/bat/releases
cd downloads
sudo dpkg -i bat*_amd64.deb
rm bat*_amd64.deb

# Download exa - Download exa-linux-x86_64-v0.10.1.zip from https://github.com/ogham/exa/releases
cd downloads
unzip exa-linux-*.zip
sudo cp bin/exa /bin/
rm -rf man completions bin

# Install wire-desktop AppImage package for Linux from https://github.com/wireapp/wire-desktop/releases
cd downloads
sudo chmod +x Wire*.AppImage
mv Wire*.AppImage wire-desktop
mv wire-desktop /bin/

# Install webcord_amd64.deb package from https://github.com/SpacingBat3/WebCord/releases
cd downloads
sudo dpkg -i webcord*.deb
rm webcord*.deb
```

### Optional - Install Ollama
```bash
# Install ollama
curl -fsSL https://ollama.com/install.sh | sh

# Read the options
ollama --help

# Optional: install ollama LLM models
ollama run dolphin-mixtral

# Install LLM model recommended model
ollama pull mistral:7b-instruct

# Once the model is installed, start the API server
ollama serve
```
