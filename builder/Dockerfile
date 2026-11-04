# Build environment for the ISO. Used by build-in-docker.sh and CI.
ARG DEBIAN_SUITE=trixie
FROM debian:${DEBIAN_SUITE}

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      live-build debootstrap ca-certificates \
      squashfs-tools xorriso mtools dosfstools \
      isolinux syslinux-common grub-efi-amd64-bin grub-pc-bin \
 && rm -rf /var/lib/apt/lists/*
