#!/bin/sh
#
#   Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#   License: MIT
#
#   Part of https://github.com/jaclu/tmux-menus
#
#   Version: 1.2.2 2022-02-18
#
#  Common stuff
#

get_tmux_option() {
    gtm_option=$1
    gtm_default=$2
    gtm_value=$(tmux show-option -gqv "$gtm_option")
    if [ -z "$gtm_value" ]; then
        echo "$gtm_default"
    else
        echo "$gtm_value"
    fi
    unset gtm_option
    unset gtm_default
    unset gtm_value
}

#
#  Make it easy to see when a log run occured, also makes it easier
#  to separate runs of this script
#
#log_file="/tmp/tmux-menus.log"  # Trigger LF to separate runs of this script


#
#  If $log_file is empty or undefined, no logging will occur.
#
log_it() {
    if [ -z "$log_file" ]; then
        return
    fi
    printf "%s\n" "$@" >> "$log_file"
}


#
#  W - By the current window name in the status line
#  P - Lower left of current pane
#  C - Centered in window (tmux 3.2 and up)
#  M - Mouse position
#  R - Right edge of terminal (Only for x)
#  S - Next to status line (Only for y)
#  Number - In window coordinates 0,0 is top left
#
menu_location_x="$(get_tmux_option "@menus_location_x" "P")"
menu_location_y="$(get_tmux_option "@menus_location_y" "P")"
