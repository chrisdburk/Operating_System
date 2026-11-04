# Architecture & design decisions

This document explains *why* the project is built the way it is, so future
contributors can challenge the choices with full context.

## Goals

1. **A soft landing for Windows users.** Familiar layout, hardware that works,
   apps that are easy to find, and no terminal needed for daily use.
2. **Tinkerable by anyone with more than a layman's knowledge.** The entire
   OS is defined by readable text files. No custom tooling that must be
   learned first.
3. **Sustainable for a small team.** Lean on large upstream projects for the
   hard parts (security updates, packaging, drivers). Keep our own layer thin.

## Base distribution: Debian stable

| Option        | Pros                                      | Cons                                  |
|---------------|-------------------------------------------|---------------------------------------|
| **Debian** ✅ | Very stable, community-run, huge archive, official `live-build` tool, security team | Packages are older between releases |
| Ubuntu        | Big user base, newer hardware enablement  | Snap pushed by Canonical; corporate direction |
| Fedora        | Newer software, strong tooling            | 13-month support cycle means frequent major upgrades |
| Arch          | Newest software, very tinkerable          | Rolling releases break more often; harder for beginners |

Debian is the best fit for "it just keeps working", and it is a common base for
derivatives. Newer desktop apps come through Flatpak (see below), which makes
up for Debian's older packages where users actually notice them.

Debian releases a new stable version about every two years and supports each one
for about five years (including LTS), so users get long support.

## Desktop: KDE Plasma 6

Plasma's default layout already matches Windows (panel at the bottom, launcher
in the bottom-left, tray in the bottom-right, minimise/maximise/close on the
right of the title bar). It is also the most configurable mainstream desktop,
which suits the tinkerer goal. GNOME and Cinnamon were considered. GNOME's
workflow is deliberately different from Windows. Cinnamon is a good
alternative and could be offered as a second "edition" later (see the roadmap).

## Installer: Calamares

Calamares is the graphical installer used by many distributions (KDE neon,
Manjaro, EndeavourOS, Debian's own live images). Debian packages a ready-made
configuration (`calamares-settings-debian`), which we use as-is for now. It
supports dual-boot next to Windows, full-disk encryption and UEFI/Secure Boot.

The classic Debian text installer is turned off (`--debian-installer none`)
to keep the experience simple.

## Apps: Debian packages + Flatpak/Flathub

- Core system and desktop come from **Debian packages**: stable, with security
  updates.
- End-user apps (Spotify, Discord, Steam, newer versions of GIMP, etc.)
  come from **Flathub**, shown inside Discover. They run sandboxed, update
  independently of the base system, and are often packaged by the app authors.

## Build system: live-build

`live-build` is Debian's official tool for making live ISOs. Its config is
a directory tree:

- `package-lists/*.list.chroot`: packages to install
- `hooks/normal/*.hook.chroot`: scripts run inside the new system during the build
- `includes.chroot/`: files copied verbatim into the system

We keep that tree in `config/`. `build.sh` runs `lb config` with our options,
overlays `config/`, applies the branding from `os.conf`, then runs `lb build`.
Anyone who knows live-build can work on this project right away, and anyone
who learns it here can use that knowledge elsewhere.

## Branding / identity

`os.conf` holds the name, id and version. During the build:

- `@OS_NAME@`, `@OS_ID@`, `@OS_VERSION@`, `@OS_HOMEPAGE@`, `@DEBIAN_SUITE@`
  inside files are replaced with the values from `os.conf`.
- `__OS_ID__` in file *names* is replaced with the id.

We deliberately **do not** change Debian's `/etc/os-release`, so tools that
check "is this Debian?" keep working. Our identity lives in
`/etc/<id>-release`.

## Security defaults

- Firewall (`ufw`) enabled: blocks incoming connections, allows outgoing.
  Plasma's firewall settings page manages it.
- `unattended-upgrades` installs security updates automatically every day.
- Secure Boot is supported via Debian's signed shim/GRUB/kernel.
- CPU microcode and `fwupd` (firmware updates) are included.

## Our own code

Kept small on purpose:

- `<id>-welcome`: first-login "getting started" menu (bash + kdialog)
- `<id>-update`: updates apt, Flatpak and firmware in one go

Both are plain scripts in `/usr/local/bin` so users can read and change them.
