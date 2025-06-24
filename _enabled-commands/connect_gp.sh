#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Connect GlobalProtect
# @raycast.mode silent
# @raycast.packageName VPN Control

# Optional parameters:
# @raycast.icon 🌐
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Connects the GlobalProtect VPN client.
# @raycast.author Zaid Hammoudi

# This script automates clicking the 'Connect' button in the GlobalProtect
# menu bar application using AppleScript (osascript).
#
# IMPORTANT:
# - This script assumes the GlobalProtect application is running and its icon
#   is visible in the macOS menu bar.
# - It interacts with the GUI, so ensure GlobalProtect's window is not
#   obscured if you have issues.
# - This script *does not* handle authentication prompts (username/password/MFA).
#   You will still need to manually enter credentials if prompted by GlobalProtect.

osascript <<EOF
tell application "System Events"
    tell process "GlobalProtect"
        # Click the GlobalProtect menu bar item to open its window
        click menu bar item 1 of menu bar 2

        # Bring the GlobalProtect window to the front to ensure clicks register
        set frontmost to true

        # Find and click the "Connect" button within the window
        tell window 1
            click button "Connect"
        end tell

        # Optional: Click the menu bar item again to close the GlobalProtect window
        # (Uncomment the line below if you want the window to close automatically)
        # click menu bar item 1 of menu bar 2
    end tell
end tell
EOF

echo "GlobalProtect connect initiated."
