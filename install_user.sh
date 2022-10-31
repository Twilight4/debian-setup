#!/usr/bin/env bash

run() {
    disable-horrible-beep
    update-system
    download-paclist
    download-parulist
    install-paru
    install-apps
    create-directories
    install-dotfiles
    install-ghapps
}

disable-horrible-beep() {
    sudo rmmod pcspkr
    sudo echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
}

update-system() {
    pacman -Syu --noconfirm
}

download-paclist() {
    paclist_path="/tmp/paclist" 
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/paclist" > "$paclist_path"

    echo $paclist_path
}

download-parulist() {
    parulist_path="/tmp/parulist"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/parulist" > "$parulist_path"

    echo $parulist_path
}

install-paru() {
    sudo pacman -Sy
    curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/paru.tar.gz" \
    && tar -xvf "yay.tar.gz" \
    && cd "yay" \
    && makepkg --noconfirm -si \
    && cd - \
    && rm -rf "yay" "yay.tar.gz" ;
}

install-apps() {
    sudo pacman -S --noconfirm $(cat /tmp/paclist)
    paru -S --noconfirm $(cat /tmp/yaylist)
        
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
sudo mkdir -p "/opt/github/essentials"
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ];
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    sudo mv -u /tmp/dotfiles/.config/* "$HOME/.config"
    source "/home/$(whoami)/.config/zsh/.zshenv"
    sudo rm -rf /usr/share/fonts/[71acegT]*
    sudo mv /tmp/dotfiles/fonts/MesloLGM-NF/ /usr/share/fonts/
    sudo mv /tmp/dotfiles/fonts/rofi-fonts/ /usr/share/fonts/
    sudo mv /tmp/dotfiles/wallpapers/* /usr/share/wallpapers/
    sudo rm /home/$(whoami)/.bash*
    sudo chmod 755 $XDG_CONFIG_HOME/qtile/autostart.sh
    sudo chmod 755 $XDG_CONFIG_HOME/polybar/launch.sh
    sudo chmod 755 $HOME/.config/polybar/polybar-scripts/*
    sudo chmod 755 $HOME/.config/rofi/applets/bin/*
    sudo chmod 755 $XDG_CONFIG_HOME/rofi/applets/shared/theme.bash
    sudo chmod 755 $XDG_CONFIG_HOME/rofi/launcher/launcher.sh
    sudo mv $HOME/.config/rofi/applets/bin/* /usr/bin/
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global user.email "electrolight071@gmail.com"
    git config --global user.name "Twilight4"
}

install-ghapps() {
    GHAPPS="/opt/github/essentials"
    if [ ! -d "$GHAPPS" ];
        then
            sudo git clone "https://github.com/shlomif/lynx-browser"
            sudo git clone "https://github.com/chubin/cheat.sh"
            sudo git clone "https://github.com/smallhadroncollider/taskell"
            sudo git clone "https://github.com/christoomey/vim-tmux-navigator"
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

#continue-install() {
#    local -r url_installer=${1:?}
#    local -r name=${2:?}

#    curl "$url_installer/install_user.sh" > /tmp/install_user.sh;

#    if [ "$dry_run" = false ]; then
        # Change user and begin the install use script
#        sudo -u "$name" bash /tmp/install_user.sh
#    fi
#}

echo 'Post-Installation:
- once plugins gets installed for zsh type a command: mv $HOME/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh $HOME/.config/zsh/plugins/zsh-completions/_zsh-completions.plugin.zsh
- add ssh pub key to github
- rm conflicted files in qtile dir
'

/bin/echo -e "\e[1:32mREBOOTING IN 5..4..3..2..1..\e[0n"
sleep 5
#sudo reboot
}

run "$@"
