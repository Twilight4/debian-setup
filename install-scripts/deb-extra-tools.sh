#!/bin/bash

##########################
# BASH INSTALLER SCRIPTS #
##########################
# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install xh
curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh

# Install xcp
cargo install xcp
sudo cp ~/.config/.local/share/cargo/bin/xcp /bin/

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
# Use ~/.fzf/uninstall script to remove/reinstall fzf.


##########################
# FLATPAK APPS           #
##########################
# Install GNOME authenticator from Flathub: https://flathub.org/apps/com.belmoussaoui.Authenticator
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.belmoussaoui.Authenticator

# Install Brave Browser
flatpak install flathub com.brave.Browser

############################
# INSTALLING FROM RELEASES #
############################
mkdir -p ~/downloads/cli-tools

# Install neovim: https://github.com/neovim/neovim
cd ~/downloads/cli-tools \
  && sudo apt install ninja-build gettext cmake unzip curl \
  && git clone https://github.com/neovim/neovim \
  && cd neovim \
  && git checkout stable \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo \
  && cd build \
  && cpack -G DEB \
  && sudo dpkg -i nvim-linux64.deb

# Install NVChad
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

# Install moar: https://github.com/walles/moar/releases/tag/v1.24.3
cd ~/downloads/cli-tools \
  && wget https://github.com/walles/moar/releases/download/v1.24.3/moar-v1.24.3-linux-amd64 \
  && chmod +x moar-v1.24.3-linux-amd64 \
  && sudo mv moar-v1.24.3-linux-amd64 /bin/moar

# Install cheat: https://github.com/cheat/cheat/blob/master/INSTALLING.md
cd ~/download/cli-tools \
  && wget https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz \
  && gunzip cheat-linux-amd64.gz \
  && chmod +x cheat-linux-amd64 \
  && sudo mv cheat-linux-amd64 /bin/cheat

# Install wire-desktop AppImage package for Linux: https://github.com/wireapp/wire-desktop/releases
cd ~/download/cli-tools \
  && wget https://github.com/wireapp/wire-desktop/releases/download/linux%2F3.35.3348/Wire-3.35.3348_x86_64.AppImage \
  && sudo chmod +x Wire-3.35.3348_x86_64.AppImage \
  && mv Wire-3.35.3348_x86_64.AppImage wire-desktop \
  && sudo mv wire-desktop /bin/

# Download exa: https://github.com/ogham/exa/releases
cd ~/download/cli-tools \
  && wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip \
  && unzip exa-linux-x86_64-v0.10.1.zip \
  && sudo cp bin/exa /bin/

# Download bat: https://github.com/sharkdp/bat/releases
cd ~/download/cli-tools \
  && wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-musl_0.24.0_amd64.deb \
  && sudo dpkg -i bat-musl_0.24.0_amd64.deb \
  && \bat cache --build    # load the theme that is located in ~/.config/bat/themes/

# Install delta: https://github.com/dandavison/delta/releases
cd ~/download/cli-tools \ 
  && wget https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_amd64.deb -O ~/downloads/git-delta_0.17.0_amd64.deb \
  && sudo dpkg -i git-delta_0.17.0_amd64.deb \

# Install freetube:  https://github.com/FreeTubeApp/FreeTube/releases
cd ~/download/cli-tools \
  && wget https://github.com/FreeTubeApp/FreeTube/releases/download/v0.20.0-beta/freetube_0.20.0_amd64.deb \
  && sudo dpkg -i freetube_0.20.0_amd64.deb \

# Install sliver's pre-compiled versions of the server and client: https://github.com/BishopFox/sliver/releases/tag/v1.5.42
# Sliver server
wget https://github.com/BishopFox/sliver/releases/download/v1.5.42/sliver-server_linux \
  && sudo chmod +x ./sliver-server_linux \
  && sudo mv sliver-server_linux /bin/sliver-server
# Sliver client
wget https://github.com/BishopFox/sliver/releases/download/v1.5.42/sliver-client_linux \
  && sudo chmod +x ./sliver-client_linux \
  && sudo mv sliver-client_linux /bin/sliver-client

# Install pvpn beta linux app: https://protonvpn.com/support/official-linux-vpn-debian/
cd ~/download/cli-tools \
  && wget https://repo.protonvpn.com/debian/dists/unstable/main/binary-all/protonvpn-beta-release_1.0.3-3_all.deb \
  && sudo dpkg -i ./protonvpn-beta-release_1.0.3-3_all.deb \
  && sudo apt update \
  && sudo apt install proton-vpn-gnome-desktop


###############
# OTHER TOOLS #
###############
# Install dog: https://github.com/ogham/dog
cd ~/download/cli-tools \
  && curl -LO https://github.com/ogham/dog/releases/download/v0.1.0/dog-v0.1.0-x86_64-unknown-linux-gnu.zip \
  && unzip dog-v0.1.0-x86_64-unknown-linux-gnu.zip \
  && sudo cp dog-v0.1.0-x86_64-unknown-linux-gnu/bin/dog /bin \
# Fix a problem: error while loading shared libraries: libssl.so.1.1: cannot open shared object file: No such file or directory
#wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb
#sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb

# Install ledger (there's also emacs package)
#sudo apt-get install build-essential cmake autopoint texinfo python3-dev \
#     zlib1g-dev libbz2-dev libgmp3-dev gettext libmpfr-dev \
#     libboost-date-time-dev libboost-filesystem-dev \
#     libboost-graph-dev libboost-iostreams-dev \
#     libboost-python-dev libboost-regex-dev libboost-test-dev
#git clone git@github.com:ledger/ledger.git
#cd ledger && ./acprep update

# Install newsboat: https://github.com/newsboat/newsboat
#cd /opt \
#  && sudo apt update \
#  && sudo apt install libncursesw5-dev ncurses-term debhelper libxml2-dev libstfl-dev libsqlite3-dev perl pkg-config libcurl4-gnutls-dev librtmp-dev libjson-c-dev asciidoc libxml2-utils xsltproc docbook-xml docbook-xsl bc asciidoctor cargo \
#  && git clone --depth 1 https://github.com/newsboat/newsboat.git \
#  && cd newsboat \
#  && make \
#  && sudo make install \
#  && cd .. \
#  && sudo ln -sf /opt/newsboat/newsboat /bin/newsboat

# Install pipmykali
cd ~/downloads/cli-tools \
  && git clone https://github.com/Dewalt-arch/pimpmykali.git \
  && sudo mv pimpmykali /opt
  #cd /opt/pimpmykali
  #sudo ./pipmykali.sh       # Choose option: 0, =, @
