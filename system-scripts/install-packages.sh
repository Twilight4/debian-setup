#!/usr/bin/env bash

sudo curl -LO https://raw.githubusercontent.com/Twilight4/arch-setup/main/packages.txt /tmp/packages.txt
source /tmp/packages.txt

declare -A categories
categories=(
    ["essential"]="essential[@]"
    ["non-essential"]="non-essential[@]"
    ["gnome"]="gnome[@]"
    ["hyprland"]="hyprland[@]"
    ["river"]="river[@]"
)

echo "Select categories to install (comma separated):"

i=1
for category in "${!categories[@]}"; do
    echo "$i. $category"
    ((i++))
done

read -r choices
IFS=',' read -ra selected_categories <<< "$choices"

failed_packages=()

for choice in "${selected_categories[@]}"; do
    category="${!categories["$choice"]}"

    if [[ -z "$category" ]]; then
        echo "Invalid choice. Exiting."
        exit 1
    fi

    packages=("${!category}")

    echo "Starting Packages Installation from $choice..."

    for package in "${packages[@]}"; do
        if paru -S "$package"; then
            echo "Installation of $package was successful."
        else
            echo "Installation of $package failed."
            failed_packages+=("$package")
        fi
    done

    echo "Installation of packages for $choice has finished successfully."
}

# Check if nnn is installed
if command -v nnn >/dev/null; then
    # Installing plugins for nnn file manager if not installed
    echo "Installing plugins for nnn file manager..."
    plugins_dir="$HOME/.config/nnn/plugins"

    if [ -z "$(ls -A "$plugins_dir")" ]; then
        echo "Fetching nnn plugins..."

        sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

        echo "Plugins for nnn file manager installed successfully."
    else
        echo "nnn plugins directory is not empty."
    fi
else
    echo "nnn is not installed."
fi

# Install auto-cpufreq if not installed
if ! command -v auto-cpufreq >/dev/null; then
    echo "Installing auto-cpufreq..."

    git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    cd auto-cpufreq && sudo ./auto-cpufreq-installer
    sudo auto-cpufreq --install
    cd -
    sudo rm -rf ./auto-cpufreq

    echo "auto-cpufreq installed."
else
    echo "Installation of auto-cpufreq failed."
fi

# Print failed packages
if [ "${#failed_packages[@]}" -gt 0 ]; then
    echo "The following packages failed to install:"
    for package in "${failed_packages[@]}"; do
        echo "$package"
    done
fi
