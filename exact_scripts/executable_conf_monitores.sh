#!/bin/bash

# MONITOR1=$(xrandr | grep eDP1 | sed -n 1p | awk '{print $1}')
# MONITOR2=$(xrandr | grep HDMI2 | sed -n 1p | awk '{print $1}')
#
# #source ~/Downloads/scripts/xrandr_hack.sh
#
# #setar as posições dos monitores
# xrandr --output $MONITOR1 --auto --output $MONITOR2 --auto --right-of $MONITOR1
#
# #setar o wallpaper
# #desativado para o pywal gerenciar os wallpapers
# ##nitrogen --restore

autorandr --change
