#!/bin/bash

run() {
    output=$(cat /var_output)

    log INFO "FETCH VARS FROM FILES" "$output"
    name=$(cat /tmp/var_user_name)
    url_installer=$(cat /var_url_installer)
    dry_run=$(cat /var_dry_run)
    
    log INFO "DOWNLOAD PACLIST" "$output"
    paclist_path="$(download-paclist "$url_installer")"
    log INFO "PACLIST DOWNLOADED AT: $paclist_path" "$output"
    yaylist_path="$(download-yaylist "$url_installer")"
    log INFO "YAYLIST DOWNLOADED AT: $yaylist_path" "$output"
    #add-multilib-repo
    #log INFO "MULTILIB ADDED" "$output"
    disable-horrible-beep
    log INFO "HORRIBLE BEEP DISABLED" "$output"
    dialog-welcome
    update-system
    log INFO "UPDATED SYSTEM" "$output"
    install-yay "$output"
    log INFO "YAY INSTALLED" "$output"
    dialog-install-apps "$apps" "$dry_run" "$output"
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

dialog-welcome() {
    dialog --title "Welcome!" --msgbox "Welcome to Twilight4s dotfiles and software installation script for Arch linux.\n" 10 60
}

update-system() {
    pacman -Syu --noconfirm
}

dialog-install-apps() {
    dialog --title "Lesgoo" --msgbox \
    "The system will now install everything you need.\n\n\
    It will take some time.\n\n " 13 60
}

install-yay() {
    local -r output=${1:?}

    dialog --infobox "[$(whoami)] Installing \"yay\", an AUR helper..." 10 60
    curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
    && tar -xvf "yay.tar.gz" \
    && cd "yay" \
    && makepkg --noconfirm -si \
    && cd - \
    && rm -rf "yay" "yay.tar.gz" ;
}

dialog-install-apps() {
    
    sudo pacman -S --noconfirm $(cat paclist)
    yay -S --noconfirm $(cat yaylist)
    
    count=$(echo "$paclist" | wc -l)

    c=0
    echo "$paclist" | while read -r line; do
        c=$(( "$c" + 1 ))
        
            # Needed if system installed in VBox
            if [ "$line" = "virtualbox-guest-utils" ]; then
                systemctl enable vboxservice.service
            fi
            
            if [ "$line" = "networkmanager" ]; then
                # Enable the systemd service NetworkManager.
                systemctl enable NetworkManager.service
            fi

            if [ "$line" = "zsh" ]; then
                # zsh as default terminal for user
                chsh -s "$(which zsh)" "$name"
            fi

            if [ "$line" = "docker" ]; then
                groupadd docker
                gpasswd -a "$name" docker
                systemctl enable docker.service
            fi
        else
            fake_install "$fixit"
        fi
    done
}

fake-install() {
    echo "$1 fakely installed!" >> "$output"
}

create-directories() {
#    mkdir -p "/home/$(whoami)/{Document,Download,Video,workspace,Music}"
mkdir -p "/opt/github/essentials"
mkdir -p "/opt/{wallpapers}"
mkdir -p "/usr/share/fonts/{MesloLGS-NF}"
}

install-dotfiles() {
    DOTFILES="/home/$(whoami)/"
    if [ ! -d "$DOTFILES" ];
        then
            dialog --infobox "[$(whoami)] Downloading dotfiles..." 10 60
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    echo 'export ZDOTDIR="$HOME"/.config/zsh' >> /etc/zsh/zshenv
    source "/home/$(whoami)/.dotfiles/zsh/.zshenv"
    mv "$DOTFILES/fonts/MesloLGS-NF/*" /usr/share/fonts/MesloLGS-NF
    mv "$DOTFILES/wallpapers/*" /opt/wallpapers
    rm -rf "$DOTFILES"
    
    rm ~/.bash*
    rm -rf /usr/share/fonts/[71aceT]*
    chmod 755 "$XDG_CONFIG_HOME/qtile/autostart.sh"
    chmod 755 "$XDG_CONFIG_HOME/polybar/launch.sh"
    chmod 755 "$XDG_CONFIG_HOME/polybar/polybar-scripts/*"
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
