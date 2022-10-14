#!/bin/bash

run() {
    output=$(cat /var_output)

    log INFO "FETCH VARS FROM FILES" "$output"
    name=$(cat /tmp/var_user_name)
    url_installer=$(cat /var_url_installer)
    dry_run=$(cat /var_dry_run)
    
    paclist_path="$(download-paclist "$url_installer")"
    log INFO "PACLIST DOWNLOADED AT: $paclist_path" "$output"
    yaylist_path="$(download-yaylist "$url_installer")"
    log INFO "YAYLIST DOWNLOADED AT: $yaylist_path" "$output"
    #add-multilib-repo
    #log INFO "MULTILIB ADDED" "$output"
    disable-horrible-beep
    log INFO "HORRIBLE BEEP DISABLED" "$output"
    update-system
    log INFO "UPDATED SYSTEM" "$output"
    install-yay "$output"
    log INFO "YAY INSTALLED" "$output"
    install-apps "$apps" "$dry_run" "$output"
    log INFO "APPS INSTALLED" "$output"
    set-user-permissions
    log INFO "USER PERMISSIONS SET" "$output"
    set-pacman-config
    log INFO "PACMAN CONFIG SET" "$output"
    create-directories
    log INFO "DIRECTORIES CREATED" "$output"
    install-dotfiles
    log INFO "DOTFILES INSTALLED" "$output"
    install-ghapps
    log INFO "GITHUB APPS INSTALLED" "$output"
    #continue-install "$url_installer" "$name"
}

log() {
    local -r level=${1:?}
    local -r message=${2:?}
    local -r output=${3:?}
    local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo -e "${timestamp} [${level}] ${message}" >>"$output"
}

download-paclist() {
    local -r url_installer=${1:?}

    paclist_path="/tmp/paclist" 
    curl "$url_installer/paclist" > "$paclist_path"

    echo $paclist_path
}

download-yaylist() {
    local -r url_installer=${1:?}
    
    yaylist_path="/tmp/yaylist"
    curl "$url_installer/yaylist" > "$yaylist_path"

    echo $yaylist_path
}

#add-multilib-repo() {
#    echo "[multilib]" >> /etc/pacman.conf && echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
#}

disable-horrible-beep() {
    rmmod pcspkr
    echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
}

update-system() {
    pacman -Syu --noconfirm
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
            
    # Enable the systemd service NetworkManager.
    systemctl enable NetworkManager.service

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
    DOTFILES="/tmp/"
    if [ ! -d "$DOTFILES" ];
        then
            dialog --infobox "[$(whoami)] Downloading dotfiles..." 10 60
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    echo 'export ZDOTDIR="$HOME"/.config/zsh' >> /etc/zsh/zshenv
    mv "/tmp/dotfiles/.config/*" /home/$(whoami)/
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
    mv "/tmp/dotfiles/rofi/applets/bin/*" /usr/bin/
    mv "$ZDOTDIR/zsh-completions.plugin.zsh" "$ZDOTDIR/_zsh-completions.plugin.zsh"
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global user.email "electrolight071@gmail.com"
    git config --global user.name "Twilight4"
}

set-user-permissions() {
    dialog --infobox "Copy user permissions configuration (sudoers)..." 4 40
    curl "$url_installer/sudoers" > /etc/sudoers
}

set-pacman-config() {
    dialog --infobox "Copy pacman configuration file (pacman.conf)..." 4 40
    curl "$url_installer/pacman.conf" > /etc/pacman.conf
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
[ ! -d "$HOME" ] \
&& git clone https://github.com/b3nj5m1n/xdg-ninja \
"$HOME"

# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

# neovim plugin manager
[ ! -d "$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ] \
&& git clone https://github.com/wbthomason/packer.nvim \
"$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
}

 #continue-install() {
#    local -r url_installer=${1:?}
#    local -r name=${2:?}

#    curl "$url_installer/install_user.sh" > /tmp/install_user.sh;

#    if [ "$dry_run" = false ]; then
        # Change user and begin the install use script
#        sudo -u "$name" bash /tmp/install_user.sh
#    fi
#}

echo 'reminders for myself:
- add ssh pub key to github
'

run "$@"
