#!/bin/bash

ART=$(playerctl metadata mpris:artUrl 2>/dev/null)

if [[ -z "$ART" ]]; then
  exit 0
fi

# Remove file:// prefix if present
echo "${ART#file://}"
