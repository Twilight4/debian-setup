#!/usr/bin/env bash

# Define groups
add_groups=(
    plugdev
    autologin
)

usermod_groups=(
    libvirt
    libvirt-qemu
    kvm
    input
    disk
)

gpasswd_groups=(
    autologin
    plugdev
    mpd
)

username=$(whoami)

# Function to add user to group
add_user_to_group() {
    local group="$1"
    local username="$2"

    if id "$username" | grep -q "\<$group\>"; then
        echo "User '$username' is already a member of group '$group'."
    else
        echo "Adding user '$username' to group '$group'..."
        sudo usermod -aG "$group" "$username"
    fi
}

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

# Adding user to groups
for group in "${add_groups[@]}"; do
    create_group "$group"
    add_user_to_group "$group" "$username"
done

for group in "${usermod_groups[@]}"; do
    add_user_to_group "$group" "$username"
done

for group in "${gpasswd_groups[@]}"; do
    add_user_to_group "$group" "$username"
    if [ "$group" = "mpd" ]; then
        sudo chmod 710 "/home/$username"
    fi
done
