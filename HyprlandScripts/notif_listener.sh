#!/bin/bash
dbus-monitor "interface='org.freedesktop.Notifications'" | while read -r line; do
  # Only process message payload strings after the 'Notify' method call

  if [[ $line == *"method call time="* && $line == *"Notify"* ]]; then
      # Start of a notification message block — reset temp vars
      summary=""
      body=""
      capture=0
  fi

  # Capture strings containing summary and body within the notification packet
  # D-Bus messages have fields in order; typically summary is 8th string, body 9th
  if [[ $line == *"string \""* ]]; then
    str=$(echo "$line" | grep -oP '"\K[^"]+')
    capture=$((capture+1))
    if (( capture == 8 )); then
      summary="$str"
    elif (( capture == 9 )); then
      body="$str"
      # When body is captured, write notification line to log
      timestamp=$(date '+%Y-%m-%d %H:%M:%S')
      echo "$timestamp - $summary: $body" >> ~/.cache/notifications.log
    fi
  fi
done

