#!/usr/bin/env bash

run() {
    paclist_path
    yaylist_path
    install-yay
    install-apps
    set-user-permissions
    install-dotfiles
    install-ghapps
}

download-paclist() {
url-installer = "https://raw.githubusercontent.com/Twilight4/arch-install/master"
    paclist_path="/tmp/paclist" 
    curl "$url-installer/paclist" > "$paclist_path"

    echo $paclist_path
}

download-yaylist() {
url-installer = "https://raw.githubusercontent.com/Twilight4/arch-install/master"   
    yaylist_path="/tmp/yaylist"
    curl "$url-installer/yaylist" > "$yaylist_path"

    echo $yaylist_path
}

install-yay() {
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
    chsh -s "$(which zsh)" "$name"
            
    ## For Docker
    #groupadd docker
    #gpasswd -a "$name" docker
    #systemctl enable docker.service
}

create-directories() {
#mkdir -p "/home/$(whoami)/{Document,Download,Video,workspace,Music}"
mkdir -p "/opt/github/essentials"
mkdir -p "/opt/wallpapers"
mkdir -p "/usr/share/fonts/MesloLGS-NF"
mkdir -p "/usr/share/fonts/rofi-fonts"
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ];
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    mv "/tmp/dotfiles/.config/*" /home/$(whoami)/
    echo 'export ZDOTDIR="$HOME"/.config/zsh' >> /etc/zsh/zshenv
    source "/home/$(whoami)/.config/zsh/.zshenv"
    mv "/tmp/dotfiles/fonts/MesloLGS-NF/*" /usr/share/fonts/MesloLGS-NF
    mv "/tmp/dotfiles/fonts/rofi-fonts/*" /usr/share/fonts/rofi-fonts
    mv "/tmp/dotfiles/wallpapers/*" /opt/wallpapers
    rm ~/.bash*
    rm -rf /usr/share/fonts/[71aceT]*
    chmod 755 "$XDG_CONFIG_HOME/qtile/autostart.sh"
    chmod 755 "$XDG_CONFIG_HOME/polybar/launch.sh"
    chmod 755 "$XDG_CONFIG_HOME/polybar/polybar-scripts/*"
    chmod 755 "$XDG_CONFIG_HOME/rofi/applets/bin/*"
    chmod 755 "$XDG_CONFIG_HOME/rofi/applets/shared/theme.bash"
    chmod 755 "$XDG_CONFIG_HOME/rofi/launchers/launcher.sh"
    mv "/home/$(whoami)/.config/rofi/applets/bin/*" /usr/bin/
    mv "$ZDOTDIR/zsh-completions.plugin.zsh" "$ZDOTDIR/_zsh-completions.plugin.zsh"
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
&& --depth=1 https://github.com/romkatv/powerlevel10k.git \
"/opt/powerlevel10k"

# XDG ninja
[ ! -d "/home/$(whoami)/xdg-ninja" ] \
&& git clone https://github.com/b3nj5m1n/xdg-ninja \
"/home/$(whoami)/xdg-ninja"

# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

# neovim plugin manager
[ ! -d "$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ] \
&& git clone https://github.com/wbthomason/packer.nvim \
"$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
}

echo 'reminders for myself:
- add ssh pub key to github
'

run "$@"

reboot
