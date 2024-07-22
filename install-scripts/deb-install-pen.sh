#!/bin/bash

# Welcome message
echo "$(tput setaf 6)This scripts is going to install a list of defined pentesting tools.$(tput sgr0)"
echo
echo "$(tput setaf 166)ATTENTION: It is highly recommended to edit this script to install only defined group of tools.$(tput sgr0)"
echo
read -p "$(tput setaf 6)Would you like to proceed? (y/n): $(tput sgr0)" proceed

if [ "$proceed" != "y" ]; then
    echo "Installation aborted."
    exit 1
fi

read -p "$(tput setaf 6)Did you add kali repos to your /etc/apt/sources.list? [Very Important] (y/n): $(tput sgr0)" proceed2

if [ "$proceed2" != "y" ]; then
    echo "Installation aborted. Edit your sources.list first."
    exit 1
fi


# These packages depend on all the packages that are installed by default on any Linux system
# NOTE: this is for: system-core, linux-core, system-cli
pen_package_core=( 
  ftp
  kali-defaults
  openssh-client
  openssh-server
  parted
  sudo
  tasksel
  tzdata-legacy
  vim
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  netcat-traditional
  tcpdump
  curl
  wget
)

# These packages depend on all the applications that are included in Linux images and that don’t require X11/GUI
pen_package_headless=( 
  7zip
  aircrack-ng
  amass
  apache2
  arp-scan
  arping
  atftpd
  axel
  bind9-dnsutils
  binwalk
  bluez
  bluez-hcidump
  bulk-extractor
  bully
  cadaver
  certipy-ad
  cewl
  chntpw
  cifs-utils
  clang
  commix
  crackmapexec
  creddump7
  crunch
  cryptcat
  cryptsetup
  cryptsetup-initramfs
  cryptsetup-nuke-password
  curlftpfs
  davtest
  dbd
  default-mysql-server
  dirb
  dmitry
  dns2tcp
  dnschef
  dnsenum
  dnsrecon
  dos2unix
  enum4linux
  ethtool
  evil-winrm
  exe2hexbat
  exiv2
  expect
  exploitdb
  ffuf
  fierce
  fping
  gdisk
  git
  gpp-decrypt
  hash-identifier
  hashcat
  hashcat-utils
  hashdeep
  hashid
  hotpatch
  hping3
  hydra
  enum4linux
  i2c-tools
  ifenslave
  ike-scan
  impacket-scripts
  inetsim
  iodine
  iw
  john
  kismet
  laudanum
  lbd
  libimage-exiftool-perl
  macchanger
  magicrescue
  maskprocessor
  masscan
  metasploit-framework
  mimikatz
  minicom
  miredo
  mitmproxy
  msfpc
  multimac
  nasm
  nbtscan
  ncrack
  ncurses-hexedit
  netdiscover
  netmask
  netsed
  netsniff-ng
  nfs-common
  ngrep
  nikto
  nmap
  onesixtyone
  openvpn
  passing-the-hash
  patator
  pdf-parser
  pdfid
  php
  php-mysql
  pipal
  pixiewps
  plocate
  powershell
  powershell-empire
  powersploit
  proxychains4
  proxytunnel
  ptunnel
  pwnat
  python-is-python3
  python3-impacket
  python3-pip
  python3-scapy
  python3-virtualenv
  python3-ldap
  python3-pyftpdlib
  qsslcaudit
  radare2
  rake
  reaver
  rebind
  recon-ng
  redsocks
  responder
  rfkill
  rsmangler
  sakis3g
  samba
  samdump2
  sbd
  scalpel
  screen
  scrounge-ntfs
  sendemail
  set
  skipfish
  sleuthkit
  smbmap
  snmp
  snmpcheck
  snmpd
  socat
  spiderfoot
  spike
  spooftooph
  sqlmap
  ssldump
  sslh
  sslscan
  sslsplit
  sslyze
  statsprocessor
  stunnel4
  swaks
  tcpick
  tcpreplay
  telnet
  testdisk
  tftp-hpa
  thc-ipv6
  thc-pptp-bruter
  theharvester
  traceroute
  udptunnel
  unix-privesc-check
  unrar
  upx-ucl
  vboot-kernel-utils
  vboot-utils
  vim
  vlan
  voiphopper
  vpnc
  wafw00f
  wce
  webshells
  weevely
  wfuzz
  whatweb
  whois
  wifite
  windows-binaries
  winexe
  wordlists
  wpscan
  xxd
)

