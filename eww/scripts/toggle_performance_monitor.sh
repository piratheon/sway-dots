#!/bin/bash

# Check if the output of 'eww state' is empty or not.
# The -n flag checks if the string is not empty.
if [ -n "$(eww state)" ]; then
  # If it's not empty, a window is open. Close all windows.
  eww close-all
else
  # If it's empty, no windows are open. Open performance_monitor.
  eww open performance_monitor
fi
