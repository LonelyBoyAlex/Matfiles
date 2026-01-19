#!/bin/bash

# Check if Eww is running
if pgrep -x eww >/dev/null; then
    eww reload
fi

case "$1" in
# Open your eww windows/widgets
bar1)
  eww open dock 
  eww open toppanel 
  eww open botpanel
  eww open rightpanel
  eww open barcorner-leftbot
  eww open barcorner-lefttop
  eww open barcorner-rightbot
  eww open barcorner-righttop
;;
bar2)
  eww open mainpanel
  eww open Bpanel
  eww open Lpanel
  eww open Rpanel
  eww open barcornerBL
  eww open barcornerBR
  eww open barcornerL
  eww open barcornerR
;;
bar)
  eww open bar
  eww open paneltop
  eww open panelryt
  eww open panelbot
  eww open barcornertop
  eww open barcornertopryt
  eww open barcornerbottom
  eww open barcornerbottomryt
;;

baronly)
  eww open bar
  eww open barcornertop
  eww open barcornerbottom
;;
*)
  echo " Usage: $0 {bar,bar1,bar2}"
  ;;
esac
