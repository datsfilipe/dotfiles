#!/usr/bin/env bash
set -uo pipefail

mode="${1:-tick}"
schedule_file="${ROUTINE_SCHEDULE_FILE:-/run/secrets/routine}"

[ -r "$schedule_file" ] || exit 0

dow=$(date +%u)
now_min=$((10#$(date +%H) * 60 + 10#$(date +%M)))

to_min() {
  local h=${1%%:*} m=${1##*:}
  echo $((10#$h * 60 + 10#$m))
}

day_matches() {
  local spec="$1"
  case "$spec" in
  *-*) [ "$dow" -ge "${spec%%-*}" ] && [ "$dow" -le "${spec##*-}" ] ;;
  *) [ "$dow" -eq "$spec" ] ;;
  esac
}

notify() {
  local urgency="$1" title="$2" body="$3"
  notify-send -a routine -u "$urgency" "$title" "$body" || true
}

while read -r dayspec start end name; do
  case "$dayspec" in "" | \#*) continue ;; esac
  day_matches "$dayspec" || continue

  s=$(to_min "$start")
  e=$(to_min "$end")

  case "$mode" in
  tick)
    diff=$((s - now_min))
    case "$diff" in
    15) notify normal "$name" "starting in 15 minutes ($start)" ;;
    10) notify normal "$name" "starting in 10 minutes ($start)" ;;
    5) notify normal "$name" "starting in 5 minutes ($start)" ;;
    0) notify critical "Please start: $name" "scheduled $start – $end" ;;
    esac
    ;;
  startup)
    if [ "$now_min" -ge "$s" ] && [ "$now_min" -lt "$e" ]; then
      notify critical "In progress: $name" "scheduled $start – $end"
    fi
    ;;
  esac
done <"$schedule_file"
