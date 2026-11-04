# Contributing

Thanks for helping. Every kind of contribution counts: testing on your
hardware, fixing a typo in the guide, or writing code.

## Ways to help

- **Test**: build or download an ISO, try it on your PC or in a VM, and open
  an issue that lists your hardware and what worked or didn't.
- **Docs**: improve [the Windows switcher guide](docs/SWITCHING-FROM-WINDOWS.md).
  Ask a non-technical friend to read it and note where they get stuck.
- **Code/config**: pick an item from the [roadmap](docs/ROADMAP.md) or an
  open issue.

## Making a change

1. Fork the repository and create a branch.
2. Make your change. See [docs/CUSTOMIZING.md](docs/CUSTOMIZING.md) for where
   things live.
3. Run `make lint` (shellcheck) if you changed any script.
4. If you can, build the ISO and boot it in a VM.
5. Open a pull request that explains **what** you changed and **why**,
   especially for anything a Windows switcher would notice.

## Guidelines

- **Beginner first.** Defaults should make sense to someone who has only used
  Windows. Power-user options are welcome as long as they stay optional.
- **Stay close to upstream.** Prefer configuring Debian/KDE over patching
  them. The less we maintain, the longer the project lives.
- **Readable over clever.** Scripts should be easy for a curious user to
  understand. Comment the *why*.
- **Free software.** Only add software that Debian or Flathub distributes.
  Non-free firmware is the one exception, because it makes hardware work.

By contributing you agree that your contributions are licensed under the
GPL v3 or later.
