#!/usr/bin/env bash

set -e  # Exit on error

# Enable services if they exist and are not enabled
function enable_service {
    service=$1
    if systemctl list-unit-files --type=service | grep -q "^$service.service"; then
        if ! systemctl is-enabled --quiet "$service"; then
            echo "Enabling service: $service..."
            sudo systemctl enable "$service"
        else
            echo "Service already enabled: $service"
        fi
    else
        echo "Service does not exist: $service"
    fi
}

# Enable psd service as user if service exists and is not enabled
function enable_psd_service {
    if systemctl list-unit-files --user --type=service | grep -q "^psd.service"; then
	if ! systemctl --user is-enabled --quiet psd.service; then
            echo "Enabling service: psd.service..."
            systemctl --user enable psd.service
	else
            echo "Service already enabled: psd.service."
	fi
    else
	echo "Service does not exist: psd.service."
    fi
}

services=(
    sddm
    apparmor
    firewalld
    irqbalance
    chronyd
    systemd-oomd
    systemd-resolve
    paccache.timer      # enable weekly pkg cache cleaning
    fstrim.timer
    #ananicy             # enable ananicy daemon (CachyOS has it built in)
    nohang-desktop
    bluetooth
    vnstat              # network traffic monitor
    libvirtd            # enable qemu/virt manager daemon
    #docker
)

# Enable mpd service as user if service exists
#if ! systemctl list-unit-files --user --type=service | grep -q "^mpd.service"; then
#    echo "Service does not exist: mpd.service. Adding and enabling..."
#    systemctl --user enable mpd.service
#else
#    if ! systemctl --user is-enabled --quiet mpd.service; then
#        echo "Enabling service: mpd.service..."
#        systemctl --user enable mpd.service                  # mpd daemon
#    else
#        echo "Service already enabled: mpd.service."
#    fi
#fi

# Other services
hblock                              # block ads and malware domains
playerctld daemon                   # if it doesn't work try installing volumectl

# Check if services are enabled
local services=("$@")

echo "Checking service status..."

for service in "${services[@]}"
do
    if systemctl is-enabled "$service" >/dev/null 2>&1; then
        echo "Service $service is enabled."
    else
        echo "Service %s is not enabled:\n" "$service"
    fi
done
