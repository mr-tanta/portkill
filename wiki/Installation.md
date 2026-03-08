# Installation Guide

PortKill is designed to be easy to install with multiple options to suit different needs and environments.

## 🏆 Recommended: Homebrew (macOS)

The easiest way to install PortKill on macOS:

```bash
# Add the PortKill tap
brew tap mr-tanta/portkill

# Install PortKill
brew install portkill

# Verify installation
portkill --version
```

### Homebrew Management
```bash
# Update to latest version
brew upgrade portkill

# Uninstall if needed
brew uninstall portkill

# Remove tap (optional)
brew untap mr-tanta/portkill
```

## ## Quick Install Script (macOS & Linux)

One-line installation for both macOS and Linux:

```bash
# Install latest version
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash

# Install specific version
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash -s v3.1.0

# Install to custom location
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash -s - --prefix=/opt/portkill
```

### What the script does:
- Downloads the latest PortKill release
- Verifies checksums for security
- Installs to `/usr/local/bin` by default
- Makes the script executable
- Adds to system PATH

## 📦 Manual Installation

### From GitHub Releases

```bash
# Download latest release
wget https://github.com/mr-tanta/portkill/releases/latest/download/portkill

# Make executable
chmod +x portkill

# Move to system path
sudo mv portkill /usr/local/bin/

# Test installation
portkill --version
```

### From Source (Development)

For developers and contributors:

```bash
# Clone the repository
git clone https://github.com/mr-tanta/portkill.git
cd portkill

# Make executable
chmod +x bin/portkill

# Test locally
./bin/portkill --version

# Optional: Install system-wide
sudo cp bin/portkill /usr/local/bin/

# Optional: Create symlink for development
sudo ln -sf "$(pwd)/bin/portkill" /usr/local/bin/portkill
```

## 🐧 Linux Package Managers

### Arch Linux (AUR)
```bash
# Install from AUR
yay -S portkill
# or
paru -S portkill
```

### Ubuntu/Debian (.deb package)
```bash
# Download and install .deb package
wget https://github.com/mr-tanta/portkill/releases/latest/download/portkill_3.1.0-1_all.deb
sudo dpkg -i portkill_3.1.0-1_all.deb

# Fix dependencies if needed
sudo apt-get install -f
```

### Red Hat/CentOS/Fedora (.rpm package)
```bash
# Download and install .rpm package
wget https://github.com/mr-tanta/portkill/releases/latest/download/portkill-3.1.0-1.noarch.rpm
sudo rpm -ivh portkill-3.1.0-1.noarch.rpm

# Or use dnf/yum
sudo dnf install portkill-3.1.0-1.noarch.rpm
```

## 🔧 System Requirements

### Required
- **Shell**: Bash 4.0 or later
- **OS**: macOS 10.12+, Linux kernel 3.0+, or any Unix-like system
- **Core utilities**: `lsof`, `ps`, `kill`

### Optional / Recommended
- **bc**: For advanced benchmarking calculations
- **netcat**: For port connectivity checks
- **netstat**: For additional port listing capabilities
- **ss**: For socket statistics (modern replacement for netstat on Linux)
- **fuser**: For identifying processes using files or sockets
- **Docker**: For container management features
- **curl/wget**: For downloading updates

### Checking Requirements

```bash
# Check Bash version
bash --version

# Check required utilities
which lsof ps kill

# Check optional/recommended utilities
which bc netcat netstat ss fuser docker curl
```

## - Verification

After installation, verify PortKill is working correctly:

```bash
# Check version
portkill --version

# Test basic functionality
portkill list 3000

# Test help system
portkill --help

# Test with JSON output
portkill --json list 3000

# Test interactive menu
portkill menu
```

## 🔄 Updates

### Homebrew
```bash
brew upgrade portkill
```

### Manual Updates
```bash
# Re-run install script
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash

# Or download new release manually
wget https://github.com/mr-tanta/portkill/releases/latest/download/portkill -O /usr/local/bin/portkill
chmod +x /usr/local/bin/portkill
```

### Check for Updates
```bash
# Current version
portkill --version

# Check latest release on GitHub
curl -s https://api.github.com/repos/mr-tanta/portkill/releases/latest | grep '"tag_name"'
```

## 🗑️ Uninstallation

### Homebrew
```bash
brew uninstall portkill
brew untap mr-tanta/portkill
```

### Manual Removal
```bash
# Remove binary
sudo rm /usr/local/bin/portkill

# Remove any config (if exists)
rm -rf ~/.portkill

# Remove from PATH if manually added
# Edit ~/.bashrc, ~/.zshrc, etc. to remove any PATH additions
```

### Package Managers
```bash
# Debian/Ubuntu
sudo apt remove portkill

# Red Hat/CentOS/Fedora
sudo dnf remove portkill
# or
sudo rpm -e portkill

# Arch Linux
pacman -R portkill
# or
yay -R portkill
```

## 🚨 Troubleshooting Installation

### Common Issues

#### 1. Permission Denied
```bash
# Solution: Use sudo for system-wide installation
sudo mv portkill /usr/local/bin/
sudo chmod +x /usr/local/bin/portkill
```

#### 2. Command Not Found
```bash
# Check if installed location is in PATH
echo $PATH | grep -o '/usr/local/bin'

# Add to PATH if missing (add to ~/.bashrc or ~/.zshrc)
export PATH="/usr/local/bin:$PATH"
```

#### 3. Missing Dependencies
```bash
# macOS: Install Xcode Command Line Tools
xcode-select --install

# Linux: Install required packages
# Ubuntu/Debian
sudo apt-get install lsof psmisc net-tools

# CentOS/RHEL
sudo yum install lsof psmisc net-tools

# Arch Linux
sudo pacman -S lsof psmisc net-tools
```

#### 4. Old Version Cached
```bash
# Clear bash command cache
hash -r

# Or restart terminal
```

### Getting Help

If you encounter issues:

1. Check our [Troubleshooting Guide](Troubleshooting.md)
2. Search [existing issues](https://github.com/mr-tanta/portkill/issues)
3. Create a [new issue](https://github.com/mr-tanta/portkill/issues/new) with:
   - Your OS and version
   - Bash version (`bash --version`)
   - Installation method used
   - Error messages

---

**Next:** [Quick Start Guide](Quick-Start.md)