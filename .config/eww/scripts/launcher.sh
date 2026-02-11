#!/usr/bin/env bash
pidof fuzzel >/dev/null &&  killall fuzzel || fuzzel --config ~/.config/fuzzel/fuzzelniri.ini
