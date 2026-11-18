# dotfiles

macOS window management and laptop keyboard config.

These are copies, not symlinks: `smart-gaps.sh` rewrites the Dell gap values in
the live `~/.aerospace.toml` many times a day, so the committed config keeps
them at 0. Copy changes back here after editing the live files.

## AeroSpace

Tiling window manager. Modifier is Ctrl+Alt (a Voyager thumb hold, or J+L on
the laptop via Kanata).

| File | Install to |
|---|---|
| `aerospace/aerospace.toml` | `~/.aerospace.toml` |
| `aerospace/smart-gaps.sh` | `~/.config/aerospace/smart-gaps.sh` (executable) |

`smart-gaps.sh` centres a lone window (or a single accordion stack) on the 32"
Dell with per-app widths, and removes the margins when two or more windows are
tiled. AeroSpace runs it from its focus, workspace and new-window callbacks.

## Kanata (built-in MacBook keyboard only)

Home-row mods (S/D/F and L/K/J = Ctrl/Shift/Alt), Caps = tap caps word / hold
Ctrl, and an Fn layer (Fn+IJKL arrows, Fn+Backspace delete, Fn+arrows
Home/End/PgUp/PgDn, Fn+top row media keys; the top row is plain F1-F12).
The Voyager does its own home-row mods and is not grabbed.

Kanata 1.12 needs **Karabiner-DriverKit-VirtualHIDDevice v6.2.0**. Full
Karabiner-Elements 16 ships a newer driver daemon (8.x) that Kanata can't talk
to (`connect_failed asio.system:2`), so don't install Karabiner-Elements.

1. `brew install kanata`, then copy `kanata/kanata.kbd` to
   `~/.config/kanata/kanata.kbd`.
2. Install `Karabiner-DriverKit-VirtualHIDDevice-6.2.0.pkg` from
   pqrs-org/Karabiner-DriverKit-VirtualHIDDevice releases, then:
   ```
   sudo /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
   ```
   and approve it under Login Items & Extensions > Driver Extensions.
3. Run the driver daemon at boot:
   ```
   sudo cp kanata/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist /Library/LaunchDaemons/
   sudo chown root:wheel /Library/LaunchDaemons/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist
   sudo launchctl bootstrap system /Library/LaunchDaemons/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist
   ```
4. Run Kanata at boot: `sudo brew services start kanata`.
5. Grant **both** Input Monitoring and Accessibility to
   `/opt/homebrew/Cellar/kanata/<version>/bin/kanata`. Repeat after every
   `brew upgrade kanata`: the binary is ad-hoc signed, so macOS pins the
   permission to its path.

Apply config changes with `sudo launchctl kickstart -k system/sh.brew.kanata`.
Log: `/opt/homebrew/var/log/kanata.log`. Emergency exit: Left Ctrl + Space + Esc.
