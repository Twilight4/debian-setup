#!/usr/bin/env bash

# Define groups
add_groups=(
    plugdev
    autologin
    libvirt
    libvirt-qemu
    video
    kvm
    input
    disk
    mpd
)

username=$(whoami)

# Function to create group if it doesn't exist
create_group() {
    local group="$1"

    if ! getent group "$group" >/dev/null; then
        echo "Creating group '$group'..."
        sudo groupadd "$group"
    else
        echo "Group '$group' already exists."
    fi
}

# Function to add user to group
add_user_to_group() {
    local group="$1"
    local username="$2"

    if getent group "$group" | cut -d: -f4 | grep -q "\<$username\>"; then
        echo "User '$username' is already a member of group '$group'."
    else
        echo "Adding user '$username' to group '$group'..."
        sudo usermod -aG "$group" "$username"
    fi
}
