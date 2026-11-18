# dotfiles

macOS window management and laptop keyboard config.

These are copies, not symlinks: `smart-gaps.sh` rewrites the Dell gap values in
the live `~/.aerospace.toml` many times a day, so the committed config keeps
them at 0. Copy changes back here after editing the live files.

Install both tools with:

```
git clone git@github.com:pcholakov/dotfiles.git ~/dotfiles
brew bundle --file ~/dotfiles/Brewfile
```

## AeroSpace

Tiling window manager. Modifier is Ctrl+Alt (a Voyager thumb hold, or J+L on
the laptop via Kanata).

1. Copy the config and script into place:
   ```
   cp ~/dotfiles/aerospace/aerospace.toml ~/.aerospace.toml
   mkdir -p ~/.config/aerospace
   cp ~/dotfiles/aerospace/smart-gaps.sh ~/.config/aerospace/
   chmod +x ~/.config/aerospace/smart-gaps.sh
   ```
   The config calls the script by absolute path (`/Users/pavel/...`); change it
   if your home directory differs.
2. Open AeroSpace once and grant it Accessibility when asked. The config sets
   `start-at-login`, so it runs at every login after that.

`smart-gaps.sh` centres a lone window (or a single accordion stack) on the 32"
Dell with per-app widths, and removes the margins when two or more windows are
tiled. AeroSpace runs it from its focus, workspace and new-window callbacks.
The monitor match (`DELL`) and widths are set at the top of the script.

Alt+1..5 open or focus Dia, Claude, iTerm2, Slack and Obsidian by bundle ID;
swap in your own apps in `aerospace.toml`.

## Kanata (built-in MacBook keyboard only)

Home-row mods (S/D/F/V and L/K/J/M = Ctrl/Shift/Alt/Cmd) and an Fn layer
reached by holding Fn or Caps: IJKL arrows, U/O PgUp/PgDn, H backspace,
; return, N delete, Backspace delete, arrows Home/End/PgUp/PgDn, top row media
keys (plain top row is F1-F12). Tapping Caps starts caps word. The Voyager
does its own home-row mods and is not grabbed.

Kanata 1.12 needs **Karabiner-DriverKit-VirtualHIDDevice v6.2.0**. Full
Karabiner-Elements 16 ships a newer driver daemon (8.x) that Kanata can't talk
to (`connect_failed asio.system:2`), so don't install Karabiner-Elements.

1. Copy the config into place (Kanata itself comes from the Brewfile):
   ```
   mkdir -p ~/.config/kanata
   cp ~/dotfiles/kanata/kanata.kbd ~/.config/kanata/
   ```
2. Install `Karabiner-DriverKit-VirtualHIDDevice-6.2.0.pkg` from
   pqrs-org/Karabiner-DriverKit-VirtualHIDDevice releases, then:
   ```
   sudo /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
   ```
   and approve it under Login Items & Extensions > Driver Extensions.
3. Run the driver daemon at boot:
   ```
   sudo cp ~/dotfiles/kanata/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist /Library/LaunchDaemons/
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
