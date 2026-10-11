#!/usr/bin/env bash

set -euo pipefail

if [[ -z ${DISPLAY:-} ]]; then
  echo "Skipping monitor setup: DISPLAY is not set" >&2
  exit 0
fi

if ! command -v xrandr >/dev/null 2>&1; then
  echo "Could not set up monitors: xrandr is not installed" >&2
  exit 1
fi

if ! xrandr --query >/dev/null 2>&1; then
  echo "Skipping monitor setup: cannot connect to X display $DISPLAY" >&2
  exit 0
fi

# Enable connected outputs at their preferred resolution before inspecting the
# resulting modes. This also makes newly attached displays available.
xrandr --auto
xrandr_output=$(xrandr --query)

mapfile -t connected_outputs < <(
  awk '$2 == "connected" { print $1 }' <<<"$xrandr_output"
)

if (( ${#connected_outputs[@]} == 0 )); then
  echo "Could not set up monitors: no connected outputs found" >&2
  exit 1
fi

internal_output=""
for output in "${connected_outputs[@]}"; do
  case "$output" in
    eDP*|LVDS*|DSI*)
      internal_output=$output
      break
      ;;
  esac
done

# A desktop has no internal panel. In that case, use the first output reported
# by XRandR as the left-most anchor.
anchor_output=${internal_output:-${connected_outputs[0]}}
ordered_outputs=("$anchor_output")
for output in "${connected_outputs[@]}"; do
  [[ $output == "$anchor_output" ]] || ordered_outputs+=("$output")
done

xrandr_args=()
previous_output=""

for output in "${ordered_outputs[@]}"; do
  geometry=$(
    awk -v wanted="$output" '
      $1 == wanted && $2 == "connected" {
        for (i = 3; i <= NF; i++) {
          if ($i ~ /^[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/) {
            split($i, position, "+")
            print position[1]
            exit
          }
        }
      }
    ' <<<"$xrandr_output"
  )

  xrandr_args+=(--output "$output")

  if [[ $geometry =~ ^([0-9]+)x([0-9]+)$ ]] \
    && (( BASH_REMATCH[1] >= 3840 && BASH_REMATCH[2] >= 2160 )); then
    # Many docks and HDMI links are more reliable at 30 Hz for 4K modes.
    xrandr_args+=(--mode "$geometry" --rate 30)
  else
    xrandr_args+=(--auto)
  fi

  xrandr_args+=(--rotate normal)

  if [[ -z $previous_output ]]; then
    xrandr_args+=(--pos 0x0)
    [[ -z $internal_output ]] || xrandr_args+=(--primary)
  else
    xrandr_args+=(--right-of "$previous_output")
  fi

  previous_output=$output
done

xrandr "${xrandr_args[@]}"
