#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
"$root/scripts/flutter.sh" pub get
if [[ -n "${FLUTTER_BIN:-}" ]]; then
  dart_bin="$(dirname "$FLUTTER_BIN")/dart"
  (cd "$root/app" && "$dart_bin" format --output=none --set-exit-if-changed lib test)
elif command -v fvm >/dev/null 2>&1; then
  (cd "$root/app" && fvm dart format --output=none --set-exit-if-changed lib test)
else
  (cd "$root/app" && dart format --output=none --set-exit-if-changed lib test)
fi
"$root/scripts/flutter.sh" analyze
"$root/scripts/flutter.sh" test
