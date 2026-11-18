# Cheat sheet

## AeroSpace

Mod = **Ctrl+Alt**: a thumb hold on the Voyager, or J+L on the laptop's home
row (Kanata). IJKL mirror the arrow layer. The config auto-reloads on save.

### Everyday

| Keys | Action |
|---|---|
| Mod + I/J/K/L | Focus up / left / down / right |
| Mod + Shift + I/J/K/L | Move window; moving sideways out of a stack makes it its own column again |
| Mod + O / U | Grow / shrink focused window (also Mod + = / -) |
| Mod + F | Fullscreen toggle |
| Mod + / | Tiles: toggle side-by-side vs top/bottom |
| Mod + , | Toggle side-by-side accordion vs columns (never vertical) |
| Mod + 1..5 | Switch workspace |
| Mod + Shift + 1..5 | Send window to workspace and follow it |
| Mod + Tab | Previous workspace |
| Mod + Shift + Tab | Move workspace to next monitor |
| Mouse drag border | Resize tiled windows |
| Alt + 1..5 | Focus or launch app: 1 Dia, 2 Claude, 3 iTerm2, 4 Slack, 5 Obsidian |

### Service mode: Mod + ;

One key, then back to normal mode automatically. Esc leaves (and reloads the
config).

| Key | Action |
|---|---|
| J/L (or Mod+J/L) | Join with window on the left/right: makes a stacked column |
| I/K (or Mod+I/K) | Join with window above/below: turns a stack back into side-by-side |
| R | Flatten workspace back to one row of columns |
| B | Balance sizes |
| F | Float / unfloat focused window |

Join is the only way to make a stack; move reorders, or lifts a window out of
a stack. The join key points at the neighbour, not where the window should end
up. No key closes windows (removed on purpose).

### Lone-window centring (32" Dell)

`smart-gaps.sh` sets outer margins on the Dell when a workspace has one tiled
window or is one accordion stack; otherwise windows fill the full width. Edit
the `lone_window_gap` table:

| Case | Margin per side | Width left (of 3008pt) |
|---|---|---|
| iTerm2 alone | 600 | ~60% |
| Accordion stack | 600 | ~60% |
| Slack alone | 750 | ~50% |
| Any other app alone | 400 | ~73% |

It runs on focus change, workspace change, new window, Mod + , and float
toggle.

### Quirks

- Dia windows get misdetected as floating; an `on-window-detected` rule forces
  tiling. Float small Dia popups with Mod + ; then F.
- 1Password, Granola, Shottr and OpenLogi windows always float.
- Accordion piles windows with edge strips; if a workspace suddenly
  "overlaps", it's in accordion: Mod + / goes back to tiles.
- After a restart, AeroSpace doesn't remember which window was on which
  workspace.

### CLI

- `aerospace list-windows --all --format '%{workspace} | %{window-layout} | %{app-name}'`
- `aerospace list-apps` (bundle IDs for rules)
- `aerospace reload-config`

## Kanata (built-in MacBook keyboard)

Apply changes: `sudo launchctl kickstart -k system/sh.brew.kanata`.
Log: `/opt/homebrew/var/log/kanata.log`. Emergency exit: Left Ctrl + Space + Esc.

| Keys | Action |
|---|---|
| Hold S / D / F / V | Ctrl / Shift / Alt / Cmd (left hand) |
| Hold L / K / J / M | Ctrl / Shift / Alt / Cmd (right hand) |
| Caps tap / hold | Caps word / Fn layer (same as holding Fn) |
| J+L + 1..5 | AeroSpace workspace (Ctrl+Alt+number) |
| Fn or Caps + I / J / K / L | Up / Left / Down / Right |
| Fn or Caps + U / O | Page Up / Page Down |
| Fn or Caps + H / N | Backspace / Forward delete (add F for whole words) |
| Fn or Caps + ; | Return |
| Fn + Backspace | Forward delete |
| Fn + arrows | Home / End / Page Up / Page Down |
| Top row, plain / with Fn | F1-F12 / media: F1-2 brightness, F3 Mission Control, F7-9 playback, F10-12 volume (F4-6 stay F-keys) |

- Home-row mods fire only when an opposite-hand key is pressed and released
  while held; type crisply and rolls stay letters.
- Mod + same-hand number fails (S+F+3 types letters): use the opposite hand's
  mods.
- After `brew upgrade kanata`, re-grant Input Monitoring and Accessibility to
  the new `/opt/homebrew/Cellar/kanata/<version>/bin/kanata`.
