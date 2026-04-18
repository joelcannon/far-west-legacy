#!/bin/bash
# Far West Legacy — install as a user-level launchd service on macOS.
# Run from repo root: ./deploy/install_mac.sh

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SERVICE_LABEL="com.farwestlegacy.app"
PLIST_SRC="$REPO_ROOT/deploy/$SERVICE_LABEL.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/$SERVICE_LABEL.plist"
LOG_DIR="$HOME/Library/Logs/far-west-legacy"
PORT=8081

echo "FWL launchd installer"
echo "---------------------"

# Sanity checks
if [ ! -f "$PLIST_SRC" ]; then
    echo "ERROR: $PLIST_SRC not found."
    exit 1
fi

if [ ! -f "$REPO_ROOT/.venv/bin/python" ]; then
    echo "ERROR: venv not found at $REPO_ROOT/.venv"
    echo "Run: python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

if [ ! -f "$REPO_ROOT/.env" ]; then
    echo "ERROR: .env not found at $REPO_ROOT/.env"
    exit 1
fi

# Kill any existing Flask on the port (dev-mode or prior launchd run)
EXISTING=$(lsof -ti:$PORT 2>/dev/null || true)
if [ -n "$EXISTING" ]; then
    echo "Killing existing process(es) on port $PORT: $EXISTING"
    echo "$EXISTING" | xargs kill -9 2>/dev/null || true
    sleep 0.5
fi

# Unload any existing service (idempotent)
launchctl bootout "gui/$(id -u)/$SERVICE_LABEL" 2>/dev/null || true

# Create log dir
mkdir -p "$LOG_DIR"
echo "Log dir:   $LOG_DIR"

# Copy plist
mkdir -p "$HOME/Library/LaunchAgents"
cp "$PLIST_SRC" "$PLIST_DEST"
echo "Plist:     $PLIST_DEST"

# Load service
launchctl bootstrap "gui/$(id -u)" "$PLIST_DEST"
echo "Service:   loaded"

# Wait for Flask to come up
echo -n "Waiting for Flask on port $PORT"
for i in $(seq 1 20); do
    if lsof -ti:$PORT >/dev/null 2>&1; then
        echo " — up!"
        break
    fi
    echo -n "."
    sleep 0.5
done

if ! lsof -ti:$PORT >/dev/null 2>&1; then
    echo ""
    echo "ERROR: Flask did not start within 10 seconds."
    echo "Check logs: tail -n 50 $LOG_DIR/flask.err"
    exit 1
fi

# Print status
echo ""
echo "Service installed and running."
echo "  Local:   http://localhost:$PORT"
echo "  Tailnet: http://$(hostname -s):$PORT"
echo ""
echo "Logs:"
echo "  tail -f $LOG_DIR/flask.log"
echo "  tail -f $LOG_DIR/flask.err"
echo ""
echo "Stop service:  launchctl bootout gui/\$(id -u)/$SERVICE_LABEL"
echo "Start service: launchctl bootstrap gui/\$(id -u) $PLIST_DEST"
echo "Uninstall:     ./deploy/uninstall_mac.sh"
