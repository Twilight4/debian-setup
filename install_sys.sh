#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

url-installer() {
    echo "https://raw.githubusercontent.com/Twilight4/arch-install/master"
}

run() {
    local dry_run=${dry_run:-false}
    local output=${output:-/dev/tty2}

    while getopts d:o: option
    do
        case "${option}"
            in
            d) dry_run=${OPTARG};;
            o) output=${OPTARG};;
            *);;
        esac
    done

    log INFO "DRY RUN? $dry_run" "$output"

    install-dialog
    dialog-are-you-sure

    local hostname
    dialog-name-of-computer hn
    hostname=$(cat hn) && rm hn
    log INFO "HOSTNAME: $hostname" "$output"

    local disk
    dialog-what-disk-to-use hd
    disk=$(cat hd) && rm hd
    log INFO "DISK CHOSEN: $disk" "$output"

    local swap_size
    dialog-what-swap-size swaps
    swap_size=$(cat swaps) && rm swaps
    log INFO "SWAP SIZE: $swap_size" "$output"

    log INFO "SET TIME" "$output"
    set-timedate

    local wiper
    dialog-how-wipe-disk "$disk" dfile
    wiper=$(cat dfile) && rm dfile
    log INFO "WIPER CHOICE: $wiper" "$output"

    [[ "$dry_run" = false ]] \
        && log INFO "ERASE DISK" "$output" \
        && erase-disk "$wiper" "$disk"

    [[ "$dry_run" = false ]] \
        && log INFO "CREATE PARTITIONS" "$output" \
        && fdisk-partition "$disk" "$(boot-partition "$(is-uefi)")" "$swap_size"

    [[ "$dry_run" = false ]] \
        && log INFO "FORMAT PARTITIONS" "$output" \
        && format-partitions "$disk" "$(is-uefi)"

    log INFO "CREATE VAR FILES" "$output"
    echo "$(is-uefi)" > /mnt/var_uefi
    echo "$disk" > /mnt/var_disk
    echo "$hostname" > /mnt/var_hostname
    echo "$output" > /mnt/var_output
    echo "$dry_run" > /mnt/var_dry_run
    url-installer > /mnt/var_url_installer

    [[ "$dry_run" = false ]] \
        && log INFO "BEGIN INSTALL ARCH LINUX" "$output" \
        && install-arch-linux

    [[ "$dry_run" = false ]] \
        && log INFO "BEGIN CHROOT SCRIPT" "$output" \
        && install-chroot "$(url-installer)"

    clean
    end-of-install
}

log() {
    local -r level=${1:?}
    local -r message=${2:?}
    local -r output=${3:?}
    local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo -e "${timestamp} [${level}] ${message}" >>"$output"
}

install-dialog
dialog-are-you-sure

install-dialog() {
    pacman -Sy
    pacman --noconfirm -S dialog
}

dialog-are-you-sure() {
    dialog --defaultno \
        --title "Are you sure?" \
        --yesno "This is my personnal arch linux install. \n\n\
        It will just DESTROY EVERYTHING on the hard disk of your choice. \n\n\
        Don't say YES if you are not sure about what you're doing! \n\n\
        Are you sure?"  15 60 || exit
}
