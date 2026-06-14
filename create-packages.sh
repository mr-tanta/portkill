#!/bin/bash

# Simple package creator for manual upload
set -e

VERSION="3.1.1"
BUILD_DIR="./packages"

echo "Creating packages for PortKill v${VERSION}..."

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Create simple directory structures for packages
echo "Setting up package structures..."

# Debian package structure
mkdir -p "deb-pkg/usr/bin"
mkdir -p "deb-pkg/etc/portkill" 
mkdir -p "deb-pkg/usr/share/doc/portkill"
mkdir -p "deb-pkg/DEBIAN"

# Copy files
cp "../bin/portkill" "deb-pkg/usr/bin/portkill"
cp "../portkill.conf" "deb-pkg/etc/portkill/portkill.conf"
cp "../README.md" "../CONTRIBUTING.md" "../LICENSE" "deb-pkg/usr/share/doc/portkill/"
cp "../install.sh" "../uninstall.sh" "deb-pkg/usr/share/doc/portkill/"
cp "../packaging/debian/DEBIAN/control" "deb-pkg/DEBIAN/"
cp "../packaging/debian/DEBIAN/postinst" "deb-pkg/DEBIAN/"
cp "../packaging/debian/DEBIAN/prerm" "deb-pkg/DEBIAN/"

# Set permissions
chmod 755 "deb-pkg/usr/bin/portkill"
chmod 755 "deb-pkg/DEBIAN/postinst" 
chmod 755 "deb-pkg/DEBIAN/prerm"

echo "Package structure created successfully!"
echo "Files available in: $BUILD_DIR"
echo ""
echo "To upload to release, use:"
echo "gh release upload v${VERSION} \${BUILD_DIR}/*.deb \${BUILD_DIR}/*.rpm"