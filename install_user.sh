#!/usr/bin/env bash

run() {
    update-system
    download-paclist
    download-parulist
    install-paru
    install-apps
    create-directories
    install-dotfiles
    install-ghapps
}

update-system() {
    sudo pacman -Syu --noconfirm
}

download-paclist() {
    paclist_path="/tmp/paclist-bspwm" 
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/paclist-bspwm" > "$paclist_path"

    echo $paclist_path
}

download-parulist() {
    parulist_path="/tmp/parulist"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/parulist" > "$parulist_path"

    echo $parulist_path
}

install-paru() {
    sudo pacman -S --noconfirm git
    git clone https://aur.archlinux.org/paru-bin \
    && cd paru-bin \
    && makepkg --noconfirm -si \
    && cd - \
    && rm -rf paru-bin
}

install-apps() {
    sudo pacman -S --noconfirm $(cat /tmp/paclist-bspwm)
    git clone https://github.com/baskerville/bspwm.git
    git clone https://github.com/baskerville/sxhkd.git
    cd bspwm && make && sudo make install
    cd -
    cd sxhkd && make && sudo make install
    cd -
    rm -rf bspwm sxhkd
    paru -S --noconfirm $(cat /tmp/parulist)
        
    # Needed if system installed in VBox
    sudo systemctl enable vboxservice.service
    
    # zsh as default terminal for user
    sudo chsh -s "$(which zsh)" "$(whoami)"
      
    ## For Docker
    #groupadd docker
    #gpasswd -a "$name" docker
    #sudo systemctl enable docker.service
}

create-directories() {
#sudo mkdir -p "/home/$(whoami)/{Document,Download,Video,workspace,Music}"
mkdir /home/$(whoami)/.config
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ]
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    sudo mv -u /tmp/dotfiles/.config/* "$HOME/.config"
    source "/home/$(whoami)/.config/zsh/.zshenv"
    sudo rm -rf /usr/share/fonts/encodings
    sudo rm -rf /usr/share/fonts/adobe-source-code-pro
    sudo rm -rf /usr/share/fonts/cantarell
    sudo rm -rf /usr/share/fonts/gnu-free
    sudo rm -rf /home/$(whoami)/.config/qtile
    sudo mv /tmp/dotfiles/fonts/MesloLGM-NF/ /usr/share/fonts/
    sudo mv /tmp/dotfiles/fonts/rofi-fonts/ /usr/share/fonts/
    sudo fc-cache -f
    sudo mv /tmp/dotfiles/wallpapers/ /usr/share/
    sudo rm /home/$(whoami)/.bash*
    sudo chmod 755 $XDG_CONFIG_HOME/bspwm/bspwmrc
    sudo chmod 755 $XDG_CONFIG_HOME/polybar/launch.sh
    sudo chmod 755 $HOME/.config/polybar/polybar-scripts/*
    sudo chmod 755 $HOME/.config/rofi/applets/bin/*
    sudo chmod 755 $XDG_CONFIG_HOME/rofi/applets/shared/theme.bash
    sudo chmod 755 $XDG_CONFIG_HOME/rofi/launcher/launcher.sh
    sudo chmod 755 $XDG_CONFIG_HOME/zsh/scripts/*
    sudo mv $HOME/.config/rofi/applets/bin/* /usr/bin/
    sudo mv $HOME/.config/rofi/launcher/launcher.sh /usr/bin/
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global user.email "electrolight071@gmail.com"
    git config --global user.name "Twilight4"
}

install-ghapps() {
    GHAPPS="/opt/github/essentials"
    if [ ! -d "$GHAPPS" ]
        then
        sudo mkdir -p $GHAPPS &&
        sudo git clone "https://github.com/shlomif/lynx-browser"
        sudo git clone "https://github.com/chubin/cheat.sh"
        sudo git clone "https://github.com/smallhadroncollider/taskell"
        sudo git clone "https://github.com/Swordfish90/cool-retro-term"
    fi
    
# XDG ninja
[ ! -d "$HOME/xdg-ninja" ] \
&& git clone https://github.com/b3nj5m1n/xdg-ninja \
"$HOME/xdg-ninja"

# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

echo 'Post-Installation:
- NOW DO THIS COMMAND AS ROOT: echo 'export ZDOTDIR="$HOME"/.config/zsh' > /etc/zsh/zshenv and then reboot
- sshcreate <name> - Add pub key to github: Settings > SSH > New
- reload tpm: ctrl + a + shift + i and hit q
'
}

run "$@"
