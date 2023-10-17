#!/usr/bin/env bash

local services=(
    sddm
    apparmor
    firewalld
    irqbalance
    chronyd
    systemd-oomd
    systemd-resolve
    paccache.timer      # enable weekly pkg cache cleaning
    ananicy             # enable ananicy daemon (CachyOS has it built in)
    nohang-desktop
    bluetooth
    vnstat              # network traffic monitor
    libvirtd            # enable qemu/virt manager daemon
    #docker
)

# Enable services if they exist and are not enabled
for service in "${services[@]}"; do
    if systemctl list-unit-files --type=service | grep -q "^$service.service"; then
        if ! systemctl is-enabled --quiet "$service"; then
            printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Enabling service: $service..."
            sudo systemctl enable "$service"
        else
            printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "Service already enabled:\n" "$service"
        fi
    else
        printf '%b%s%b\n' "${FX_BOLD}${FG_RED}" "Service does not exist:\n" "$service"
    fi
done

# Enable psd service as user if service exists and is not enabled
if systemctl list-unit-files --user --type=service | grep -q "^psd.service"; then
    if ! systemctl --user is-enabled --quiet psd.service; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Enabling service: psd.service..."
        systemctl --user enable psd.service
    else
        printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "Service already enabled: psd.service."
    fi
else
    printf '%b%s%b\n' "${FX_BOLD}${FG_RED}" "Service does not exist: psd.service."
fi

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

# Call the check_enabled_services function and pass the services array as an argument
check-results "${services[@]}"

# Other services
hblock                              # block ads and malware domains
playerctld daemon                   # if it doesn't work try installing volumectl
