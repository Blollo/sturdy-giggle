#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root/app"
export BYPASS_PERMISSION_LOCATION_ALWAYS=1
if [[ -n "${FLUTTER_BIN:-}" ]]; then
  exec "$FLUTTER_BIN" "$@"
elif command -v fvm >/dev/null 2>&1; then
  exec fvm flutter "$@"
else
  exec flutter "$@"
fi
