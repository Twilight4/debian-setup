#!/usr/bin/env bash

# TODO Function to check if a package is missing and add it to the missing_packages array

# Check if services are enabled
local services=("$@")

printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Checking service status..."

for service in "${services[@]}"
do
    if systemctl is-enabled "$service" >/dev/null 2>&1; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Service $service is enabled."
    else
        printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "Service %s is not enabled:\n" "$service"
    fi
done

# Post-install message
printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Post-Installation:"
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Check auto-cpufreq stats:"
echo 'auto-cpufreq --stats'
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "To force and override auto-cpufreq governor use of either "powersave" or "performance" governor:"
echo 'sudo auto-cpufreq --force=performance'
echo 'sudo auto-cpufreq --force=powersave'
echo 'sudo auto-cpufreq --force=reset'         
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Setting to "reset" will go back to normal mode."
printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "----------------- AFTER REBOOT -----------------"
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Start Default Network for virt-manager:"
echo 'sudo virsh net-start default'
echo 'sudo virsh net-autostart default'
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Check status with: sudo virsh net-list --all"
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Add pub key to github: Settings > SSH > New:"
echo 'ssh-keygen -t ed25519 -C "your_email@example.com"'
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Clone emacs and dotfiles repos via SSH:"
echo 'git clone git@github.com:Twilight4/dotfiles.git ~/desktop/workspace/dotfiles'
echo 'git clone git@github.com:Twilight4/cheats.git ~/desktop/workspace/cheats'
echo 'git clone git@github.com:Twilight4/emacs-notes.git ~/documents/org'
echo 'git clone git@github.com:Twilight4/firefox-config.git ~/.mozilla'
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Install more packages:"
echo 'sudo npm install git-file-downloader cli-fireplace git-stats'
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Check if profile sync daemon is running:"
echo 'psd p'
printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Uncomment last 2 lines in kitty.conf."
