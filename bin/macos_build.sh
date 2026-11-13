#!/usr/bin/env bash
# A local macOS Profile build of the game for this machine only.
#
#   bin/macos_build.sh <name> [--dart-define=KEY=VALUE ...]
#
# Signed ad hoc and without the Game Center entitlement, which needs a
# development certificate; the app lands in tyrian_mobile/build/<name>/ and
# its path is printed last. Logs go to run/<name>.build.log.
set -euo pipefail

name="${1:?usage: bin/macos_build.sh <name> [--dart-define=...]}"
shift
root="$(cd "$(dirname "$0")/.." && pwd)"
app_dir="$root/tyrian_mobile"
mkdir -p "$root/run"
log="$root/run/$name.build.log"

ent="$root/run/$name.entitlements"
python3 - "$app_dir/macos/Runner/Release.entitlements" "$ent" <<'PY'
import re, sys
src = open(sys.argv[1]).read()
src = re.sub(r'\s*<key>com.apple.developer.game-center</key>\s*<true/>', '', src)
open(sys.argv[2], 'w').write(src)
PY

cd "$app_dir"
flutter build macos --profile --config-only "$@" >"$log" 2>&1

xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner \
  -configuration Profile -derivedDataPath "build/$name" \
  ONLY_ACTIVE_ARCH=YES ARCHS="$(uname -m)" \
  CODE_SIGN_ENTITLEMENTS="$ent" CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM= PROVISIONING_PROFILE_SPECIFIER= build >>"$log" 2>&1

echo "$app_dir/build/$name/Build/Products/Profile/tyrian_mobile.app"
