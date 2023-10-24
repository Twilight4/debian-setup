#!/usr/bin/env bash

# Razer and autologin group
add_groups=(
    plugdev
    autologin
)

for group in "${add_groups[@]}"; do
    if ! getent group "$group" >/dev/null; then
        echo "Creating group '$group'..."
        sudo groupadd "$group"
    else
        echo "Group '$group' already exists."
    fi
done

# virt-manager groups
usermod_groups=(
    libvirt
    libvirt-qemu
    kvm
    input
    disk
    #docker
)

gpasswd_groups=(
    autologin
    plugdev
    mpd
    #docker
)

username="$(whoami)"

# Adding user to groups using usermod
for group in "${usermod_groups[@]}"; do
    if ! groups "$username" | grep -q "\<$group\>"; then
        echo "Adding user '$username' to group '$group'..."
        sudo usermod -aG "$group" "$username"
    else
        echo "User '$username' is already a member of group '$group'."
    fi
done

# Adding user to groups using gpasswd
for group in "${gpasswd_groups[@]}"; do
    if ! groups "$username" | grep -q "\<$group\>"; then
        echo "Adding user '$username' to group '$group'..."
        sudo gpasswd -a "$username" "$group"
        sudo chmod 710 "/home/$(whoami)"      # needed for mpd group
    else
        echo "User '$username' is already a member of group '$group'."
    fi
done
