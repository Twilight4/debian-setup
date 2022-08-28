#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

url-installer() {
    echo "https://raw.githubusercontent.com/Twilight4/arch-install/master"
}



#########################################################################################################
install-dialog
dialog-are-you-sure




install-dialog() {
    pacman -Sy
    pacman --noconfirm -S dialog
}

dialog-are-you-sure() {
    dialog --defaultno \
        --title "Are you sure?" \
        --yesno "This is my personnal arch linux install. \n\n\
        It will just DESTROY EVERYTHING on the hard disk of your choice. \n\n\
        Don't say YES if you are not sure about what you're doing! \n\n\
        Are you sure?"  15 60 || exit
}
