#!/usr/bin/env bash
# Signs a `flutter build macos` app for the Steam depot: Developer ID,
# hardened runtime, secure timestamp, Steam.entitlements. Notarization is a
# separate step (see .github/workflows/steam-deploy.yml) because it needs the
# App Store Connect key; this script only needs the identity in a keychain.
#
#   tool/sign_macos_steam.sh <path/to/App.app> "<codesign identity>"
#
# The identity "-" signs ad hoc, which is enough to check the script locally
# (`codesign --verify` passes, Gatekeeper and notarization will not).
#
# Nested code is signed inside out, never with `codesign --deep`: --deep
# applies the app's entitlements to every framework and is deprecated for
# signing. Frameworks get no entitlements, only the app itself does.
set -euo pipefail

APP="${1:?usage: sign_macos_steam.sh <App.app> <identity>}"
IDENTITY="${2:?usage: sign_macos_steam.sh <App.app> <identity>}"
ENTITLEMENTS="$(cd "$(dirname "$0")/.." && pwd)/macos/Runner/Steam.entitlements"

[ -d "$APP" ] || { echo "no such app: $APP" >&2; exit 1; }
[ -f "$ENTITLEMENTS" ] || { echo "missing $ENTITLEMENTS" >&2; exit 1; }

TS=--timestamp
[ "$IDENTITY" = "-" ] && TS=--timestamp=none

sign() {
  codesign --force --options runtime "$TS" --sign "$IDENTITY" "$@"
}

# Loose dylibs first (anywhere in the bundle), then framework bundles. Sorting
# by path depth, deepest first, covers frameworks nested in frameworks.
while IFS= read -r -d '' lib; do
  sign "$lib"
done < <(find "$APP/Contents" -name '*.dylib' -type f -print0)

find "$APP/Contents" -name '*.framework' -type d -print0 |
  while IFS= read -r -d '' fw; do
    printf '%s\t%s\0' "$(tr -cd '/' <<<"$fw" | wc -c)" "$fw"
  done |
  sort -z -rn |
  while IFS=$'\t' read -r -d '' _ fw; do
    sign "$fw"
  done

sign --entitlements "$ENTITLEMENTS" "$APP"

codesign --verify --strict --deep --verbose=2 "$APP"
