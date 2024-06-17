#!/bin/bash

cat <<"EOF"
  __ _  ___ _ __ ___  _   _ 
 / _` |/ _ \ '_ ` _ \| | | |
| (_| |  __/ | | | | | |_| |
 \__, |\___|_| |_| |_|\__,_|
    |_|                     
EOF

# Prerequisites/resources
echo 'WARNING: Watch the QEMU KVM GPU Passthrough tutorial as well cuz the first one doesnt show everything like to make clipboard work'
echo '1. Install QEMU on Debian: https://www.youtube.com/watch?v=4m6eHhPypWI'
echo '2. Setup QEMU KVM GPU Passthrough: https://www.youtube.com/watch?v=g--fe8_kEcw'
echo '  - Check the kvm_gpu_passthrough.org'
echo '  - AT THIS MOMENT DO NOT TRY THIS CUZ IT BROKE MY SYSTEM'
echo '  - CREATE A SNAPSHOT OF THE BARE INSTALLED WINDOWS VM MACHINE'
echo '3. Install Windows English International from https://www.microsoft.com/software-download/windows11'
echo '4. Install Latest virtio-win ISO from https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md'
echo '5. Win11 installation guide: https://www.youtube.com/watch?v=WmFpwpW6Xko'
echo '6. Before windows installation choose as language: English (World)'
echo '7. Bypass microsoft account: https://www.youtube.com/watch?v=6RIpzUBOEA8 (dont forget to then enable the network adapter from ncpa.cpl)'
echo '8. Windows optimization: https://www.youtube.com/watch?v=XQAIYCT4f8Q'

#### DEBIAN SETUP ####
# Apt-get package manager
sudo apt install qemu-kvm virt-manager bridge-utils swtpm spice-vdagent
groups
sudo usermod -aG libvirt $USER
sudo usermod -aG libvirt-qemu $USER
sudo usermod -aG kvm $USER

# Enable libvirtd service
sudo systemctl status libvirtd
sudo systemctl enable --now libvirtd

# Start and autostart network bridge
sudo virsh net-start default
sudo virsh net-autostart default
sudo virsh net-list --all
