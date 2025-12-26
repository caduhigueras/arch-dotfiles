#!/usr/bin/env bash

read -r mem_total_kb mem_avail_kb < <(awk '
/^MemTotal:/      {t=$2}
/^MemAvailable:/  {a=$2}
END {print t, a}
' /proc/meminfo)

used_kb=$((mem_total_kb - mem_avail_kb))

# Percent used (float with 1 decimal)
percent=$(awk -v u="$used_kb" -v t="$mem_total_kb" '
BEGIN {
  if (t==0) {print "0.0"; exit}
  printf "%.1f", (u*100)/t
}')

# Used/Total in GiB (1 decimal)
tooltip=$(awk -v u="$used_kb" -v t="$mem_total_kb" '
BEGIN {
  gib = 1024*1024
  printf "%.1f / %.1f GiB", u/gib, t/gib
}')

# Class by thresholds (float-safe)
class=$(awk -v p="$percent" '
BEGIN {
  if (p < 20)        c="low";
  else if (p < 45)   c="normal";
  else if (p < 55)   c="high";
  else               c="limit";
  print c;
}')

printf '{"text":"%.1f%%","tooltip":"%s","class":"%s"}\n' "$percent" "$tooltip" "$class"

