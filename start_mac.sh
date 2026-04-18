#!/bin/bash
# Far West Legacy — macOS demo launcher
# Kills any process on port 8081, cleans tmp/, launches Flask.

set -e

PORT=8081

echo "FWL demo launcher"
echo "-----------------"

# Kill any existing process on the port
EXISTING=$(lsof -ti:$PORT 2>/dev/null || true)
if [ -n "$EXISTING" ]; then
    echo "Killing existing process(es) on port $PORT: $EXISTING"
    echo "$EXISTING" | xargs kill -9 2>/dev/null || true
    sleep 0.5
else
    echo "No existing process on port $PORT."
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
    echo "ERROR: .venv not found. Run: python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

# shellcheck disable=SC1091
source .venv/bin/activate

# Launch Flask
echo "Starting Flask on port $PORT..."
echo "Open Chrome: http://localhost:$PORT"
echo ""
export FLASK_PORT=$PORT
python -m src.app
