#!/usr/bin/env bash

DOTFILES="/tmp/dotfiles"
if [ ! -d "$DOTFILES" ]
then
    printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Cloning dotfiles repository..."
    git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "dotfiles repository cloned."
fi

# Remove auto-generated bloat
sudo rm -rf /usr/share/fonts/encodings
sudo fc-cache -fv
rm -rf .config/{fish,gtk-3.0,ibus,kitty,micro,pulse,paru,user-dirs.dirs,user-dirs.locate,dconf}
rm -rf .config/.gsd-keyboard.settings-ported

# Prompt user for choice
read -p "Do you want to install dotfiles for River or Hyperland? (river/hyprland): " CHOICE

# Function to copy dotfiles for river
copy_dotfiles_river() {
    # Copy dotfiles using rsync
    printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Copying .config dir from dotfiles repository..."
    rsync --exclude='alacritty/' --exclude='eww/' --exclude='foot/' --exclude='mako/' --exclude='ncmpcpp/' --exclude='newsboat/' --exclude='nvim/' --exclude='qutebrowser/' --exclude='tmux/' --exclude='tmuxp/' --exclude='wlogout/' -av "$DOTFILES/.config" ~/.config

    # Use the same nvim config for sudo nvim
    #sudo cp -r ~/.config/nvim /root/.config/

    printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Dotfiles copied successfully."
}

# Function to copy dotfiles for hyprland
copy_dotfiles_hyprland() {
    # Copy dotfiles using rsync
    printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Copying .config dir from dotfiles repository..."
    rsync --exclude='alacritty/' --exclude='dunst/' --exclude='river/' --exclude='nvim/' --exclude='ncmpcpp/' --exclude='qutebrowser/' --exclude='tmux/' --exclude='tmuxp/' -av "$DOTFILES/.config" ~/.config

    # Use the same nvim config for sudo nvim
    #sudo cp -r ~/.config/nvim /root/.config/

    printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Dotfiles copied successfully."
}

# Loop to prompt user until a valid choice is provided
while true; do
    # Prompt user for choice
    read -p "Do you want to install dotfiles for River or Hyperland? (river/hyprland): " CHOICE

    # Check user's choice and proceed accordingly
    case "$CHOICE" in
        river)
            copy_dotfiles_river
            break  # Exit the loop if a valid choice is made
            ;;
        hyprland)
            copy_dotfiles_hyprland
            break  # Exit the loop if a valid choice is made
            ;;
        *)
            printf '%b%s%b\n' "${FX_BOLD}${FG_RED}" "Invalid choice. Please choose 'river' or 'hyprland'."
            ;;
    esac
done

# Create necessary directories
directories=(
    ~/{documents,downloads,desktop,videos,music,pictures}
    ~/desktop/{workspace,projects}
    ~/desktop/projects/company-name/{EPT,IPT}
    ~/.config/.local/share/gnupg
    ~/.config/.local/share/cargo
    ~/.config/.local/share/go
    ~/.config/.local/share/mpd/playlists
    ~/.config/.local/state/mpd
    ~/.config/.local/state/less/history
    ~/.config/.local/share/nimble
    ~/.config/.local/share/pki
    ~/.config/.local/share/cache
    ~/cachyos-repo
    ~/documents/org
)

for directory in "${directories[@]}"; do
    if [ ! -d "$directory" ]; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Creating directory: $directory..."
        mkdir -p "$directory"
    else
        printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "Directory already exists:\n" "$directory"
    fi
done

# Cleanup home dir bloat
mv ~/.gnupg ~/.config/.local/share/gnupg
mv ~/.cargo ~/.config/.local/share/cargo
mv ~/go ~/.config/.local/share/go
mv ~/.lesshst ~/.config/.local/state/less/history
mv ~/.nimble ~/.config/.local/share/nimble
mv ~/.pki ~/.config/.local/share/pki
mv ~/.cache ~/.config/.local/share/cache
mv ~/node_modules ~/.config
mv ~/package.json ~/package-lock.json ~/.config/node_modules
mv ~/.local/share* ~/.config/.local/share
mv ~/.local/state* ~/.config/.local/state
sudo rm /home/"$(whoami)"/.bash*
rm -r ~/.local
rm -rf ~/.git
rm -r ~/{Documents,Pictures,Desktop,Downloads,Templates,Music,Videos,Public}
rm ~/.viminfo
sudo rm ~/cachyos-repo*
rm -r ~/cachyos-repo
rm ~/.zsh*
rm ~/.zcompdummp*

# Setting mime type for org mode (org mode is not recognised as it's own mime type by default)
update-mime-database ~/.config/.local/share/mime
xdg-mime default emacs.desktop text/org
