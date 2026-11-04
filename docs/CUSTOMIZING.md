# Customizing: the tinkerer's guide

Everything that makes this OS what it is lives in plain text files. Here's
how to change the most common things. Rebuild with `./build-in-docker.sh`
after any change.

## Rename it / make your own spin

Edit [`os.conf`](../os.conf):

```bash
OS_NAME="My Cool OS"
OS_ID="mycoolos"
OS_VERSION="1.0.0"
```

The name, the ISO label, the hostname, helper tool names
(`mycoolos-welcome`) and `/etc/mycoolos-release` all follow automatically.

## Add or remove software

Package lists are in `config/package-lists/`, one package per line, and
`#` starts a comment. Any file ending in `.list.chroot` is used.

```bash
# config/package-lists/extras.list.chroot
gimp
inkscape
thunderbird
```

Find package names at <https://packages.debian.org> (pick the release named in
`os.conf`). To remove something, delete its line. Note that some packages are
pulled in by others anyway.

## Run a command while building the system

Add an executable script to `config/hooks/normal/`, named
`NNNN-description.hook.chroot`. Hooks run in number order, **inside the new
system**, as root:

```sh
#!/bin/sh
# config/hooks/normal/0500-my-tweak.hook.chroot
set -e
flatpak install -y --noninteractive flathub org.gimp.GIMP
```

Remember `chmod +x`. Note that services can't be *started* during the build,
only enabled (`systemctl enable ...`).

## Add or override files

Anything under `config/includes.chroot/` is copied into the system at the
same path. For example:

| Put a file at...                                         | ...and it becomes                  |
|----------------------------------------------------------|------------------------------------|
| `config/includes.chroot/etc/skel/.config/kdeglobals`     | Default KDE settings for new users |
| `config/includes.chroot/usr/share/wallpapers/...`        | Extra wallpapers                   |
| `config/includes.chroot/usr/local/bin/my-script`         | A command available to everyone    |
| `config/includes.chroot/etc/xdg/autostart/x.desktop`     | Something that starts at login     |

**Tip for KDE defaults:** set things up the way you like in a running system,
then copy the relevant files from `~/.config/` (e.g. `kdeglobals`, `kwinrc`,
`plasma-org.kde.plasma.desktop-appletsrc`) into `includes.chroot/etc/skel/.config/`.

You can use `@OS_NAME@` and the other tokens inside files, and `__OS_ID__` in
file names. They're filled in from `os.conf` during the build.

## Change boot / build options

Look at the `lb config` call in [`build.sh`](../build.sh). Every option is
documented in `man lb_config`. Common changes:

- `--bootappend-live`: kernel options for the live session (default
  keyboard layout, locale, username)
- `--archive-areas`: remove `non-free non-free-firmware` for a 100% free
  build (expect Wi-Fi/GPU problems on a lot of hardware)
- `--distribution` (via `DEBIAN_SUITE` in `os.conf`): build on a different
  Debian release

## Modify the Welcome app or the updater

They're bash scripts:
`config/includes.chroot/usr/local/bin/__OS_ID__-welcome` and
`__OS_ID__-update`. Add a menu entry by adding a pair of lines to the `items`
list and a matching `case` branch.

## Going deeper

- The live-build manual: <https://live-team.pages.debian.net/live-manual/>
- Calamares configuration: <https://github.com/calamares/calamares/wiki>
- Debian packaging (to turn our scripts into proper `.deb` packages):
  <https://www.debian.org/doc/manuals/maint-guide/>
