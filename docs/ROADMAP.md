# Roadmap

## Milestone 0.1: Foundation ✅ (this commit)

- [x] Reproducible ISO build with live-build (native, Docker, GitHub Actions)
- [x] Debian 13 base, KDE Plasma 6, Calamares installer
- [x] Firmware, codecs, Office-compatible fonts, Flathub
- [x] Firewall on, automatic security updates
- [x] Welcome app and "Update Everything" helper
- [x] User guide for Windows switchers, tinkerer docs

## Milestone 0.2: First boot test & polish

- [ ] First successful build in CI; fix any package-name issues
- [ ] Test on real hardware (Intel/AMD/NVIDIA, laptops and desktops)
- [ ] Custom Calamares branding (logo, slideshow explaining the system)
- [ ] Custom boot menu (GRUB/syslinux) theme
- [ ] Default wallpaper and SDDM login theme
- [ ] Pick a final name and logo

## Milestone 0.3: Smoothing the Windows transition

- [ ] NVIDIA driver helper (detect the card and offer to install `nvidia-driver`)
- [ ] "Windows-style" vs "macOS-style" vs "Classic" layout picker in Welcome
- [ ] Pre-selected app bundles in Welcome (Gaming: Steam, Lutris; Creative:
      GIMP, Krita, Kdenlive; Office: Thunderbird, OnlyOffice)
- [ ] Migration helper: copy Documents/Pictures/Browser bookmarks from a
      Windows partition
- [ ] Translations of the Welcome app and guide

## Milestone 0.4: Proper packaging

- [ ] Move our scripts and defaults into a `<id>-desktop` `.deb` package with its own
      apt repository, so installed systems get our updates too
- [ ] Signed releases and checksums published on GitHub Releases
- [ ] Automated VM boot test in CI (QEMU + screenshot check)

## Later / ideas

- Second edition with Cinnamon for older/low-RAM PCs
- ARM64 build
- Website and community forum
