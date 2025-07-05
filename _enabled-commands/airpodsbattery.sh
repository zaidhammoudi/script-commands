#!/bin/bash

# Raycast Metadata
# @raycast.schemaVersion 1
# @raycast.title AirPods Battery Level
# @raycast.mode inline
# @raycast.icon ⚡️
# @raycast.packageName Audio
# @raycast.refreshTime 10m
# @raycast.description Show battery level of connected AirPods
# @raycast.author Quentin Eude (minor modifications)

# === Configuration ===

# Hardcoded MAC address of your AirPods
MAC_ADDRESS="04:9D:05:91:33:CB"

# Known Product IDs
AIRPODS_PRODUCT_IDS=("0x200E" "0x200F" "0x2002" "0x2013" "0x2014")  # Include 0x2014 from your output
AIRPODS_MAX_PRODUCT_IDS=("0x200A")

# Display delimiter
DELIMITER="    🎧    "

# === Helper Functions ===

join_by() {
  local delimiter="$1"
  shift
  printf "%s" "$1"
  shift
  for element in "$@"; do
    printf "%s%s" "$delimiter" "$element"
  done
}

# === Main Logic ===

# Grab Bluetooth system profile
bluetooth_info=$(system_profiler SPBluetoothDataType 2>/dev/null)

# Check if MAC is listed under the "Connected:" section
connected_block=$(awk '/Connected:/,/Not Connected:/' <<< "$bluetooth_info")
if ! grep -q "$MAC_ADDRESS" <<< "$connected_block"; then
  echo "No AirPods connected. 🤷"
  exit 0
fi

# Extract device info
device_info=$(grep -A15 "$MAC_ADDRESS" <<< "$bluetooth_info")

# Extract product ID
product_id=$(awk '/Product ID/ { print $3 }' <<< "$device_info")

# Extract battery levels from readable fields
left_battery=$(awk -F': ' '/Left Battery Level/ { print $2 }' <<< "$device_info")
right_battery=$(awk -F': ' '/Right Battery Level/ { print $2 }' <<< "$device_info")
case_battery=$(awk -F': ' '/Case Battery Level/ { print $2 }' <<< "$device_info")

# Format output
result=()
[[ -n "$left_battery" ]]  && result+=("Left $left_battery")
[[ -n "$right_battery" ]] && result+=("Right $right_battery")
[[ -n "$case_battery" ]]  && result+=("Case $case_battery")

# Print result
if [[ ${#result[@]} -gt 0 ]]; then
  join_by "$DELIMITER" "${result[@]}"
else
  echo "Battery info not available. 🤷"
fi