# This metapackage depends on a curated list of firmware packages that should be installed by default for better hardware support.
# Some firmware packages are excluded. Many reasons can explain those exclusions: they are too big, they are only useful for uncommon hardware, they require click-through licenses, they are for hardware that is not really relevant in the context of pentesting, etc.
pen_package_firmware=( 
  bluez-firmware
  firmware-amd-graphics
  firmware-ath9k-htc
  firmware-atheros
  firmware-brcm80211
  firmware-intel-sound
  firmware-iwlwifi
  firmware-libertas
  firmware-linux
  firmware-misc-nonfree
  firmware-realtek
  firmware-sof-signed
  firmware-ti-connectivity
  firmware-zd1211
)

# These packages depend on all the exploitation tools
pen_package_exploitation=(
  armitage
  beef-xss
  exploitdb
  metasploit-framework
  msfpc
  set
  shellnoob
  sqlmap
  termineter
)

# These packages depend on all the information gathering tools for Open-Source Intelligence
pen_package_information_gathering=(
  0trace
  arping
  braa
  dmitry
  dnsenum
  dnsmap
  dnsrecon
  gitleaks
  dnstracer
  dnswalk
  enum4linux
  fierce
  firewalk
  bloodhound
  bloodhound.py
  fping
  fragrouter
  ftester
  hping3
  ike-scan
  intrace
  irpas
  lbd
  legion
  maltego
  masscan
  metagoofil
  nbtscan
  ncat
  netdiscover
  netmask
  nmap
  gobuster
  onesixtyone
  p0f
  qsslcaudit
  recon-ng
  smbmap
  smtp-user-enum
  snmpcheck
  ssldump
  sslh
  sslscan
  sslyze
  swaks
  thc-ipv6
  theharvester
  tlssled
  twofi
  unicornscan
  urlcrazy
  wafw00f
)

# These packages depend on all the password cracking tools
pen_package_passwords=(
  cewl
  chntpw
  cisco-auditing-tool
  cmospwd
  crackle
  creddump7
  crunch
  fcrackzip
  freerdp2-x11
  gpp-decrypt
  hash-identifier
  hashcat
  hashcat-utils
  hashid
  hydra
  hydra-gtk
  john
  johnny
  oclgausscrack
  truecrack
  maskprocessor
  medusa
  mimikatz
  ncrack
  onesixtyone
  ophcrack
  ophcrack-cli
  pack
  pack2
  passing-the-hash
  patator
  pdfcrack
  pipal
  polenum
  rainbowcrack
  rarcrack
  rcracki-mt
  rsmangler
  samdump2
  seclists
  sipcrack
  sipvicious
  smbmap
  sqldict
  statsprocessor
  sucrack
  thc-pptp-bruter
  truecrack
  twofi
  wordlists
)

# These packages depend on all the post exploitation tools
pen_package_post_exploitation=(
  backdoor-factory
  cymothoa
  dbd
  dns2tcp
  exe2hexbat
  iodine
  laudanum
  mimikatz
  miredo
  nishang
  powersploit
  proxychains4
  proxytunnel
  ptunnel
  pwnat
  sbd
  shellter
  sslh
  stunnel4
  udptunnel
  veil
  webacoo
  weevely
)

# These packages depend on the 10 most important applications
pen_package_top10=(
  aircrack-ng
  burpsuite
  crackmapexec
  hydra
  john
  metasploit-framework
  nmap
  responder
  sqlmap
  wireshark
)

# These packages depend on all the Windows resources
pen_package_windows_resources=(
  dbd
  dnschef
  heartleech
  hyperion
  mimikatz
  ncat-w32
  ollydbg
  powercat
  regripper
  sbd
  secure-socket-funneling-windows-binaries
  shellter
  tftpd32
  wce
  windows-binaries
  windows-privesc-check
)

# Other potential packages for installation
#pen_package_bluetooth
#pen_package_802-11
#pen_package_rfid
#pen_package_sdr
#pen_package_sniffing-spoofing
#pen_package_social-engineering
#pen_package_wireless

# Installation of main components
printf "\n%s - Installing pentesting packages.... \n"

for PKG1 in "${pen_package_core[@]}" "${pen_package_headless[@]}" "${pen_package_firmware[@]}" "${pen_package_passwords[@]}" "${pen_package_post_exploitation[@]}" "${pen_package_respond[@]}" "${pen_package_top10[@]}" "${pen_package_windows_resources[@]}" "${pen_package_exploitation[@]}" "${pen_package_information_gathering[@]}"; do
  sudo apt install -y "$PKG1"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

# idk which (meta)package installs these browsers so I uninstall it manually
sudo apt purge -y chromium chromium-common chromium-sandbox firefox-esr

clear
