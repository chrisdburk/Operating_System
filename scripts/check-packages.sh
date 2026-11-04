#!/usr/bin/env bash
# =============================================================================
#  check-packages.sh — verify every package in config/package-lists exists in
#  the Debian release from os.conf, and list ALL unknown names at once.
#
#  A full ISO build stops at the first unknown package after ~5 minutes; this
#  check takes about a minute and reports every problem in one go.
#
#  Needs apt and the Debian archive keyring (any Debian system or the
#  debian:<suite> container). Does not need root and changes nothing on the
#  host: it uses a private temporary apt state directory.
#
#  Overridable for testing: CHECK_MIRROR, CHECK_SUITE, CHECK_COMPONENTS,
#  CHECK_SECURITY_MIRROR (set it empty to skip the security archive).
# =============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=os.conf
source "$ROOT/os.conf"

MIRROR="${CHECK_MIRROR:-$DEBIAN_MIRROR}"
SUITE="${CHECK_SUITE:-$DEBIAN_SUITE}"
COMPONENTS="${CHECK_COMPONENTS:-main contrib non-free non-free-firmware}"
SECURITY_MIRROR="${CHECK_SECURITY_MIRROR-http://security.debian.org/debian-security}"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/lists/partial" "$tmp/cache/archives/partial" "$tmp/preferences.d"
touch "$tmp/status"

{
    echo "deb $MIRROR $SUITE $COMPONENTS"
    echo "deb $MIRROR $SUITE-updates $COMPONENTS"
    if [[ -n $SECURITY_MIRROR ]]; then
        echo "deb $SECURITY_MIRROR $SUITE-security $COMPONENTS"
    fi
} > "$tmp/sources.list"

APT_OPTS=(
    -o "Dir::Etc::SourceList=$tmp/sources.list"
    -o "Dir::Etc::SourceParts=/dev/null"
    -o "Dir::Etc::PreferencesParts=$tmp/preferences.d"
    -o "Dir::State::Lists=$tmp/lists"
    -o "Dir::State::Status=$tmp/status"
    -o "Dir::Cache=$tmp/cache"
    -o "APT::Architecture=$ARCH"
    -o "APT::Architectures::=$ARCH"
    -o "Debug::NoLocking=1"
)

echo "==> Fetching package index for $SUITE ($COMPONENTS)"
apt-get "${APT_OPTS[@]}" -qq update

mapfile -t packages < <(
    sed -e 's/#.*//' -e 's/[[:space:]]//g' "$ROOT"/config/package-lists/*.list.chroot \
        | awk 'NF' | sort -u
)

# A package is installable if apt has a candidate version for it (a real
# package) or another package provides it (a virtual package). Note that
# `apt-cache show` is not enough: it succeeds silently for names that other
# packages merely mention.
has_candidate() {
    local c
    c=$(apt-cache "${APT_OPTS[@]}" policy "$1" 2>/dev/null | awk '/Candidate:/ {print $2}')
    [[ -n $c && $c != "(none)" ]]
}
has_provider() {
    apt-cache "${APT_OPTS[@]}" showpkg "$1" 2>/dev/null \
        | sed -n '/^Reverse Provides:/,$p' | tail -n +2 | grep -q .
}

missing=()
for pkg in "${packages[@]}"; do
    if ! has_candidate "$pkg" && ! has_provider "$pkg"; then
        missing+=("$pkg")
    fi
done

echo "==> Checked ${#packages[@]} packages"
if ((${#missing[@]})); then
    echo "Unknown in Debian $SUITE (look up the right name at https://packages.debian.org):"
    printf '  - %s\n' "${missing[@]}"
    exit 1
fi
echo "All package names are valid."
