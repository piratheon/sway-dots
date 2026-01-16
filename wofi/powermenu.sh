#!/bin/bash

# Options for wofi
options="Shutdown
Reboot
Lock
Logout"

# Get user choice
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu")

# Execute action based on choice
case "$chosen" in
    "Shutdown")
        systemctl poweroff
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Lock")
        swaylock
        ;;
    "Logout")
        swaymsg exit
        ;;
esac
