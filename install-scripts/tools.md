
## Installing more tools
```bash
# Download MesloLG Nerd Font - https://www.nerdfonts.com/font-downloads
unzip ~/downloads/Meslo.zip -d Meslo
sudo cp -r ~/downloads/Meslo /usr/share/fonts/meslo
fc-cache -fv

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

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
wget https://github.com/BishopFox/sliver/releases/download/v1.5.42/sliver-server_linux
chmod +x ./sliver-server_linux
sudo mv sliver-server_linux /bin/sliver-server
wget https://github.com/BishopFox/sliver/releases/download/v1.5.42/sliver-client_linux
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
wget https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_amd64.deb -O ~/downloads/git-delta_0.17.0_amd64.deb
sudo dpkg -i ~/downloads/git-delta*.deb
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
bat cache --build    # load the theme that is located in ~/.config/bat/themes/

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
sudo mv wire-desktop /bin/
```
