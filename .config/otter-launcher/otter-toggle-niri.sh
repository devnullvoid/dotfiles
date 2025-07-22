#!/bin/bash

# This is a bash script that toggles otter-launcher with foot terminal for Niri.
# Modify foot --app-id to others, for example alacritty --class, if you use other emulators.
# When run, otter-launcher will be launched if not already running, be focused if running but not being focused, and be closed when already running and focused.

# Get otter-launcher window ID (if exists)
otter_id=$(niri msg --json windows | jq -r '.[] | select(.app_id == "otter-launcher") | .id')

if [ -z "$otter_id" ]
then
    # Launch otter-launcher if not running
    foot --app-id "otter-launcher" -T "otter-launcher" -e sh -c "sleep 0.01 && otter-launcher"
    # kitty --app-id "otter-launcher" -T "otter-launcher" -e sh -c "sleep 0.01 && otter-launcher"
else
    # Check if otter-launcher is currently focused
    focused_id=$(niri msg --json focused-window | jq -r '.id')
    if [ "$focused_id" != "$otter_id" ]
    then
        # Focus otter-launcher if not focused
        niri msg action focus-window --id "$otter_id"
        # notify-send "Focused otter-launcher"
    else
        # Close otter-launcher if already focused
        niri msg action close-window --id "$otter_id"
        # notify-send "Closed otter-launcher"
    fi
fi