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

### My Setup
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
# Install base packages
sudo apt install lsd fzf wdisplays ripgrep silversearcher-ag irqbalance acpi emacs profile-sync-daemon sddm dunst translate-shell duf speedtest-cli gnome-weather cpufetch fd-find
sudo apt remove python3-mako sway-notification-center fdclone

# Enable SDDM
sudo systemctl enable sddm

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

# Install NVChad
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

# Install cheat - check for newest version: https://github.com/cheat/cheat/blob/master/INSTALLING.md
cd /tmp \
  && wget https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz \
  && gunzip cheat-linux-amd64.gz \
  && chmod +x cheat-linux-amd64 \
  && sudo mv cheat-linux-amd64 /bin/cheat

# Install Floorp Browser
curl -fsSL https://ppa.ablaze.one/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
sudo apt update
sudo apt install floorp

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

# Install diff-so-fancy
git clone https://github.com/so-fancy/diff-so-fancy diffsofancy
chmod +x diffsofancy/diff-so-fancy
sudo mv diffsofancy /opt
sudo ln -s ~/opt/diffsofancy/diff-so-fancy /usr/local/bin/diff-so-fancy

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
```

## Install [ShellGPT](https://github.com/TheR1D/shell_gpt/)
```bash
pip install shell-gpt
```

### Install Ollama
```bash
curl -fsSL https://ollama.com/install.sh | sh

# Read the options
ollama --help
```
Optional: install ollama LLM models
```bash
ollama run llama2
# OR
ollama run dolphin-mixtral
```

### ShellGPT setup
Install LLM model recommended for ShellGPT
```bash
ollama pull mistral:7b-instruct
```
Once the model is installed, start the API server
```bash
ollama serve
```

### ShellGPT configuration
Now when we have Ollama backend running we need to configure ShellGPT to use it. 
To communicate with local LLM backends, ShellGPT utilizes LiteLLM. To install it run:
```bash
pip install shell-gpt[litellm]
```

Check if Ollama backend is running and accessible:
```bash
sgpt --model ollama/mistral:7b-instruct  "Who are you?"
# -> I'm ShellGPT, your OS and shell assistant...
```
If you are running ShellGPT for the first time, you will be prompted for OpenAI API key. Provide any random string to skip this step (do not just press enter with empty input). If you got an error you can ask ShellGPT [community](https://github.com/TheR1D/shell_gpt/discussions) for help.

Now we need to change few settings in `~/.config/shell_gpt/.sgptrc`:
  - change `DEFAULT_MODE` to `ollama/mistral:7b-instruct`
  - `OPENAI_USE_FUNCTIONS` is set to `false`
  - `USE_LITELLM` is set to `true`. 

That's it, now you can use ShellGPT with Ollama backend.
