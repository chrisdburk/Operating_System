#!/usr/bin/env bash
# =============================================================================
#  build.sh — build the live/installable ISO image.
#
#  Usage:  sudo ./build.sh [build|config|clean|help]
#
#    build   (default) prepare the build tree and produce out/<id>-<ver>-<arch>.iso
#    config  only prepare the build tree in build/ (handy for inspecting)
#    clean   remove build/ (keeps out/)
#
#  Requires a Debian (or Debian-based) host with live-build installed, run as
#  root. On any other system use ./build-in-docker.sh instead.
# =============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=os.conf
source "$ROOT/os.conf"

BUILD_DIR="${BUILD_DIR:-$ROOT/build}"
OUT_DIR="${OUT_DIR:-$ROOT/out}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

usage() { sed -n '3,13p' "$0" | sed 's/^#  \{0,1\}//'; }

check_host() {
    [[ $EUID -eq 0 ]] || die "live-build must run as root (try: sudo $0 $*)"
    command -v lb >/dev/null || die "live-build is not installed (apt install live-build), or use ./build-in-docker.sh"
    [[ $OS_ID =~ ^[a-z0-9-]+$ ]] || die "OS_ID in os.conf may only contain lowercase letters, digits and dashes"
}

# Replace @TOKENS@ in file contents and __OS_ID__ in file names.
render_templates() {
    local dir=$1
    log "Applying branding from os.conf"
    grep -rlI '@\(OS_[A-Z]*\|DEBIAN_SUITE\)@' "$dir" | while read -r f; do
        sed -i \
            -e "s|@OS_NAME@|${OS_NAME}|g" \
            -e "s|@OS_ID@|${OS_ID}|g" \
            -e "s|@OS_VERSION@|${OS_VERSION}|g" \
            -e "s|@OS_HOMEPAGE@|${OS_HOMEPAGE}|g" \
            -e "s|@DEBIAN_SUITE@|${DEBIAN_SUITE}|g" \
            "$f"
    done
    find "$dir" -depth -name '*__OS_ID__*' | while read -r p; do
        mv "$p" "$(dirname "$p")/$(basename "$p" | sed "s/__OS_ID__/${OS_ID}/g")"
    done
}

prepare() {
    log "Preparing build tree in $BUILD_DIR"
    if [[ -d $BUILD_DIR ]]; then
        (cd "$BUILD_DIR" && lb clean --purge >/dev/null 2>&1) || true
        rm -rf "$BUILD_DIR"
    fi
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"

    # Generate the base live-build configuration. Every option here is
    # documented in `man lb_config`.
    lb config \
        --mode debian \
        --distribution "$DEBIAN_SUITE" \
        --architectures "$ARCH" \
        --archive-areas "main contrib non-free non-free-firmware" \
        --mirror-bootstrap "$DEBIAN_MIRROR" \
        --mirror-chroot "$DEBIAN_MIRROR" \
        --mirror-binary "$DEBIAN_MIRROR" \
        --security true \
        --updates true \
        --apt-recommends true \
        --firmware-binary true \
        --firmware-chroot true \
        --debian-installer none \
        --bootloaders "grub-efi,syslinux" \
        --uefi-secure-boot enable \
        --binary-images iso-hybrid \
        --memtest none \
        --image-name "$OS_ID" \
        --iso-application "$OS_NAME" \
        --iso-publisher "$OS_NAME project; $OS_HOMEPAGE" \
        --iso-volume "${OS_NAME} ${OS_VERSION}" \
        --bootappend-live "boot=live components quiet username=live hostname=${OS_ID} locales=en_US.UTF-8 keyboard-layouts=us"

    # Overlay our own package lists, hooks and files on top.
    cp -a "$ROOT/config/." config/

    # Ship the user guide inside the OS so the welcome app can show it.
    install -Dm644 "$ROOT/docs/SWITCHING-FROM-WINDOWS.md" \
        "config/includes.chroot/usr/share/doc/__OS_ID__/SWITCHING-FROM-WINDOWS.md"

    render_templates "$BUILD_DIR/config"
}

build() {
    prepare
    cd "$BUILD_DIR"
    log "Running live-build (this takes a while: 20-60 minutes, ~10 GB disk)"
    lb build 2>&1 | tee "$BUILD_DIR/build.log"

    local iso
    iso=$(find "$BUILD_DIR" -maxdepth 1 -name '*.iso' | head -n1)
    [[ -n $iso ]] || die "No ISO produced; see $BUILD_DIR/build.log"

    mkdir -p "$OUT_DIR"
    local final="$OUT_DIR/${OS_ID}-${OS_VERSION}-${ARCH}.iso"
    mv "$iso" "$final"
    (cd "$OUT_DIR" && sha256sum "$(basename "$final")" > "$(basename "$final").sha256")
    log "Done: $final"
}

clean() {
    if [[ -d $BUILD_DIR ]]; then
        (cd "$BUILD_DIR" && lb clean --purge) || true
        rm -rf "$BUILD_DIR"
    fi
    log "Cleaned"
}

case "${1:-build}" in
    build)  check_host "$@"; build ;;
    config) check_host "$@"; prepare; log "Build tree ready in $BUILD_DIR" ;;
    clean)  check_host "$@"; clean ;;
    help|-h|--help) usage ;;
    *) usage; exit 1 ;;
esac
