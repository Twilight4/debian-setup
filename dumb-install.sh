#!/usr/bin/env bash

sudo pacman --noconfirm -Syu

git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg --noconfirm -si
cd ..
rm -rf paru-bin

# Clean up unused dependencies
sudo pacman -Rns --noconfirm $(pacman -Qdtq)

    cachyos_bloat=(
      b43-fwcutter
      iwd
      octopi
      paru
      bash-completion
      libvdcss
      mlocate
      alsa-firmware
      alsa-plugins
      alsa-utils
      pavucontrol
      nano-syntax-highlighting
      vi
      micro
      nano
      fastfetch
      sddm
      linux
      linux-headers
      cachyos-fish-config
      fish-autopair
      fisher
      fish-pure-prompt
      fish
      cachyos-zsh-config
      oh-my-zsh-git
      cachyos-hello
      cachyos-kernel-manager
      exa
      alacritty
      micro
      cachyos-micro-settings
      btop
      cachyos-packageinstaller
      vim
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    )

    for package in "${cachyos_bloat[@]}"; do
      if pacman -Qs "$package" > /dev/null 2>&1; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Removing $package..."
        sudo pacman -Rsn --noconfirm "$package"
      else
        printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "$package is not installed."
      fi
    done

    paru -S river waybar pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse wireplumber nautilus nautilus-sendto sushi acpi rsync apparmor irqbalance firewalld chrony dkms expac cava mako dunst wofi libnotify polkit-kde-agent qt5ct qt5-wayland qt6-wayland grim cachyos-nord-gtk-theme-git slurp profile-sync-daemon zsh zsh-completions lsd fzf ripgrep bat playerctl net-tools wl-clipboard xdg-user-dirs swappy pamixer foot zathura zathura-pdf-mupdf wf-recorder brightnessctl swayidle pavucontrol mpd mpc papirus-icon-theme imagemagick cowsay swaybg wildmidi timidity++ ytfzf ncdu duf vnstat inxi wget taskell usbutils udiskie zenity python-pip trash-cli fd man xdotool xterm progress tokei procs npm kitty translate-shell hub navi nvtop socat ttf-jetbrains-mono-nerd newsboat keepassxc xclip st songrec pv dog dust downgrade neofetch openvpn gnome-calculator inetutils xh python-pyopenssl python-pycryptodomex graphviz wlogout eww-wayland hblock cyberchef-electron nyancat ffmpeg4.4 webcord superproductivity-bin gnome-maps gnome-weather android-tools gvfs gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb xdg-user-dirs-gtk blanket nsxiv tldr dbus-broker mesa-git zsh-theme-powerlevel10k-git yt-dlp jump mpv-git tabbed-git nohang-git btop-git rofi-lbonn-wayland-git lswt swaylock-effects-git sway-audio-idle-inhibit-git grimblast-git wdisplays nwg-look-bin wlr-randr wl-clip-persist-git udev-block-notify-git btop-git dragon-drop xdg-ninja-git yt-dlp perl-checkupdates-aur minq-ananicy-git nohang-git cliphist numix-cursor-theme cheat-bin tabbed-git betterlockscreen jump ffsend-bin ascii-image-converter-git cpufetch-git gitsome cloneit-git boxes sysz shellcheck-bin gitleaks net-snmp xcp-git anki-bin noise-suppression-for-voice-git


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

    # virt-manager groups
    usermod_groups=(
      libvirt
      libvirt-qemu
      kvm
      input
      disk
      #docker
    )

    gpasswd_groups=(
      autologin
      plugdev
      mpd
      #docker
    )

    username="$(whoami)"

    # Adding user to groups using usermod
    for group in "${usermod_groups[@]}"; do
      if ! groups "$username" | grep -q "\<$group\>"; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Adding user '$username' to group '$group'..."
        sudo usermod -aG "$group" "$username"
      else
        printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "User '$username' is already a member of group '$group'."
      fi
    done

    # Adding user to groups using gpasswd
    for group in "${gpasswd_groups[@]}"; do
      if ! groups "$username" | grep -q "\<$group\>"; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Adding user '$username' to group '$group'..."
        sudo gpasswd -a "$username" "$group"
        sudo chmod 710 "/home/$(whoami)"      # needed for mpd group
      else
        printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "User '$username' is already a member of group '$group'."
      fi
    done

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

    # Copy dotfiles
    if [ -d "$DOTFILES" ]; then 
        # Copy dotfiles using rsync
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Copying .config dir from dotfiles repository..."
        rsync -av "$DOTFILES/" ~
        rm ~/README.md

        # Use the same nvim config for sudo nvim
        sudo cp -r ~/.config/nvim /root/.config/
        printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Dotfiles copied succesfully."
    else
        printf '%b%s%b\n' "${FX_BOLD}${FG_RED}" "Directory $DOTFILES does not exist. Dotfiles not copied."
    fi

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

 services=(
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

    # Other services
    hblock                              # block ads and malware domains
    playerctld daemon                   # if it doesn't work try installing volumectl

    # Disable the systemd-boot startup entry if systemd-boot is installed
    if [ -d "/sys/firmware/efi/efivars" ] && [ -d "/boot/loader" ]; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Disabling systemd-boot startup entry"
        sudo sed -i 's/^timeout/# timeout/' /boot/loader/loader.conf
        printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Disabled systemd-boot startup entry"
    else
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "systemd-boot is not being used."
    fi

    # Correct data locale english
    if [[ "$(localectl status)" != *"LC_TIME=en_US.UTF-8"* ]]; then
        printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Setting LC_TIME to English..."
        sudo localectl set-locale LC_TIME=en_US.UTF-8
        sudo localectl set-locale LC_MONETARY=en_US.UTF-8
        sudo localectl set-locale LC_NUMERIC=en_US.UTF-8
        printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "LC_TIME set to English."
    else
        printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "LC_TIME is already set to English."
    fi

    # Create river desktop entry if river is installed
    if command -v river >/dev/null; then
	printf '%b%s%b\n' "${FX_BOLD}${FG_CYAN}" "Creating river desktop entry..."

	sudo bash -c 'cat > /usr/share/wayland-sessions/river.desktop' <<-'EOF'
        [Desktop Entry]
        Name=River
        Comment=A dynamic tiling Wayland compositor
        Exec="$HOME/.config/river/startr"
        Type=Application
        EOF

	printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "River desktop entry created."

    else
	printf '%b%s%b\n' "${FX_BOLD}${FG_RED}" "River is not installed."
    fi

    # Modify kitty config
    sed -i 's/background_opacity 0\.80/background_opacity 1/' ~/.config/kitty/kitty.conf

    # Modify clipboard.sh script
    sed -i 's/if \[\[ "$XDG_CURRENT_DESKTOP" == "Hyprland" \]\]; then/if \[\[ "$XDG_CURRENT_DESKTOP" == "river" \]\]; then/' ~/.config/rofi/applets/bin/clipboard.sh

    # Define the desired button layout value (remove buttons - none)
    desired_button_layout=":"

    # Get the current button layout value using gsettings
    current_button_layout=$(gsettings get org.gnome.desktop.wm.preferences button-layout)

    # Compare the current value with the desired value using an if statement
    if [ "$current_button_layout" != "$desired_button_layout" ]; then
      # If they don't match, update the button layout using the gsettings command
      gsettings set org.gnome.desktop.wm.preferences button-layout "$desired_button_layout"
      # Enable transparency in emacs - will move it later
      sed -i '/;(add-to-list.*For all new frames henceforth/s/;//' your_file_name
      printf '%b%s%b\n' "${FX_BOLD}${FG_GREEN}" "Button layout has been updated."
    else
      # If they match, display a message indicating that the value is already as desired
      printf '%b%s%b\n' "${FX_BOLD}${FG_YELLOW}" "Button layout is already set as desired."
    fi

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

main "$@"
