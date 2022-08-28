#!/bin/bash

run() {
    output=$(cat /var_output)

    log INFO "FETCH VARS FROM FILES" "$output"
    name=$(cat /tmp/var_user_name)
    url_installer=$(cat /var_url_installer)
    dry_run=$(cat /var_dry_run)

    log INFO "DOWNLOAD APPS" "$output"
    apps_path="$(download-apps "$url_installer")"
    log INFO "APPS DOWNLOADED AT: $apps_path" "$output"
    add-multilib-repo
    log INFO "MULTILIB ADDED" "$output"
    dialog-welcome
    dialog-install-apps
    update-system
    log INFO "UPDATED SYSTEM" "$output"
    dialog-install-apps "$apps" "$dry_run" "$output"
    log INFO "APPS INSTALLED" "$output"
    disable-horrible-beep
    log INFO "HORRIBLE BEEP DISABLED" "$output"
    set-user-permissions
    log INFO "USER PERMISSIONS SET" "$output"

    continue-install "$url_installer" "$name"
}

log() {
    local -r level=${1:?}
    local -r message=${2:?}
    local -r output=${3:?}
    local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo -e "${timestamp} [${level}] ${message}" >>"$output"
}

download-apps() {
    local -r url_installer=${1:?}

    apps_path1="/tmp/paclist" 
    apps_path2="/tmp/yaylist"
    curl "$url_installer/paclist" > "$apps_path1"
    curl "$url_installer/yaylist" > "$apps_path2"

    echo $apps_path1
    echo $apps_path2
}

# Add multilib repo
add-multilib-repo() {
    echo "[multilib]" >> /etc/pacman.conf && echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
}

dialog-welcome() {
    dialog --title "Welcome!" --msgbox "Welcome to Twilight4s dotfiles and software installation script for Arch linux.\n" 10 60
}

dialog-install-apps() {
    dialog --title "Lesgoo" --msgbox \
    "The system will now install everything you need.\n\n\
    It will take some time.\n\n " 13 60
}

dialog-install-apps() {
    local file=${1:?}
    sudo pacman -S --noconfirm $(cat paclist)
    yay -S --noconfirm $(cat yaylist)
}

update-system() {
    pacman -Syu --noconfirm
}

            if [ "$fixit" = "networkmanager" ]; then
                # Enable the systemd service NetworkManager.
                systemctl enable NetworkManager.service
            fi

            if [ "$fixit" = "zsh" ]; then
                # zsh as default terminal for user
                chsh -s "$(which zsh)" "$name"
            fi

            if [ "$fixit" = "docker" ]; then
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

continue-install() {
    local -r url_installer=${1:?}
    local -r name=${2:?}

    curl "$url_installer/install_user.sh" > /tmp/install_user.sh;

    if [ "$dry_run" = false ]; then
        # Change user and begin the install use script
        sudo -u "$name" bash /tmp/install_user.sh
    fi
}

set-user-permissions() {
    dialog --infobox "Copy user permissions configuration (sudoers)..." 4 40
    curl "$url_installer/sudoers" > /etc/sudoers
}

disable-horrible-beep() {
    rmmod pcspkr
    echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
}

run "$@"
