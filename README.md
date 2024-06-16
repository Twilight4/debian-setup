## Installing Hyprland and dotfiles on [Debian 13 Trixie](https://www.debian.org/devel/debian-installer/) (Testing)
1. Update system
```bash
sudo apt update && sudo apt -y full-upgrade -y
```
2. Reboot
```bash
sudo reboot now
```
3. Make sure you're on debian trixie and edit `sources.list`
```bash
lsb_release -a
```
```bash
sudo vim /etc/apt/sources.list
```
- uncomment the lines with `deb-src`
4. Update source list
```bash
sudo apt update
```
5. Execute the `install.sh` script
```bash
git clone --depth=1 https://github.com/Twilight4/debian-setup.git
cd debian-setup
chmod +x install.sh
./install.sh
```

## Post-Install
### Sudoers file
Add myself to sudoers file: `sudo vim /etc/sudoers`
```bash
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
```

Make sure I'm in sudoers group
```bash
cat /etc/group | grep sudo
```
Add myself to sudoers group if I'm not already
```bash
sudo usermod -aG sudo "$(whoami)"
```

### Performance tweaks
```bash
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
echo "vm.swappiness=20" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_background_ratio=15" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_ratio=40" | sudo tee -a /etc/sysctl.conf
echo "vm.oom_dump_tasks=0" | sudo tee -a /etc/sysctl.conf
echo "vm.oom_kill_allocating_task=1" | sudo tee -a /etc/sysctl.conf
echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf
echo "kernel.split_lock_mitigate=0" | sudo tee /etc/sysctl.d/99-splitlock.conf
```

### GRUB menu tweaks
Edit GRUB config: `sudo vim /etc/default/grub`
```bash
# Add the following to the line, don't remove existing values
GRUB_CMDLINE_LINUX_DEFAULT="zswap.compressor=zstd zswap.max_pool_percent=10 mitigations=off amd_pstate=active"

# Disable GRUB menu
GRUB_TIMEOUT=0
```
Update GRUB
```bash
sudo update-grub
```

### Enable kali repositories
Add kali repo to `/etc/apt/sources.list` (needed for `install-pen-pkgs.sh`)
```bash
# See https://www.kali.org/docs/general-use/kali-linux-sources-list-repositories/
deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware
```
Add Kali GPG Key
```bash
wget -q -O - https://archive.kali.org/archive-key.asc | sudo apt-key add -
```

### Install [Twilight4/dotfiles](https://github.com/Twilight4/dotfiles)
```bash
git clone --depth 1 https://github.com/Twilight4/dotfiles.git
cd dotfiles
./install.sh
```
