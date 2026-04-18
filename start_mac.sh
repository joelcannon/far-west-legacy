#!/bin/bash
# Far West Legacy — macOS dev-mode launcher.
# Stops the launchd service (if running), launches Flask in foreground,
# and restarts the service on exit.

set -e

PORT=8081
SERVICE_LABEL="com.farwestlegacy.app"
PLIST_DEST="$HOME/Library/LaunchAgents/$SERVICE_LABEL.plist"

echo "FWL dev-mode launcher"
echo "---------------------"

# Was launchd service running? (determines whether to resume on exit)
SERVICE_WAS_RUNNING=false
if launchctl print "gui/$(id -u)/$SERVICE_LABEL" >/dev/null 2>&1; then
    SERVICE_WAS_RUNNING=true
    echo "Stopping launchd service for dev mode..."
    launchctl bootout "gui/$(id -u)/$SERVICE_LABEL" 2>/dev/null || true
    sleep 0.5
fi

# Kill any remaining process on the port
EXISTING=$(lsof -ti:$PORT 2>/dev/null || true)
if [ -n "$EXISTING" ]; then
    echo "Killing existing process(es) on port $PORT: $EXISTING"
    echo "$EXISTING" | xargs kill -9 2>/dev/null || true
    sleep 0.5
fi

# Clean tmp/ stragglers
if [ -d tmp ]; then
    COUNT=$(find tmp -maxdepth 1 -name "*.json" | wc -l | tr -d ' ')
    if [ "$COUNT" -gt 0 ]; then
        echo "Cleaning $COUNT stale file(s) from tmp/"
        rm -f tmp/*.json
    fi
fi

# Activate venv
if [ ! -f .venv/bin/activate ]; then
    echo "ERROR: .venv not found."
    exit 1
fi
# shellcheck disable=SC1091
source .venv/bin/activate

# Trap exit to restore launchd service if it was running
cleanup() {
    echo ""
    if [ "$SERVICE_WAS_RUNNING" = true ] && [ -f "$PLIST_DEST" ]; then
        echo "Restarting launchd service..."
        launchctl bootstrap "gui/$(id -u)" "$PLIST_DEST" 2>/dev/null || \
            echo "WARNING: Could not restart service. Run ./deploy/install_mac.sh to recover."
    fi
}
trap cleanup EXIT

# Launch Flask in foreground
echo "Starting Flask (dev mode) on port $PORT..."
echo "Open Chrome: http://localhost:$PORT"
echo "Press Ctrl+C to stop. The launchd service will resume if it was running."
echo ""
export FLASK_PORT=$PORT
python -m src.app
