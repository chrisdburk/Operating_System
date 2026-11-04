# Waypoint OS

> **Waypoint** is a working name. Change it in one line of [`os.conf`](os.conf).

A free, open-source Linux operating system for **people leaving Windows**.
It's easy enough for everyday use and open enough for anyone to tinker with.

- **Familiar out of the box.** KDE Plasma desktop with a taskbar, a start menu
  and a system tray. Office documents open in LibreOffice and keep their
  layout. Music and video codecs come pre-installed. Wi-Fi and graphics
  firmware are included, so most hardware works right away.
- **Easy to install.** A graphical installer (Calamares) that can sit next to
  Windows (dual-boot) or replace it.
- **Easy to get apps.** The Discover app store, with Debian packages and
  thousands of apps from Flathub (Steam, Spotify, Discord, OBS, Chrome...).
- **Safe by default.** Firewall on, automatic security updates, Secure Boot
  support.
- **Built to be tinkered with.** The whole OS is defined by plain-text files
  in this repo: lists of packages, small shell scripts, and config files. No
  custom compilers or magic. If you can edit a text file, you can make your
  own spin.

## How it works

Waypoint is a **Debian 13 ("trixie") derivative**, built with Debian's official
[`live-build`](https://live-team.pages.debian.net/live-manual/) tool.
Running the build produces a single `.iso` file. Write it to a USB stick, boot
from it to try the system without changing your PC, then click **Install**.

```
os.conf                     ← name, version, Debian release (start here)
build.sh                    ← builds the ISO (wraps live-build)
build-in-docker.sh          ← same, but works on any Linux host / WSL2
config/
  package-lists/*.list.chroot   ← which software is included
  hooks/normal/*.hook.chroot    ← scripts run while building the system
  includes.chroot/              ← files copied as-is into the OS (/etc, /usr...)
docs/                       ← architecture, building, customising, roadmap
```

## Quick start: build the ISO

On any Linux machine with Docker (about 15 GB free disk, 30–60 minutes):

```bash
./build-in-docker.sh
```

On a Debian machine you can skip Docker:

```bash
sudo apt install live-build && sudo ./build.sh
```

The ISO ends up in `out/`. You can also build it on GitHub: go to
**Actions → Build ISO → Run workflow**.

Test it in a virtual machine (VirtualBox, GNOME Boxes, virt-manager) before
putting it on real hardware. Full details are in
[docs/BUILDING.md](docs/BUILDING.md).

## Documentation

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md): why Debian, KDE, Calamares and Flatpak
- [docs/BUILDING.md](docs/BUILDING.md): building, testing and writing the ISO to USB
- [docs/CUSTOMIZING.md](docs/CUSTOMIZING.md): the tinkerer's guide to making it your own
- [docs/SWITCHING-FROM-WINDOWS.md](docs/SWITCHING-FROM-WINDOWS.md): end-user guide (also shipped inside the OS)
- [docs/ROADMAP.md](docs/ROADMAP.md): what's done and what's next
- [CONTRIBUTING.md](CONTRIBUTING.md): how to help

## License

The build scripts and configuration in this repository are licensed under the
[GNU GPL v3 or later](LICENSE). The software included in the ISO keeps its own
licenses (mostly GPL, LGPL, MIT, MPL and similar). Proprietary firmware from
Debian's `non-free-firmware` area is included so that Wi-Fi and graphics hardware works.
