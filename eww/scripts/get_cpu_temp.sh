#!/bin/sh
temp=$(cat /sys/class/thermal/thermal_zone0/temp)
echo "$((temp / 1000))°C"
