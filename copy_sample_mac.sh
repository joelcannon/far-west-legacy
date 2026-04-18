#!/bin/bash
# Far West Legacy — copy a demo sample to macOS clipboard.
# Usage:
#   ./copy_sample_mac.sh             # list available samples
#   ./copy_sample_mac.sh <name>      # copy demo/sample_<name>.txt to clipboard

set -e

DEMO_DIR="demo"

if [ ! -d "$DEMO_DIR" ]; then
    echo "ERROR: $DEMO_DIR/ not found. Run from repo root."
    exit 1
fi

# No argument: list available samples
if [ $# -eq 0 ]; then
    echo "Available samples:"
    for f in "$DEMO_DIR"/sample_*.txt; do
        [ -f "$f" ] || continue
        name=$(basename "$f" .txt)
        name=${name#sample_}
        echo "  $name"
    done
    echo ""
    echo "Usage: ./copy_sample_mac.sh <name>"
    exit 0
fi

NAME="$1"
FILE="$DEMO_DIR/sample_$NAME.txt"

if [ ! -f "$FILE" ]; then
    echo "ERROR: $FILE not found."
    echo ""
    echo "Available samples:"
    for f in "$DEMO_DIR"/sample_*.txt; do
        [ -f "$f" ] || continue
        n=$(basename "$f" .txt)
        n=${n#sample_}
        echo "  $n"
    done
    exit 1
fi

CHARS=$(wc -c < "$FILE" | tr -d ' ')
pbcopy < "$FILE"
echo "Copied $NAME ($CHARS chars) to clipboard. Paste into Chrome with Cmd+V."
