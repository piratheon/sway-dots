#!/bin/bash

# Pastikan bluetooth aktif
if ! bluetoothctl show | grep -q "Powered: yes"; then
    echo "[]"
    exit 0
fi

# Scan devices (timeout 5 detik) - REDIRECT SEMUA OUTPUT KE /dev/null
bluetoothctl scan on &>/dev/null &
SCAN_PID=$!
sleep 5
kill $SCAN_PID 2>/dev/null

# Array untuk menyimpan JSON
devices_json="["
first=true

while read -r line; do
    mac=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d' ' -f3-)
    
    # Skip jika nama kosong
    [ -z "$name" ] && continue
    
    # Check connected
    if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
        connected="true"
        conn_icon="✓"
    else
        connected="false"
        conn_icon=""
    fi
    
    # Check paired
    if bluetoothctl info "$mac" 2>/dev/null | grep -q "Paired: yes"; then
        paired="true"
        pair_icon=" "
    else
        paired="false"
        pair_icon=""
    fi
    
    # Get device type
    dev_type=$(bluetoothctl info "$mac" 2>/dev/null | grep "Icon:" | awk '{print $2}')
    case "$dev_type" in
        *phone*|*mobile*) type_icon=" ";;
        *audio*|*headset*|*headphone*) type_icon="󰋎 ";;
        *computer*) type_icon=" ";;
        *keyboard*) type_icon=" ";;
        *mouse*) type_icon=" ";;
        *) type_icon="󰑖 ";;
    esac
    
    # Escape special characters in name untuk JSON
    name=$(echo "$name" | sed 's/"/\\"/g')
    
    # Build JSON
    if [ "$first" = false ]; then
        devices_json+=","
    fi
    devices_json+="{\"name\":\"$name\",\"mac\":\"$mac\",\"connected\":\"$connected\",\"paired\":\"$paired\",\"type_icon\":\"$type_icon\",\"pair_icon\":\"$pair_icon\",\"conn_icon\":\"$conn_icon\"}"
    first=false
done < <(bluetoothctl devices 2>/dev/null)

devices_json+="]"

# Output hanya JSON, tanpa pesan lain
echo "$devices_json"
