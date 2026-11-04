#!/usr/bin/env bash
# =============================================================================
#  build-in-docker.sh — build the ISO from any Linux host (Ubuntu, Fedora,
#  Arch...) or WSL2, using a Debian container. Only Docker is required.
#
#  Usage:  ./build-in-docker.sh [build|config|clean]
#
#  live-build needs to mount filesystems, so the container runs --privileged.
# =============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=os.conf
source "$ROOT/os.conf"

IMAGE="${OS_ID}-builder:${DEBIAN_SUITE}"
DOCKER="${DOCKER:-docker}"

"$DOCKER" build --build-arg "DEBIAN_SUITE=$DEBIAN_SUITE" -t "$IMAGE" "$ROOT/builder"

"$DOCKER" run --rm --privileged \
    -v "$ROOT:/src" \
    -w /src \
    "$IMAGE" ./build.sh "${1:-build}"
