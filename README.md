## Fresh [Debian Trixie](https://www.debian.org/devel/debian-installer/) (Testing) Install
If the Debian Trixie installation fails, resort to installing [Debian Bookworm](https://www.debian.org/releases/bookworm/debian-installer/) netinst CD image and later update to Debian Trixie.
### Sudoers permissions
Login as root and install `sudo`:
```bash
su -
apt install sudo vim git zram-tools
/usr/sbin/usermod -aG sudo twilight
```
Add myself to sudoers file: `vim /etc/sudoers`:
```bash
# Allow members of group sudo to execute any command
%sudo      ALL=(ALL:ALL) NOPASSWD: ALL
```
### Zram swap
Edit zramswap file: `sudo vim /etc/default/zramswap`:
```bash
ALGO=lz4
PERCENT=25
```

## Running the installer script
Check if you're on debian trixie:
```bash
lsb_release -a
cat /etc/os-release
```
If you're on bookworm, update to debian trixie.
You also need to uncomment the lines with `deb-src` if they're commented out.
```bash
sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
```
Update changes and reboot:
```bash
sudo apt update
sudo apt upgrade
sudo reboot
```
Execute the `install.sh` script:
```bash
git clone --depth=1 https://github.com/Twilight4/debian-setup.git
cd debian-setup
./install.sh
```

## Post-Install (Optional)
### Enable kali repositories (needed for `install-pen-pkgs.sh`)
Edit apt repositories: `sudo vim /etc/apt/sources.list`
```bash
# See https://www.kali.org/docs/general-use/kali-linux-sources-list-repositories/
deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware
```
Add Kali GPG Key:
```bash
wget -q -O - https://archive.kali.org/archive-key.asc | sudo apt-key add -
```
Update changes:
```bash
sudo apt update
sudo apt upgrade
```
