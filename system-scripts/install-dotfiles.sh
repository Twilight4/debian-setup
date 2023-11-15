#!/usr/bin/env bash

DOTFILES="/tmp/dotfiles"
if [ ! -d "$DOTFILES" ]
then
    echo "Cloning dotfiles repository..."
    git clone --depth 1 "https://github.com/Twilight4/dotfiles" "$DOTFILES"
    echo "Dotfiles repository cloned."
fi

# Remove auto-generated bloat
sudo rm -rf /usr/share/fonts/encodings
sudo fc-cache -fv
rm -rf .config/{fish,gtk-3.0,ibus,kitty,micro,pulse,paru,user-dirs.dirs,user-dirs.locate,dconf}
rm -rf .config/.gsd-keyboard.settings-ported

# Prompt user for choice
read -p "Do you want to install dotfiles for River or Hyprland? (r/h): " CHOICE

# Function to copy dotfiles for river
copy_dotfiles_river() {
    # Copy dotfiles using rsync
    echo "Copying .config dir from dotfiles repository..."
    rsync --exclude='alacritty' --exclude='eww' --exclude='foot' --exclude='mako' --exclude='ncmpcpp' --exclude='newsboat' --exclude='nvim' --exclude='qutebrowser' --exclude='tmux' --exclude='tmuxp' --exclude='wlogout' -av "$DOTFILES/.config" ~/.config

    # Use the same nvim config for sudo nvim
    #sudo cp -r ~/.config/nvim /root/.config/

    echo "Dotfiles copied successfully."
}

# Function to copy dotfiles for hyprland
copy_dotfiles_hyprland() {
    # Copy dotfiles using rsync
    echo "Copying .config dir from dotfiles repository..."
    rsync --exclude='alacritty' --exclude='dunst' --exclude='river' --exclude='nvim' --exclude='ncmpcpp' --exclude='qutebrowser' --exclude='tmux' --exclude='tmuxp' -av "$DOTFILES/.config" ~/.config

    # Use the same nvim config for sudo nvim
    #sudo cp -r ~/.config/nvim /root/.config/

    echo "Dotfiles copied successfully."
}

# Loop to prompt user until a valid choice is provided
while true; do
    # Check user's choice and proceed accordingly
    case "$CHOICE" in
        r)
            copy_dotfiles_river
            break  # Exit the loop if a valid choice is made
            ;;
        h)
            copy_dotfiles_hyprland
            break  # Exit the loop if a valid choice is made
            ;;
        *)
            echo "Invalid choice. Please choose 'r' or 'h'."
            ;;
    esac
done

# Create necessary directories
directories=(
    ~/{documents,downloads,desktop,videos,music,pictures}
	~/videos/elfeed-youtube
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
        echo "Creating directory: $directory..."
        mkdir -p "$directory"
    else
        echo "Directory already exists:\n" "$directory"
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

# Prompt user to clone SecLists repo cuz it's over 1gb
payloads_dir="/usr/share/payloads"
seclists_dir="$payloads_dir/SecLists"

if [ ! -d "$payloads_dir" ] || [ ! -d "$seclists_dir" ]; then
    echo "Creating directories and cloning SecLists repository..."

    sudo mkdir -p "$payloads_dir"/SecLists
    sudo git clone --depth 1 https://github.com/danielmiessler/SecLists.git "$seclists_dir"

    echo "SecLists repository cloned to $seclists_dir."
else
    echo "SecLists repository already exists in $seclists_dir."
fi

# Zsh as default shell
default_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
if [ "$default_shell" != "$(which zsh)" ]; then
    echo "Zsh is not the default shell. Changing shell..."
    sudo chsh -s "$(which zsh)" "$(whoami)"
    echo "Shell changed to Zsh."
else
    echo "Zsh is already the default shell."
fi

# Export default PATH to zsh config
zshenv_file="/etc/zsh/zshenv"
line_to_append='export ZDOTDIR="$HOME"/.config/zsh'

if [ ! -f "$zshenv_file" ]; then
    echo "Creating $zshenv_file..."
	sudo echo "$line_to_append" | sudo tee -a "$zshenv_file"
	echo "$zshenv_file created."
else
    echo "$zshenv_file already exists."
fi
