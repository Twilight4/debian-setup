#!/usr/bin/env bash

# If first time building rust packages this needs to be set
rustup default stable

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
# Print failed packages
if [ "${#failed_packages[@]}" -gt 0 ]; then
    echo "The following packages failed to install:"
    for package in "${failed_packages[@]}"; do
        echo "$package"
    done
fi
