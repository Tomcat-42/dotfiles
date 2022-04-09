#!/bin/sh
#
#   Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#   License: MIT
#
#   Part of https://github.com/jaclu/tmux-menus
#
#   Version: 1.2.4 2022-03-03
#


CURRENT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

MENUS_DIR="$CURRENT_DIR/items"
SCRIPTS_DIR="$CURRENT_DIR/scripts"

. "$SCRIPTS_DIR/utils.sh"


#
#  In shell script unlike in tmux, backslash needs to be doubled inside quotes.
#
default_key="\\"


#
#  By printing a NL and date, its easier to keep separate runs apart
#
log_it ""
log_it "$(date)"


trigger_key=$(get_tmux_option "@menus_trigger" "$default_key")
log_it "trigger_key=[$trigger_key]"

without_prefix=$(get_tmux_option "@menus_without_prefix" "0")
log_it "without_prefix=[$without_prefix]"

#
#  Generic plugin setting I use to add Notes to keys that are bound
#  This makes this key binding show up when doing <prefix> ?
#  If not set to "Yes", no attempt at adding notes will happen
#  bind-key Notes were added in tmux 3.1, so should not be used on older versions!
#
use_notes=$(get_tmux_option "@plugin_use_notes" "No")
log_it "use_notes=[$use_notes]"


case "$without_prefix" in

    "0" | "1" ) ;;  # expected values

    "yes" | "Yes" | "YES" | "true" | "True" | "TRUE" )
	#  Be a nice guy and accept some common positives
        log_it "Converted incorrect positive to 1"
        without_prefix=1
        ;;

    *)
        log_it "Invalid without_prefix value"
        tmux display 'ERROR: "@menus_without_prefix" should be 0 or 1'
        exit 0  # Exit 0 wont throw a tmux error

esac


if [ "$without_prefix" -eq 1 ]; then
    if [ "$use_notes" = "Yes" ]; then
        tmux bind -N "tmux-menus" -n "$trigger_key" run-shell "$MENUS_DIR"/main.sh
    else
        tmux bind -n "$trigger_key" run-shell "$MENUS_DIR"/main.sh
    fi
    log_it "Menus bound to: $trigger_key"
else
    if [ "$use_notes" = "Yes" ]; then
        tmux bind -N "tmux-menus" "$trigger_key" run-shell "$MENUS_DIR"/main.sh
    else
        tmux bind    "$trigger_key" run-shell "$MENUS_DIR"/main.sh
    fi
    log_it "Menus bound to: <prefix> $trigger_key"
fi
