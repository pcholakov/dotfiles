#!/bin/bash
# Centres a lone tiled window on the Dell monitor: while its visible workspace
# has exactly one tiled window, the outer gap per side comes from
# lone_window_gap (per app). A workspace whose root is an accordion stack gets
# the default gap; anything else gets 0.
#
# AeroSpace has no window-count-dependent gaps, so this rewrites the Dell's gap
# value in the config and reloads it. It runs from AeroSpace callbacks
# (focus change, workspace change, new window) and exits early when the gap
# already matches, so frequent invocation is cheap and reloads cannot loop.
set -euo pipefail

AEROSPACE=/opt/homebrew/bin/aerospace
CONFIG="$HOME/.aerospace.toml"
MONITOR_NAME_PATTERN='DELL'

# Gap per side, in points, for a lone window of the given app bundle id.
# The Dell is 3008pt wide: 400 leaves ~73% of the width, 600 ~60%, 750 ~50%.
lone_window_gap() {
  case "$1" in
    com.googlecode.iterm2) echo 600 ;;
    com.tinyspeck.slackmacgap) echo 750 ;;
    stack)                 echo 600 ;;   # root accordion stack
    *)                     echo 400 ;;
  esac
}

monitor_id=$("$AEROSPACE" list-monitors --format '%{monitor-id}|%{monitor-name}' \
  | awk -F'|' -v pattern="$MONITOR_NAME_PATTERN" 'index($2, pattern) { gsub(/ /, "", $1); print $1; exit }')
[ -n "$monitor_id" ] || exit 0

tiled_app_ids=$("$AEROSPACE" list-windows --monitor "$monitor_id" --workspace visible \
  --format '%{window-layout}|%{app-bundle-id}' \
  | awk -F'|' '$1 ~ /tiles|accordion/ { print $2 }')

root_layout=$("$AEROSPACE" list-workspaces --monitor "$monitor_id" --visible \
  --format '%{workspace-root-container-layout}')

if [ -n "$tiled_app_ids" ] && [ "$(printf '%s\n' "$tiled_app_ids" | wc -l)" -eq 1 ]; then
  desired_gap=$(lone_window_gap "$tiled_app_ids")
elif [[ "$root_layout" == *accordion ]]; then
  # A root accordion shows one window at a time, so treat the stack like a lone
  # window. It gets one fixed gap, whatever apps it holds, so the width doesn't
  # jump when focus moves between apps.
  desired_gap=$(lone_window_gap stack)
else
  desired_gap=0
fi

current_gap=$(grep -oE "monitor\.\"$MONITOR_NAME_PATTERN\" = [0-9]+" "$CONFIG" | head -1 | grep -oE '[0-9]+$')
[ "$current_gap" = "$desired_gap" ] && exit 0

sed -i '' -E "s/(monitor\.\"$MONITOR_NAME_PATTERN\" = )[0-9]+/\1$desired_gap/g" "$CONFIG"
"$AEROSPACE" reload-config
