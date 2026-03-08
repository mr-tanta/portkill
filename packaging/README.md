# PortKill Package Files

This directory contains packaging configurations for distributing PortKill across different package managers and Linux distributions.

## Package Types

### 📦 Arch Linux (AUR)
- **Directory**: `aur/`
- **Files**: `PKGBUILD`
- **Installation**: `yay -S portkill` or `paru -S portkill`
- **Maintainer**: Community-maintained through AUR

### 📦 Debian/Ubuntu (.deb)
- **Directory**: `debian/`
- **Files**: `DEBIAN/control`, `DEBIAN/postinst`, `DEBIAN/prerm`
- **Installation**: `sudo dpkg -i portkill_2.3.0-1_all.deb`
- **Compatible**: Ubuntu 18.04+, Debian 9+

### 📦 RPM-based (.rpm)
- **Directory**: `rpm/`
- **Files**: `portkill.spec`
- **Installation**: `sudo rpm -i portkill-2.3.0-1.noarch.rpm`
- **Compatible**: RHEL/CentOS 7+, Fedora 28+, openSUSE

## Building Packages

### Automated Building (GitHub Actions)
Packages are automatically built on every release through GitHub Actions:
- **Workflow**: `.github/workflows/package-build.yml`
- **Triggers**: Release creation, tag pushes
- **Artifacts**: Uploaded to GitHub Releases

### Manual Building
Use the provided build script:

```bash
# Build all packages
./scripts/build-packages.sh

# Build only .deb package
./scripts/build-packages.sh --deb-only

# Build only .rpm package
./scripts/build-packages.sh --rpm-only

# Build with custom version
./scripts/build-packages.sh --version 3.1.0
```

### Prerequisites for Manual Building

#### Ubuntu/Debian
```bash
sudo apt-get install build-essential fakeroot dpkg-dev rpm lintian
```

#### RHEL/Fedora
```bash
sudo dnf install rpm-build rpmdevtools dpkg fakeroot
```

## Package Details

### Dependencies
- **Required**: `bash`, `coreutils`, `util-linux`, `procps`
- **Recommended**: `bc`, `netcat`/`nmap-ncat`, `lsof`, `iproute2`

### Installation Layout
```
/usr/bin/portkill                    # Main executable
/etc/portkill/portkill.conf         # Configuration file
/usr/share/doc/portkill/            # Documentation
├── README.md
├── CONTRIBUTING.md
├── LICENSE
├── install.sh
└── uninstall.sh
/var/log/portkill/                  # Log directory (created on install)
```

### Post-Install Actions
- Creates `/etc/portkill/` configuration directory
- Creates `/var/log/portkill/` log directory
- Sets proper file permissions
- Displays installation success message

### Pre-Removal Actions
- Stops any running PortKill processes
- Preserves user configuration and logs

## Package Maintenance

### Version Updates
When releasing new versions:
1. Update version numbers in:
   - `aur/PKGBUILD` (`pkgver=`)
   - `debian/DEBIAN/control` (`Version:`)
   - `rpm/portkill.spec` (`Version:`)
   - `scripts/build-packages.sh` (default version)

2. Update changelog in `rpm/portkill.spec`

3. Test package building locally:
   ```bash
   ./scripts/build-packages.sh --version NEW_VERSION
   ```

### AUR Publishing
1. Clone the AUR repository:
   ```bash
   git clone ssh://aur@aur.archlinux.org/portkill.git portkill-aur
   ```

2. Copy updated PKGBUILD:
   ```bash
   cp packaging/aur/PKGBUILD portkill-aur/
   ```

3. Generate .SRCINFO:
   ```bash
   cd portkill-aur
   makepkg --printsrcinfo > .SRCINFO
   ```

4. Commit and push:
   ```bash
   git add .
   git commit -m "Update to version X.Y.Z"
   git push
   ```

## Testing Packages

### Debian Package Testing
```bash
# Build and test
./scripts/build-packages.sh --deb-only
sudo dpkg -i build/portkill_*_all.deb

# Test installation
portkill --version
portkill --help

# Verify files
dpkg -L portkill

# Remove for testing
sudo dpkg -r portkill
```

### RPM Package Testing
```bash
# Build and test
./scripts/build-packages.sh --rpm-only
sudo rpm -i build/portkill-*.noarch.rpm

# Test installation
portkill --version

# Verify files
rpm -ql portkill

# Remove for testing
sudo rpm -e portkill
```

## Troubleshooting

### Common Build Issues
- **Missing dependencies**: Install build tools and packaging utilities
- **Permission errors**: Use `fakeroot` or run build script as regular user
- **Version conflicts**: Ensure version consistency across all package files

### Package Installation Issues
- **Dependency problems**: Install missing dependencies manually
- **Conflicts**: Remove existing installations before installing new packages
- **Permission issues**: Run installation commands with `sudo`

## Contributing

When adding support for new package managers:
1. Create appropriate directory structure
2. Add package configuration files
3. Update build scripts and GitHub Actions
4. Update this README with new instructions
5. Test thoroughly on target distributions