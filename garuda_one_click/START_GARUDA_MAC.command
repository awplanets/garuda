#!/bin/bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

PORT="${PORT:-4188}"
URL="http://127.0.0.1:${PORT}/"

echo "GARUDA is starting at ${URL}"
echo "Keep this Terminal window open while playing. Close it to stop the game."

if command -v node >/dev/null 2>&1; then
  open "$URL"
  exec node "$ROOT/server.mjs" "$ROOT"
fi

if command -v python3 >/dev/null 2>&1; then
  open "$URL"
  exec python3 "$ROOT/start_server.py" "$ROOT" "$PORT"
fi

echo "GARUDA needs Node.js or Python 3 to run on macOS."
echo "Install Node.js from https://nodejs.org or install Python 3, then double-click this file again."
read -r -p "Press Enter to close..."
