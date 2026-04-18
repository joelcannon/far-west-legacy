#!/bin/bash
# Far West Legacy — remove launchd service on macOS.

set -e

SERVICE_LABEL="com.farwestlegacy.app"
PLIST_DEST="$HOME/Library/LaunchAgents/$SERVICE_LABEL.plist"

echo "FWL launchd uninstaller"
echo "-----------------------"

# Unload (idempotent)
launchctl bootout "gui/$(id -u)/$SERVICE_LABEL" 2>/dev/null && echo "Service unloaded." || echo "Service was not loaded."

# Remove plist
if [ -f "$PLIST_DEST" ]; then
    rm "$PLIST_DEST"
    echo "Plist removed: $PLIST_DEST"
else
    echo "No plist at $PLIST_DEST"
fi

# Kill any straggler on port 8081
EXISTING=$(lsof -ti:8081 2>/dev/null || true)
if [ -n "$EXISTING" ]; then
    echo "Killing straggler process(es) on port 8081: $EXISTING"
    echo "$EXISTING" | xargs kill -9 2>/dev/null || true
fi

echo ""
echo "Uninstalled. Logs at ~/Library/Logs/far-west-legacy/ are preserved."
echo "Remove logs manually if desired: rm -rf ~/Library/Logs/far-west-legacy"
