# Installation

PortKill supports Homebrew, AUR, the install script, and manual release assets.

## Homebrew

```bash
brew tap mr-tanta/portkill
brew install portkill
portkill --version
```

Upgrade or remove:

```bash
brew upgrade portkill
brew uninstall portkill
brew untap mr-tanta/portkill
```

## Arch Linux AUR

```bash
yay -S portkill
# or
paru -S portkill
```

## Install Script

```bash
# Latest release
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash

# Specific release
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash -s v3.1.1

# Custom prefix
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash -s -- --prefix=/opt/portkill
```

The script downloads the release asset from GitHub, installs it to `PREFIX/bin`, and verifies the installed binary directly. If the install directory is not in `PATH`, the installer prints a warning.

## Manual Release Asset

```bash
curl -L https://github.com/mr-tanta/portkill/releases/latest/download/portkill -o portkill
chmod +x portkill
sudo mv portkill /usr/local/bin/
portkill --version
```

## Debian and RPM Packages

Debian and RPM packages are built by the package workflow for releases. Use the `.deb` or `.rpm` assets on the GitHub release page when they are present.

## Requirements

Required:

- Bash 3.2+
- `ps`
- `kill`
- At least one port detector: `lsof`, `ss`, `netstat`, or `fuser`

Optional:

- `bc` for benchmark calculations
- `nc` or `telnet` for benchmarking
- Docker CLI for `--docker`

Common Linux installs:

```bash
# Debian/Ubuntu
sudo apt-get install lsof iproute2 psmisc bc netcat-openbsd

# Fedora/RHEL
sudo dnf install lsof iproute psmisc bc nmap-ncat

# Arch
sudo pacman -S lsof iproute2 psmisc bc openbsd-netcat
```

## Uninstall

```bash
# Script uninstall
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/uninstall.sh | bash

# Remove user config too
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/uninstall.sh | bash -s -- --remove-config

# Homebrew
brew uninstall portkill
brew untap mr-tanta/portkill

# AUR
sudo pacman -R portkill
```

Manual removal:

```bash
sudo rm -f /usr/local/bin/portkill
rm -rf ~/.portkill
```

## Verify

```bash
portkill --version
portkill --help
portkill list
portkill --dry-run 3000
```
