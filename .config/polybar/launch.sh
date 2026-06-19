#!/usr/bin/env bash

set -u

CONFIG=(--config="$HOME/.config/polybar/config.ini")
# Use a launcher-specific name. Polybars started by the previous version
# inherited and permanently held the old polybar-launch.lock.
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/polybar-launcher.lock"

exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  echo "polybar launch already running" >&2
  exit 0
fi

# A terminal Ctrl+C should not leave the bars stopped between quit and restart.
trap '' INT TERM HUP

for cmd in flock polybar polybar-msg setsid xrandr; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "could not start polybar: missing $cmd" >&2
    exit 1
  fi
done

mapfile -t MONITORS < <(polybar -m | cut -d":" -f1)
if (( ${#MONITORS[@]} == 0 )); then
  echo "could not start polybar: no monitors detected" >&2
  exit 1
fi

polybar-msg cmd quit >/dev/null 2>&1 || pkill -x polybar >/dev/null 2>&1 || true
sleep 0.5

for MONITOR in "${MONITORS[@]}"; do
  export MONITOR
  echo "start polybar on $MONITOR"
  (
    # Do not let the long-running bar inherit the launch lock. The lock only
    # serializes restarts and must be released when this script exits.
    exec 9>&-
    trap - INT TERM HUP
    exec setsid polybar --reload "${CONFIG[@]}" mybar >>"/tmp/polybar_monitor_${MONITOR}.log" 2>&1 < /dev/null
  ) &
done
