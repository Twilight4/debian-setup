#!/bin/bash

run() {
    output=$(cat /var_output)

    log INFO "FETCH VARS FROM FILES" "$output"
    name=$(cat /tmp/var_user_name)
    url_installer=$(cat /var_url_installer)
    dry_run=$(cat /var_dry_run)
    disable-horrible-beep
    log INFO "HORRIBLE BEEP DISABLED" "$output"
    update-system
    log INFO "UPDATED SYSTEM" "$output"
    set-user-permissions
    log INFO "USER PERMISSIONS SET" "$output"
    install-network-manager "$dry_run" "$output"
    log INFO "NETWORK MANAGER SET" "$output"
    set-pacman-config
    log INFO "PACMAN CONFIG SET" "$output"
    #continue-install "$url_installer" "$name"
}

log() {
    local -r level=${1:?}
    local -r message=${2:?}
    local -r output=${3:?}
    local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo -e "${timestamp} [${level}] ${message}" >>"$output"
}

disable-horrible-beep() {
    rmmod pcspkr
    echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
}

update-system() {
    pacman -Syu --noconfirm
}

set-user-permissions() {
    dialog --infobox "Copy user permissions configuration (sudoers)..." 4 40
    curl "$url_installer/sudoers" > /etc/sudoers
}

install-network-manager() {
pacman -S --noconfirm networkmanager

# Enable the systemd service NetworkManager.
systemctl enable NetworkManager.service
}

set-pacman-config() {
    dialog --infobox "Copy pacman configuration file (pacman.conf)..." 4 40
    curl "$url_installer/pacman.conf" > /etc/pacman.conf
    curl "$url_installer/install.sh" > /home/twilight/install.sh
    echo 'export ZDOTDIR="$HOME"/.config/zsh' > /etc/zsh/.zshenv
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

run "$@"
