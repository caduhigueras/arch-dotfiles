#!/usr/bin/env bash
set -euo pipefail
step="${1:-0}"

line=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
mute_flag=$(grep -q "MUTED" <<<"$line" && echo 1 || echo 0)
cur_float=$(awk '{print $2}' <<<"$line")

cur=$(awk -v v="$cur_float" 'BEGIN{printf "%d", v*100 + 0.5}')
new=$((cur + step))
(( new > 100 )) && new=100
(( new < 0 )) && new=0

wpctl set-volume @DEFAULT_AUDIO_SOURCE@ "$new%"

