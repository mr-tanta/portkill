#!/bin/bash

# PortKill AUR submission helper

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUR_DIR="${AUR_DIR:-$SCRIPT_DIR/../portkill-aur}"
PKGBUILD_SRC="$SCRIPT_DIR/packaging/aur/PKGBUILD"
SRCINFO_SRC="$SCRIPT_DIR/packaging/aur/.SRCINFO"

if [[ ! -f "$PKGBUILD_SRC" || ! -f "$SRCINFO_SRC" ]]; then
    echo "Error: packaging/aur/PKGBUILD and packaging/aur/.SRCINFO are required"
    exit 1
fi

pkgver=$(awk -F= '$1 == "pkgver" {print $2}' "$PKGBUILD_SRC")
sha256=$(awk -F"'" '/sha256sums=/ {print $2}' "$PKGBUILD_SRC")

echo "PortKill AUR Submission Helper"
echo "=============================="
echo "Package: portkill"
echo "Version: $pkgver"
echo "Checksum: $sha256"
echo

if [[ -e "$AUR_DIR" && ! -d "$AUR_DIR/.git" ]]; then
    echo "Error: $AUR_DIR exists but is not a git checkout"
    exit 1
fi

if [[ ! -d "$AUR_DIR" ]]; then
    git clone ssh://aur@aur.archlinux.org/portkill.git "$AUR_DIR"
fi

cp "$PKGBUILD_SRC" "$AUR_DIR/PKGBUILD"
cp "$SRCINFO_SRC" "$AUR_DIR/.SRCINFO"

cat > "$AUR_DIR/verify-aur-setup.sh" << EOF
#!/bin/bash
set -e

bash -n PKGBUILD
grep -q "$sha256" PKGBUILD
grep -q "pkgver = $pkgver" .SRCINFO

echo "AUR files are ready for portkill $pkgver"
echo "Review the diff, then run:"
echo "  git add PKGBUILD .SRCINFO"
echo "  git commit -m \"Update portkill to $pkgver\""
echo "  git push"
EOF

chmod +x "$AUR_DIR/verify-aur-setup.sh"

echo "Copied AUR files to: $AUR_DIR"
echo "Next:"
echo "  cd \"$AUR_DIR\""
echo "  git diff"
echo "  ./verify-aur-setup.sh"
