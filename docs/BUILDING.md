# Building the ISO

## Requirements

- An x86-64 Linux machine, or Windows with WSL2 + Docker Desktop
- ~15 GB free disk space, 4 GB+ RAM
- A good internet connection (about 2–3 GB is downloaded from Debian mirrors)

## Option A: Docker (any Linux distribution)

```bash
./build-in-docker.sh          # or: make docker-iso
```

The container runs `--privileged` because live-build has to mount
filesystems while it builds the system image.

## Option B: Natively on Debian 13 (or newer)

```bash
sudo apt install live-build
sudo ./build.sh               # or: make iso
```

## Option C: GitHub Actions

On GitHub, open **Actions → Build ISO → Run workflow**. When the run
finishes, download the ISO from the run's *Artifacts* section. Pushing a tag
such as `v0.1.0` also starts a build.

## Output

```
out/waypoint-0.1.0-amd64.iso
out/waypoint-0.1.0-amd64.iso.sha256
```

The full build log is at `build/build.log`.

## Useful commands

| Command                 | What it does                                          |
|-------------------------|-------------------------------------------------------|
| `sudo ./build.sh config`| Only generates `build/config` so you can inspect it   |
| `sudo ./build.sh clean` | Deletes the build directory                           |
| `make lint`             | Runs shellcheck on every script                       |

The build caches downloaded packages in `build/cache` until you run `clean`.

## Testing in a virtual machine

Quickest with QEMU:

```bash
qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 \
  -bios /usr/share/ovmf/OVMF.fd \
  -cdrom out/waypoint-*.iso
```

Or use VirtualBox / GNOME Boxes / virt-manager. Enable **EFI** in the VM
settings to test the UEFI path, which is what most modern PCs use.

Things to check on each build:

1. Boots to the desktop and logs in automatically as `live` (password: `live`).
2. The Welcome window appears. **Install** starts the installer.
3. Wi-Fi/network, sound, and Discover can install a Flatpak.
4. After installing to the VM's disk, it reboots into the installed system.

## Writing to a USB stick

- **From Windows:** [Rufus](https://rufus.ie) (choose "DD image" mode if
  asked) or [balenaEtcher](https://etcher.balena.io).
- **From Linux:** GNOME Disks / KDE ISO Image Writer, or
  `sudo dd if=out/waypoint-*.iso of=/dev/sdX bs=4M status=progress oflag=sync`
  (double-check `sdX`, because it will be erased).

## Troubleshooting

- **"Unknown in Debian ..." / "E: Unable to locate package X"**: a package
  name in `config/package-lists/` doesn't exist in this Debian release. Search
  for the correct name at <https://packages.debian.org>. The build checks every
  name before it starts (`scripts/check-packages.sh`), and CI runs the same
  check on every push, so you see all bad names at once.
- **Build fails in a hook**: hooks run with `set -e`, so check
  `build/build.log` for the last `Executing hook` line.
- **Out of disk space**: run `sudo ./build.sh clean` and make sure you have
  15 GB free.
