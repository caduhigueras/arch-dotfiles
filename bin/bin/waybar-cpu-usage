#!/usr/bin/env bash

# Get "active compute" CPU usage as a float (e.g., 12.3)
usage=$(mpstat 1 1 | awk '
/^Average:/ && $2=="all" {
  # active compute = 100 - idle - iowait
  val = 100 - $NF - $6
  if (val < 0) val = 0
  printf "%.1f", val
}')

# Pick class based on thresholds
class="low"
# Use awk for float comparisons safely
class=$(awk -v u="$usage" '
BEGIN {
  if (u < 30)        c="low";
  else if (u < 60)   c="normal";
  else if (u < 90)   c="high";
  else               c="limit";
  print c;
}')

# Output JSON
printf '{"text":"%.1f%%","class":"%s"}\n' "$usage" "$class"

