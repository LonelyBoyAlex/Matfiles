#!/bin/env bash

TOOL="brightnessctl"
MAX_BRIGHT=$($TOOL max)

get_backlight() {
    brightness=$($TOOL get)
    echo $((brightness * 100 / $MAX_BRIGHT))
}

#set_backlight() {
#    local brt=$(get_backlight)
#    if(( brt > 5 && brt<=95)) ; then
#        $TOOL set $1
#      fi
#}

case "$1" in 
    up)
        #set_backlight +5% ;;
        $TOOL set +5%;;
    down)
#        set_backlight 5%- ;;
        $TOOL set 5%-;;
    *)
        echo "USAGE : brightness.sh [up,down] ";;
esac

#get_backlight
