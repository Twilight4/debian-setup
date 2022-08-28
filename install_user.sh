#!/bin/bash

run() {
    output="/home/$(whoami)/install_log"
    cd /tmp

    log INFO "FETCH VARS FROM FILES" "$output"
    #log INFO "CREATE DIRECTORIES" "$output"
    #create-directories
    log INFO "INSTALL YAY" "$output"
    install-yay "$output"
    log INFO "INSTALL DOTFILES" "$output"
    install-dotfiles
}

log() {
    local -r level=${1:?}
    local -r message=${2:?}
    local -r output=${3:?}
    local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo -e "${timestamp} [${level}] ${message}" >>"$output"
}

#create-directories() {
#    mkdir -p "/home/$(whoami)/{Document,Download,Video,workspace,Music}"
#}

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

install-dotfiles() {
    DOTFILES="/home/$(whoami)/"
    if [ ! -d "$DOTFILES" ];
        then
            dialog --infobox "[$(whoami)] Downloading dotfiles..." 10 60
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
}

run "$@"





# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

# neovim plugin manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.config/.local/share/nvim/site/pack/packer/start/packer.nvim
