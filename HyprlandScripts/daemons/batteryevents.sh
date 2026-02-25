#!/usr/bin/env bash

# Prevent duplicate instances
pgrep -f batteryevents.sh | grep -v $$ >/dev/null && exit 0

LOW=20
CRITICAL=10
FULL=95

DEVICE=$(upower -e | grep battery | head -n1)

low_notified=0
critical_notified=0
full_notified=0
last_state=""

notify() {
  notify-send -u "$1" "$2" "$3"
}

get_info() {
  upower -i "$DEVICE"
}

handle_update() {
  info=$(get_info)

  level=$(echo "$info" | awk '/percentage:/ {gsub("%",""); print $2}')
  state=$(echo "$info" | awk '/state:/ {print $2}')

  # Plug / Unplug detection
  if [[ "$state" != "$last_state" ]]; then
    case "$state" in
    charging)
      notify low "Power Connected" "Charging at ${level}%"
      ;;
    discharging)
      notify low "Power Disconnected" "Running on battery (${level}%)"
      ;;
    esac
    last_state="$state"
  fi

  # Threshold logic
  if [[ "$state" == "discharging" ]]; then
    if ((level <= CRITICAL && critical_notified == 0)); then
      notify critical "Battery Critical" "Battery at ${level}% — plug in NOW."
      critical_notified=1
    elif ((level <= LOW && low_notified == 0)); then
      notify normal "Battery Low" "Battery at ${level}%"
      low_notified=1
    fi
  fi

  if [[ "$state" == "charging" ]]; then
    if ((level >= FULL && full_notified == 0)); then
      notify normal "Battery Full" "Battery at ${level}%"
      full_notified=1
    fi
  fi

  # Reset flags
  if ((level > LOW)); then
    low_notified=0
    critical_notified=0
  fi

  if ((level < FULL)); then
    full_notified=0
  fi
}

# Initial check
handle_update

# Listen to DBus signals from UPower
dbus-monitor --system \
  "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged'" |
  while read -r line; do
    if echo "$line" | grep -q "$DEVICE"; then
      handle_update
    fi
  done
