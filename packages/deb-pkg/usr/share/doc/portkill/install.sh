#!/bin/bash

# PortKill Installation Script
# Copyright (c) 2025 Abraham Esandayinze Tanta

set -e

VERSION="3.1.1"
REPO_URL="https://github.com/mr-tanta/portkill"
PREFIX="/usr/local"
INSTALL_DIR="$PREFIX/bin"
SCRIPT_NAME="portkill"
REQUESTED_VERSION="latest"

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

show_usage() {
    cat << EOF
Usage: install.sh [VERSION] [OPTIONS]

Arguments:
  VERSION              Version tag to install (for example: v3.1.1 or 3.1.1)

Options:
  --prefix=PATH        Install under PATH/bin (default: /usr/local)
  --prefix PATH        Install under PATH/bin
  --help, -h           Show this help
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_usage
                exit 0
                ;;
            --prefix=*)
                PREFIX="${1#--prefix=}"
                INSTALL_DIR="$PREFIX/bin"
                shift
                ;;
            --prefix)
                shift
                if [[ $# -eq 0 || -z "$1" ]]; then
                    print_colored "$RED" "Error: --prefix requires a path"
                    exit 1
                fi
                PREFIX="$1"
                INSTALL_DIR="$PREFIX/bin"
                shift
                ;;
            v[0-9]*|[0-9]*)
                REQUESTED_VERSION="$1"
                shift
                ;;
            *)
                print_colored "$RED" "Error: Unknown argument: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

check_os() {
    if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux"* ]]; then
        print_colored "$RED" "Error: PortKill requires macOS or Linux"
        exit 1
    fi
}

check_dependencies() {
    local missing_deps=()
    
    for cmd in ps kill; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_colored "$RED" "Error: Missing required dependencies: ${missing_deps[*]}"
        print_colored "$YELLOW" "Please install missing dependencies and try again"
        exit 1
    fi

    if ! command -v lsof &> /dev/null && \
       ! command -v ss &> /dev/null && \
       ! command -v netstat &> /dev/null && \
       ! command -v fuser &> /dev/null; then
        print_colored "$RED" "Error: Missing a port detection tool (install lsof, iproute2/ss, netstat, or fuser)"
        exit 1
    fi
}

download_portkill() {
    local temp_dir; temp_dir=$(mktemp -d)
    local script_url

    if [[ "$REQUESTED_VERSION" == "latest" ]]; then
        script_url="$REPO_URL/releases/latest/download/portkill"
    else
        local tag="$REQUESTED_VERSION"
        [[ "$tag" == v* ]] || tag="v$tag"
        script_url="$REPO_URL/releases/download/$tag/portkill"
    fi
    
    print_colored "$BLUE" "Downloading PortKill ($REQUESTED_VERSION) from GitHub..."
    
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
    
    if [[ ! -d "$INSTALL_DIR" ]]; then
        if mkdir -p "$INSTALL_DIR" 2>/dev/null; then
            true
        else
            print_colored "$YELLOW" "Root access required to create $INSTALL_DIR"
            sudo mkdir -p "$INSTALL_DIR"
        fi
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
    local installed_binary="$INSTALL_DIR/$SCRIPT_NAME"

    if [[ -x "$installed_binary" ]]; then
        local installed_version; installed_version=$("$installed_binary" --version 2>/dev/null | head -1 | awk '{print $2}')
        print_colored "$GREEN" "PortKill v$installed_version installed successfully!"
        if ! command -v "$SCRIPT_NAME" &> /dev/null; then
            print_colored "$YELLOW" "Note: $INSTALL_DIR is not currently in PATH"
        fi
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
    parse_args "$@"
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
