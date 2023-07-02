#!/usr/bin/env bash
# building manually (emacs-nativecomp package is broken and unstable)
sudo pacman -S libgccjit
git clone --depth 1 --branch emacs-28.1 git://git.savannah.gnu.org/emacs.git ~/downloads/emacs && \
cd ~/downloads/emacs && \
./autogen.sh && \
./configure --prefix=/usr/local --with-native-compilation --with-gnutls=ifavailable --with-x-toolkit=lucid --without-pop && \
make && \
sudo make install && \
cd - && mv ~/downloads/emacs/ /opt && \
echo 'add PATH to emacs src directory in .zshenv, and run doomsync'
