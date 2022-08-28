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
    dialog-install-apps ch
    choices=$(cat ch) && rm ch
    log INFO "APP CHOOSEN: $choices" "$output"
    lines="$(extract-choosed-apps "$choices" "$apps_path")"
    log INFO "GENERATED LINES: $lines" "$output"
    apps="$(extract-app-names "$lines")"
    log INFO "APPS: $apps" "$output"
    update-system
    log INFO "UPDATED SYSTEM" "$output"
    delete-previous-aur-queue
    log INFO "DELETED PREVIOUS AUR QUEUE" "$output"
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

    apps_path="/tmp/paclist"
    curl "$url_installer/paclist" > "$apps_path"

    echo $apps_path
}

# Add multilib repo
add-multilib-repo() {
    echo "[multilib]" >> /etc/pacman.conf && echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
}

dialog-welcome() {
    dialog --title "Welcome!" --msgbox "Welcome to Twilight4s dotfiles and software installation script for Arch linux.\n" 10 60
}

dialog-install-apps() {
    local file=${1:?}
    sudo pacman -S $(cat paclist)
    yay -S $(cat yaylist)
}

extract-choosed-apps() {
    local -r choices=${1:?}
    local -r apps_path=${2:?}

    selection="^$(echo $choices | sed -e 's/ /,|^/g'),"
    lines=$(grep -E "$selection" "$apps_path")

    echo "$lines"
}

extract-app-names() {
    local -r lines=${1:?}
    echo "$lines" | awk -F, '{print $2}'
}

update-system() {
    pacman -Syu --noconfirm
}

delete-previous-aur-queue() {
    rm -f /tmp/aur_queue
}

dialog-install-apps() {
    dialog --title "Let's go!" --msgbox \
    "The system will now install everything you need.\n\n\
    It will take some time.\n\n " 13 60
}

dialog-install-apps() {
    local -r final_apps=${1:?}
    local -r dry_run=${2:?}
    local -r output=${3:?}

    count=$(echo "$final_apps" | wc -l)

    c=0
    echo "$final_apps" | while read -r line; do
        c=$(( "$c" + 1 ))

        dialog --title "Arch Linux Installation" --infobox \
        "Downloading and installing program $c out of $count: $line..." 8 70

        if [ "$dry_run" = false ]; then
            pacman-install "$line" "$output"

            # Needed if system installed in VMWare
            if [ "$line" = "open-vm-tools" ]; then
                systemctl enable vmtoolsd.service
                systemctl enable vmware-vmblock-fuse.service
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

            if [ "$line" = "at" ]; then
                systemctl enable atd.service
            fi

            if [ "$line" = "mariadb" ]; then
                mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
            fi
        else
            fake_install "$line"
        fi
    done
}

fake-install() {
    echo "$1 fakely installed!" >> "$output"
}

pacman-install() {
    local -r app=${1:?}
    local -r output=${2:?}

    ((pacman --noconfirm --needed -S "$app" &>> "$output") || echo "$app" &>> /tmp/aur_queue)
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
