# PortKill Package Files

This directory contains packaging metadata for AUR, Debian, and RPM-based distributions.

## Package Types

### Arch Linux (AUR)

- Directory: `aur/`
- Files: `PKGBUILD`, `.SRCINFO`
- Install: `yay -S portkill` or `paru -S portkill`

### Debian/Ubuntu (.deb)

- Directory: `debian/`
- Files: `DEBIAN/control`, `DEBIAN/postinst`, `DEBIAN/prerm`
- Install: `sudo dpkg -i portkill_3.2.0-1_all.deb`

### RPM-based (.rpm)

- Directory: `rpm/`
- Files: `portkill.spec`
- Install: `sudo rpm -i portkill-3.2.0-1.noarch.rpm`

## Build Packages

```bash
# Build all packages
./scripts/build-packages.sh

# Build only one format
./scripts/build-packages.sh --deb-only
./scripts/build-packages.sh --rpm-only

# Override version
./scripts/build-packages.sh --version 3.2.0
```

Manual build dependencies:

```bash
# Ubuntu/Debian
sudo apt-get install build-essential fakeroot dpkg-dev rpm lintian

# Fedora/RHEL
sudo dnf install rpm-build rpmdevtools dpkg fakeroot
```

## Runtime Dependencies

Required:

- Bash 3.2+
- `coreutils`
- `procps`/`procps-ng`
- At least one detector: `iproute2`/`iproute` for `ss`, `lsof`, `net-tools`, or `psmisc`

Recommended:

- `bc`
- `netcat`/`nmap-ncat`
- `lsof`
- `psmisc`
- Docker CLI for `--docker`

## Installation Layout

```text
/usr/bin/portkill
/etc/portkill/portkill.conf
/usr/share/doc/portkill/
├── README.md
├── CONTRIBUTING.md
├── LICENSE
├── install.sh
└── uninstall.sh
```

PortKill writes user logs and history under `~/.portkill/`. Packages do not terminate user-managed PortKill commands during uninstall.

## Release Maintenance

When releasing a new version:

1. Update version numbers in package metadata.
2. Create the GitHub release/tag.
3. Replace AUR and Homebrew checksums with the checksum for the released GitHub tarball.
4. Run package builds and upload `.deb`/`.rpm` assets to the release.
5. Publish the Homebrew tap and AUR updates.

AUR publishing:

```bash
git clone ssh://aur@aur.archlinux.org/portkill.git portkill-aur
cp packaging/aur/PKGBUILD portkill-aur/
cd portkill-aur
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "Update portkill"
git push
```

## Package Testing

```bash
# Debian
./scripts/build-packages.sh --deb-only
sudo dpkg -i build/portkill_*_all.deb
portkill --version
dpkg -L portkill
sudo dpkg -r portkill

# RPM
./scripts/build-packages.sh --rpm-only
sudo rpm -i build/portkill-*.noarch.rpm
portkill --version
rpm -ql portkill
sudo rpm -e portkill
```
