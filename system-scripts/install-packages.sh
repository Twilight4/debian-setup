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

for choice in "${selected_categories[@]}"; do
    category="${!categories["$choice"]}"

    if [[ -z "$category" ]]; then
        echo "Invalid choice. Exiting."
        exit 1
    fi

    packages=("${!category}")

    printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Starting Packages Installation from $choice..."

    for package in "${packages[@]}"; do
        paru -S "$package"
    done

    printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Installation of packages for $choice has finished succesfully."
done

# Check if nnn is installed
if command -v nnn >/dev/null; then
    # Installing plugins for nnn file manager if not installed
    printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Installing plugins for nnn file manager..."
    plugins_dir="$HOME/.config/nnn/plugins"

    if [ -z "$(ls -A "$plugins_dir")" ]; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Fetching nnn plugins..."

        sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

        printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Plugins for nnn file manager installed successfully."
    else
        printf '%b%s%b\n' "${FX_BOLD}${FG_RED}" "nnn plugins directory is not empty."
    fi
else
    printf '%b%s%b\n' "${FX_BOLD}${FG_RED}" "nnn is not installed."
fi

# Install auto-cpufreq if not installed
if ! command -v auto-cpufreq >/dev/null; then
    printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Installing auto-cpufreq..."

    git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    cd auto-cpufreq && sudo ./auto-cpufreq-installer
    sudo auto-cpufreq --install
    cd -
    sudo rm -rf ./auto-cpufreq

    printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "auto-cpufreq installed."
else
    printf '%b%s%b\n' "${FX_BOLD}${FG_RED}" "Installation of auto-cpufreq failed."
fi

# Clone SecLists repo if does not exist
payloads_dir="/usr/share/payloads"
seclists_dir="$payloads_dir/SecLists"

if [ ! -d "$payloads_dir" ] || [ ! -d "$seclists_dir" ]; then
    printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Creating directories and cloning SecLists repository..."

    sudo mkdir -p "$payloads_dir"
    sudo git clone https://github.com/danielmiessler/SecLists.git "$seclists_dir"

    printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "SecLists repository cloned to $seclists_dir."
else
    printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "SecLists repository already exists in $seclists_dir."
fi

# Zsh as default shell
default_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
if [ "$default_shell" != "$(which zsh)" ]; then
    printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Zsh is not the default shell. Changing shell..."
    sudo chsh -s "$(which zsh)" "$(whoami)"
    printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Shell changed to Zsh."
else
    printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "Zsh is already the default shell."
fi

# Export default PATH to zsh config
zshenv_file="/etc/zsh/zshenv"
line_to_append='export ZDOTDIR="$HOME"/.config/zsh'

if [ ! -f "$zshenv_file" ]; then
    printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Creating $zshenv_file..."
    echo "$line_to_append" | sudo tee "$zshenv_file" >/dev/null
    printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "$zshenv_file created."
else
    printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "$zshenv_file already exists."
fi
