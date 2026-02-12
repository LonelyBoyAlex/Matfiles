#!/usr/bin/env bash

if ping -c1 -W1 1.1.1.1 &>/dev/null; then
  iface=$(ip route | grep default | awk '{print $5}' | head -n1)

  if iw dev "$iface" info &>/dev/null; then
    ssid=$(iw dev "$iface" link | grep SSID | cut -d' ' -f2-)
    echo "󰤨 $ssid"
  else
    echo "󰈀 Wired"
  fi
else
  echo "󰤮 Offline"
fi
