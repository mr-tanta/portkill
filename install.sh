#!/bin/bash

# PortKill Installation Script
# Copyright (c) 2025 Abraham Esandayinze Tanta

set -e

VERSION="3.1.0"
REPO_URL="https://github.com/mr-tanta/portkill"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="portkill"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_colored() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}" >&2
}

print_header() {
    echo
    print_colored "$BLUE" "PortKill Installer v$VERSION"
    print_colored "$BLUE" "================================"
    echo
}

check_os() {
    if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux"* ]]; then
        print_colored "$RED" "Error: PortKill requires macOS or Linux"
        exit 1
    fi
}

check_dependencies() {
    local missing_deps=()
    
    for cmd in lsof ps kill; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_colored "$RED" "Error: Missing required dependencies: ${missing_deps[*]}"
        print_colored "$YELLOW" "Please install missing dependencies and try again"
        exit 1
    fi
}

download_portkill() {
    local temp_dir; temp_dir=$(mktemp -d)
    local script_url="$REPO_URL/raw/main/bin/portkill"
    
    print_colored "$BLUE" "Downloading PortKill from GitHub..."
    
    if command -v curl &> /dev/null; then
        if curl -sSL "$script_url" -o "$temp_dir/portkill" 2>/dev/null; then
            print_colored "$GREEN" "Download complete"
        else
            print_colored "$RED" "Error: Failed to download PortKill"
            rm -rf "$temp_dir"
            exit 1
        fi
    elif command -v wget &> /dev/null; then
        if wget -qO "$temp_dir/portkill" "$script_url" 2>/dev/null; then
            print_colored "$GREEN" "Download complete"
        else
            print_colored "$RED" "Error: Failed to download PortKill"
            rm -rf "$temp_dir"
            exit 1
        fi
    else
        print_colored "$RED" "Error: curl or wget is required for installation"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    echo "$temp_dir"
}

install_portkill() {
    local source_dir=$1
    local script_path="$source_dir/portkill"
    
    if [[ ! -f "$script_path" ]]; then
        print_colored "$RED" "Error: Script not found at $script_path"
        exit 1
    fi
    
    if [[ ! -w "$INSTALL_DIR" ]]; then
        print_colored "$YELLOW" "Root access required for installation to $INSTALL_DIR"
        sudo cp "$script_path" "$INSTALL_DIR/$SCRIPT_NAME"
        sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    else
        cp "$script_path" "$INSTALL_DIR/$SCRIPT_NAME"
        chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    # Clean up temp directory
    rm -rf "$source_dir"
}

verify_installation() {
    if command -v "$SCRIPT_NAME" &> /dev/null; then
        local installed_version; installed_version=$($SCRIPT_NAME --version 2>/dev/null | head -1 | awk '{print $2}')
        print_colored "$GREEN" "PortKill v$installed_version installed successfully!"
        echo
        print_colored "$BLUE" "Usage:"
        echo "  portkill list 3000      # List processes on port 3000"
        echo "  portkill kill 3000      # Kill process on port 3000"
        echo "  portkill menu           # Interactive mode"
        echo "  portkill --help         # Show help"
        echo
    else
        print_colored "$RED" "Error: Installation verification failed"
        exit 1
    fi
}

main() {
    print_header
    
    # Check OS compatibility
    check_os
    
    # Check dependencies
    print_colored "$BLUE" "Checking dependencies..."
    check_dependencies
    print_colored "$GREEN" "All dependencies satisfied"
    
    # Download PortKill
    temp_dir=$(download_portkill)
    
    # Install
    print_colored "$BLUE" "Installing to $INSTALL_DIR..."
    install_portkill "$temp_dir"
    
    # Verify
    verify_installation
    
    print_colored "$GREEN" "Installation complete!"
}

# Handle interrupts
trap 'echo; print_colored "$YELLOW" "Installation cancelled"; exit 130' INT

# Run installation
main "$@"