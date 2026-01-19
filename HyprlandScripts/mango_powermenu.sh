#!/bin/bash

if eww get ispowermenu | grep -q true; then
    eww close powermenu
    eww update ispowermenu=false
else
    eww open powermenu
    eww update ispowermenu=true
fi

