#!/usr/bin/env bash

run() {
    download-paclist
    download-yaylist
    install-yay
    install-apps
    create-directories
    install-dotfiles
    install-ghapps
}

download-paclist() {
    paclist_path="/tmp/paclist" 
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/paclist" > "$paclist_path"

    echo $paclist_path
}

download-yaylist() {
    yaylist_path="/tmp/yaylist"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/yaylist" > "$yaylist_path"

    echo $yaylist_path
}

install-yay() {
    pacman -Sy
    pacman -S --noconfirm tar
    curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
    && tar -xvf "yay.tar.gz" \
    && cd "yay" \
    && makepkg --noconfirm -si \
    && cd - \
    && rm -rf "yay" "yay.tar.gz" ;
}

install-apps() {
    pacman -S --noconfirm $(cat /tmp/paclist)
    yay -S --noconfirm $(cat /tmp/yaylist)
        
    # Needed if system installed in VBox
    systemctl enable vboxservice.service
    
    # zsh as default terminal for user
    chsh -s "$(which zsh)" "twilight"
    
    # Needed if system installed in VMWare
    if [ "$(cat /tmp/paclist)" = "xf86-video-vmware" ]; then
        systemctl enable vmtoolsd.service
        systemctl enable vmware-vmblock-fuse.service
    fi
            
    ## For Docker
    #groupadd docker
    #gpasswd -a "$name" docker
    #systemctl enable docker.service
}

create-directories() {
#mkdir -p "/home/$(whoami)/{Document,Download,Video,workspace,Music}"
mkdir -p "/opt/github/essentials"
mkdir -p "/opt/wallpapers"
mkdir -p "/usr/share/fonts/MesloLGM-NF"
mkdir -p "/usr/share/fonts/rofi-fonts"
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ];
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    mv "/tmp/dotfiles/.config" /home/twilight/
    echo 'export ZDOTDIR="$HOME"/.config/zsh' >> /etc/zsh/zshenv
    source "/home/twilight/.config/zsh/.zshenv"
    rm -rf /usr/share/fonts/[71aceT]*
    mv /tmp/dotfiles/fonts/MesloLGM-NF/* /usr/share/fonts/MesloLGM-NF/
    mv /tmp/dotfiles/fonts/rofi-fonts/* /usr/share/fonts/rofi-fonts/
    mv /tmp/dotfiles/wallpapers/* /opt/wallpapers
    rm /home/twilight/.bash*
    chmod 755 /home/twilight/.config/qtile/autostart.sh
    chmod 755 /home/twilight/.config/polybar/launch.sh
    chmod 755 /home/twilight/.config/polybar/polybar-scripts/*
    chmod 755 /home/twilight/.config/rofi/applets/bin/*
    chmod 755 /home/twilight/.config/rofi/applets/shared/theme.bash
    chmod 755 /home/twilight/.config/rofi/launchers/launcher.sh
    mv /home/twilight/.config/rofi/applets/bin/* /usr/bin/
    mv /home/twilight/.config/zsh/zsh-completions.plugin.zsh home/twilight/.config/zsh/_zsh-completions.plugin.zsh
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global user.email "electrolight071@gmail.com"
    git config --global user.name "Twilight4"
}

install-ghapps() {
    GHAPPS="/opt/github/essentials"
    if [ ! -d "$GHAPPS" ];
        then
            dialog --infobox "[$(whoami)] Downloading github apps..." 10 60
            git clone "https://github.com/shlomif/lynx-browser"
            git clone "https://github.com/chubin/cheat.sh"
            git clone "https://github.com/smallhadroncollider/taskell"
            git clone "https://github.com/christoomey/vim-tmux-navigator"
            git clone "https://github.com/Swordfish90/cool-retro-term"
    fi

# powerlevel10k
[ ! -d "/opt/powerlevel10k" ] \
&& git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
"/opt/powerlevel10k"

# XDG ninja
[ ! -d "/home/$(whoami)/xdg-ninja" ] \
&& git clone https://github.com/b3nj5m1n/xdg-ninja \
"/home/twilight/xdg-ninja"

# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"/home/twilight/.config/tmux/plugins/tpm"

# neovim plugin manager
[ ! -d "$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ] \
&& git clone https://github.com/wbthomason/packer.nvim \
"/home/twilight/.config/.local/share/nvim/site/pack/packer/start/packer.nvim"
}

echo 'reminders for myself:
- add ssh pub key to github
'

#reboot
run "$@"
