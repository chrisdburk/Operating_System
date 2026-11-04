# Coming from Windows — a quick guide

Welcome! Most things work the way you'd expect. This page maps what you
already know from Windows to where it lives here.

## Where things are

| On Windows you used...        | Here you use...                                      |
|-------------------------------|------------------------------------------------------|
| Start menu                    | The app launcher, bottom-left (or press the Windows/Super key) |
| File Explorer                 | **Dolphin** (file manager)                           |
| Control Panel / Settings      | **System Settings**                                  |
| Microsoft Store               | **Discover** (software center)                       |
| Windows Update                | **Update Everything** in the app menu, or Discover → Updates |
| Task Manager (Ctrl+Shift+Esc) | **System Monitor** — press Ctrl+Esc                  |
| Notepad                       | **Kate**                                             |
| Command Prompt / PowerShell   | **Konsole** (terminal)                               |
| Snipping Tool (Win+Shift+S)   | **Spectacle** — press the Print Screen key           |
| Edge / Chrome                 | **Firefox** (Chrome, Brave, Edge are in Discover)    |
| Microsoft Office              | **LibreOffice** — opens and saves .docx, .xlsx, .pptx |
| Photos                        | **Gwenview**                                         |
| Adobe Reader                  | **Okular**                                           |
| WinRAR / 7-Zip                | **Ark**                                              |
| Disk Management               | **KDE Partition Manager**                            |
| C:\Users\You                  | `/home/you` (shown as **Home** in Dolphin)           |

## Installing apps

Open **Discover**, search, click **Install**. That's it. Popular apps like
Spotify, Discord, Steam, Zoom, OBS, GIMP, VS Code and Chrome are all there.

Please **don't download `.exe` installers from websites**. They're built for
Windows and won't run here. Check Discover first. If an app has no Linux
version, look at its website for a "Linux" or "Flatpak" download, or ask the
community for an alternative.

## Keyboard shortcuts

These work just like on Windows: Ctrl+C / Ctrl+V / Ctrl+Z, Alt+Tab, Alt+F4,
the Windows key (opens the app launcher), Win+D (show desktop), Win+arrow keys
(snap windows) and Win+L (lock the screen).

A few are different: Ctrl+Esc opens System Monitor (instead of
Ctrl+Shift+Esc for Task Manager), and Ctrl+Alt+Del opens the log-out menu.

## Your Windows files

- Your old Windows drive shows up in Dolphin's left panel and you can open it.
- USB sticks and external drives (NTFS, exFAT, FAT32) work as normal.
- If Windows is still installed, you pick which system to start each time you
  turn on the PC.

## Games

Install **Steam** from Discover. Its built-in "Proton" runs most Windows games.
Check a game at <https://www.protondb.com> before you buy it. Some online games
with anti-cheat systems (e.g. Valorant, some Call of Duty titles) don't work on
Linux.

## Passwords and "admin" prompts

When you install software or change system settings, you'll be asked for
**your own password**. It's the same idea as Windows' "Do you want to allow
this app to make changes?" prompt.

## Getting help

- Reopen **Welcome** from the app menu at any time.
- Most answers for Debian (which this system is built on) also apply here,
  so searching "how to ... Debian" works well.
