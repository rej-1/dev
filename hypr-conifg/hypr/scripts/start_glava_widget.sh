#!/bin/bash

# Kill any existing GLava instance
pkill -x glava

# Launch GLava silently in the background
glava > /dev/null 2>&1 & disown

# Give it some time to start and register with Hyprland
sleep 2

# Find GLava window ID (robustly)
GLAVA_WIN=$(hyprctl clients | awk '/^Window/ {win=$2} /class: GLava/ {print win; exit}')

if [[ -z "$GLAVA_WIN" ]]; then
    echo "Could not find GLava window after waiting."
    exit 1
fi

echo "Found GLava window at: $GLAVA_WIN"

# Try to focus the GLava window (suppress error output)
if ! hyprctl dispatch focuswindow address:$GLAVA_WIN &>/dev/null; then
    echo "Failed to focus GLava window, it might not be ready yet."
else
    echo "Focused GLava window."
fi

sleep 0.2

# Move the GLava window to workspace 6
if ! hyprctl dispatch movetoworkspace address:$GLAVA_WIN 6 &>/dev/null; then
    echo "Failed to move GLava window to workspace 6."
else
    echo "Moved GLava window to workspace 6."
fi

sleep 0.2

# Enable floating mode explicitly (not toggle)
if ! hyprctl dispatch floating address:$GLAVA_WIN enable &>/dev/null; then
    echo "Failed to enable floating mode on GLava window."
else
    echo "Enabled floating on GLava window."
fi

sleep 0.2

# Move window to bottom right corner (adjust X,Y as needed)
if ! hyprctl dispatch movewindow exact address:$GLAVA_WIN 1620 930 &>/dev/null; then
    echo "Failed to move GLava window position."
else
    echo "Moved GLava window to bottom right."
fi

sleep 0.2

# Resize the window (adjust width,height as needed)
if ! hyprctl dispatch resizewindow exact address:$GLAVA_WIN 300 150 &>/dev/null; then
    echo "Failed to resize GLava window."
else
    echo "Resized GLava window."
fi

echo "Script completed."
