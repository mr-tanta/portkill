#!/bin/bash

# PortKill Package Builder Script
# Creates .deb and .rpm packages for distribution

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get version from git tag or default
get_version() {
    if git describe --tags --exact-match HEAD 2>/dev/null; then
        git describe --tags --exact-match HEAD | sed 's/^v//'
    elif git describe --tags HEAD 2>/dev/null; then
        git describe --tags HEAD | sed 's/^v//' | sed 's/-.*$//'
    else
        echo "3.1.1"
    fi
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    if ! command -v dpkg-deb &> /dev/null; then
        missing_deps+=("dpkg-dev")
    fi
    
    if ! command -v rpmbuild &> /dev/null; then
        missing_deps+=("rpm-build")
    fi
    
    if ! command -v fakeroot &> /dev/null; then
        missing_deps+=("fakeroot")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_status "On Ubuntu/Debian: sudo apt-get install dpkg-dev rpm fakeroot"
        print_status "On RHEL/Fedora: sudo dnf install dpkg-dev rpm-build fakeroot"
        exit 1
    fi
}

# Build Debian package
build_deb() {
    local version="$1"
    
    print_status "Building Debian package..."
    
    local deb_dir="$BUILD_DIR/portkill-deb"
    rm -rf "$deb_dir"
    
    # Create directory structure
    mkdir -p "$deb_dir/usr/bin"
    mkdir -p "$deb_dir/etc/portkill"
    mkdir -p "$deb_dir/usr/share/doc/portkill"
    mkdir -p "$deb_dir/DEBIAN"
    
    # Copy files
    cp "$PROJECT_DIR/bin/portkill" "$deb_dir/usr/bin/portkill"
    cp "$PROJECT_DIR/portkill.conf" "$deb_dir/etc/portkill/portkill.conf"
    cp "$PROJECT_DIR/README.md" "$deb_dir/usr/share/doc/portkill/"
    cp "$PROJECT_DIR/CONTRIBUTING.md" "$deb_dir/usr/share/doc/portkill/"
    cp "$PROJECT_DIR/LICENSE" "$deb_dir/usr/share/doc/portkill/"
    cp "$PROJECT_DIR/install.sh" "$deb_dir/usr/share/doc/portkill/"
    cp "$PROJECT_DIR/uninstall.sh" "$deb_dir/usr/share/doc/portkill/"
    
    # Copy control files
    cp "$PROJECT_DIR/packaging/debian/DEBIAN/"* "$deb_dir/DEBIAN/"
    
    # Update version in control file
    sed -i "s/Version: .*/Version: ${version}-1/" "$deb_dir/DEBIAN/control"
    
    # Set permissions
    chmod 755 "$deb_dir/usr/bin/portkill"
    chmod 755 "$deb_dir/DEBIAN/postinst" "$deb_dir/DEBIAN/prerm"
    
    # Build package
    local deb_file="$BUILD_DIR/portkill_${version}-1_all.deb"
    fakeroot dpkg-deb --build "$deb_dir" "$deb_file"
    
    print_success "Debian package created: $deb_file"
    return 0
}

# Build RPM package
build_rpm() {
    local version="$1"
    
    print_status "Building RPM package..."
    
    # Setup RPM build environment
    local rpm_root="$BUILD_DIR/rpmbuild"
    mkdir -p "$rpm_root"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
    
    # Create source tarball
    local src_dir="$BUILD_DIR/portkill-${version}"
    mkdir -p "$src_dir"
    cp -r "$PROJECT_DIR/bin" "$PROJECT_DIR/portkill.conf" "$PROJECT_DIR/README.md" \
          "$PROJECT_DIR/CONTRIBUTING.md" "$PROJECT_DIR/LICENSE" \
          "$PROJECT_DIR/install.sh" "$PROJECT_DIR/uninstall.sh" "$src_dir/"
    
    tar -czf "$rpm_root/SOURCES/v${version}.tar.gz" -C "$BUILD_DIR" "portkill-${version}"
    
    # Copy and update spec file
    cp "$PROJECT_DIR/packaging/rpm/portkill.spec" "$rpm_root/SPECS/"
    sed -i "s/Version: .*/Version: ${version}/" "$rpm_root/SPECS/portkill.spec"
    
    # Build RPM
    rpmbuild --define "_topdir $rpm_root" -ba "$rpm_root/SPECS/portkill.spec"
    
    # Copy built RPM
    local rpm_file="$BUILD_DIR/portkill-${version}-1.noarch.rpm"
    cp "$rpm_root/RPMS/noarch/portkill-${version}"-1.*.rpm "$rpm_file"
    
    print_success "RPM package created: $rpm_file"
    return 0
}

# Generate checksums
generate_checksums() {
    local version="$1"
    
    print_status "Generating checksums..."
    
    cd "$BUILD_DIR"
    
    local deb_file="portkill_${version}-1_all.deb"
    local rpm_file="portkill-${version}-1.noarch.rpm"
    
    if [[ -f "$deb_file" ]]; then
        sha256sum "$deb_file" > "${deb_file}.sha256"
    fi
    
    if [[ -f "$rpm_file" ]]; then
        sha256sum "$rpm_file" > "${rpm_file}.sha256"
    fi
    
    # Create combined checksums file
    cat > checksums.txt << EOF
# PortKill v${version} Package Checksums

## Debian Package
$(cat ${deb_file}.sha256 2>/dev/null || echo "N/A")

## RPM Package
$(cat ${rpm_file}.sha256 2>/dev/null || echo "N/A")
EOF
    
    print_success "Checksums generated"
}

# Main function
main() {
    cd "$PROJECT_DIR"
    
    print_status "PortKill Package Builder"
    print_status "========================"
    
    # Get version
    local version
    version=$(get_version)
    print_status "Building packages for version: $version"
    
    # Check dependencies
    check_dependencies
    
    # Create build directory
    mkdir -p "$BUILD_DIR"
    
    # Build packages
    local build_deb=true
    local build_rpm=true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --deb-only)
                build_rpm=false
                shift
                ;;
            --rpm-only)
                build_deb=false
                shift
                ;;
            --version)
                version="$2"
                shift 2
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --deb-only    Build only Debian package"
                echo "  --rpm-only    Build only RPM package"
                echo "  --version V   Override version number"
                echo "  --help, -h    Show this help"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Build packages
    if [[ "$build_deb" == true ]]; then
        build_deb "$version" || exit 1
    fi
    
    if [[ "$build_rpm" == true ]]; then
        build_rpm "$version" || exit 1
    fi
    
    # Generate checksums
    generate_checksums "$version"
    
    # Summary
    echo
    print_success "Package build completed!"
    print_status "Built packages in: $BUILD_DIR"
    ls -la "$BUILD_DIR"/*.{deb,rpm} 2>/dev/null || true
    
    echo
    print_status "Installation commands:"
    if [[ "$build_deb" == true ]]; then
        echo "  Debian/Ubuntu: sudo dpkg -i $BUILD_DIR/portkill_${version}-1_all.deb"
    fi
    if [[ "$build_rpm" == true ]]; then
        echo "  RPM-based:     sudo rpm -i $BUILD_DIR/portkill-${version}-1.noarch.rpm"
    fi
}

# Run main function with all arguments
main "$@"
