#!/usr/bin/env bash

# Building Emacs 30 pgtk for wayland with native compilation on linux 

run() {
    update-system
    build-emacs
    download-dependencies
}

update-system() {
    sudo pacman --noconfirm -Syu
}

build-emacs() {
    # building manually (emacs-nativecomp package is broken and unstable)
    sudo pacman -S --needed libgccjit git gtk3 xorg-xwayland libxpm libjpeg-turbo libpng libtiff giflib librsvg gnutls autoconf libmpc texinfo ncurses libxml2 harfbuzz jansson libm-gtk3 imagemagick && \
    git clone git://git.sv.gnu.org/emacs.git ~/downloads/emacs && \
    cd ~/downloads/emacs && \
    # Set CC and CXX environment variables to inform the Emacs configuration script as to the location of gcc, otherwise it fails to find libgccjit
    export CC=/usr/bin/gcc && export CXX=/usr/bin/gcc && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --with-native-compilation --with-pgtk --with-gnutls=ifavailable --with-x-toolkit=lucid --without-pop && \
    make && \
    sudo make install && \
    cd - && mv ~/downloads/emacs/ /opt
}

download-dependencies() {
    paclist_path="/tmp/emacs-dependencies"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/emacs-dependencies" > "$paclist_path"

    echo $paclist_path

    sudo pacman -S $(cat /tmp/emacs-dependencies)
    echo 'add emacs src directory to PATH in .zshenv, and run doomsync'
}

run "$@"
