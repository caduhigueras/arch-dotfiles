# #!/usr/bin/env bash
# set -euo pipefail
#
# # mute state: yes/no
# mute=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
#
# # volume percent (first % found)
# vol=$(pactl get-source-volume @DEFAULT_SOURCE@ \
#   | grep -oE '[0-9]+%' | head -1 | tr -d '%')
#
# vol=${vol:-0}
#
# if [[ "$mute" == "yes" || "$vol" -eq 0 ]]; then
#   class="low"
# else
#   class="normal"
# fi
#
# printf '{"text":"%s%%","tooltip":"%s%%","class":"%s"}\n' "$vol" "$vol" "$class"
#
#
#!/usr/bin/env bash
set -euo pipefail

# wpctl gives volume as 0.00–1.00 and [MUTED]
line=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)

# extract mute state
mute="no"
grep -q "MUTED" <<<"$line" && mute="yes"

# extract volume float
vol_float=$(awk '{print $2}' <<<"$line")

# convert to percent
vol=$(awk -v v="$vol_float" 'BEGIN{printf "%d", v*100 + 0.5}')

if [[ "$mute" == "yes" || "$vol" -eq 0 ]]; then
  class="low"
else
  class="normal"
fi

printf '{"text":"%s%%","tooltip":"%s%%","class":"%s"}\n' "$vol" "$vol" "$class"

