#!/bin/bash

# Toggle calendar popup - FIXED VERSION
if eww active-windows | grep -q "calendar_popup"; then
    eww close calendar_popup > /dev/null 2>&1
else
    eww open calendar_popup > /dev/null 2>&1
fi
