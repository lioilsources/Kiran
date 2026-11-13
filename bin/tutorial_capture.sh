#!/usr/bin/env bash
# Film one sigil's lesson for the tutorial videos (Prompts/29 §6.3).
#
#   bin/tutorial_capture.sh loop
#
# Builds a local macOS Profile app that films the lesson off real time and
# quits (LESSON_CAPTURE), runs it in a window, silent, and copies the frames
# and events.json to run/tutorial/<id>/capture/. The app is signed ad hoc
# for this machine only and without the Game Center entitlement, which
# needs a development certificate and has nothing to do with filming.
set -euo pipefail

id="${1:?usage: bin/tutorial_capture.sh <sigil id>}"
root="$(cd "$(dirname "$0")/.." && pwd)"
app_dir="$root/tyrian_mobile"
run="$root/run/tutorial/$id"
mkdir -p "$run"

ent="$root/run/tutorial/capture.entitlements"
python3 - "$app_dir/macos/Runner/Release.entitlements" "$ent" <<'PY'
import re, sys
src = open(sys.argv[1]).read()
src = re.sub(r'\s*<key>com.apple.developer.game-center</key>\s*<true/>', '', src)
open(sys.argv[2], 'w').write(src)
PY

cd "$app_dir"
flutter build macos --profile --config-only \
  --dart-define=LESSON_CAPTURE="$id" \
  --dart-define=WINDOWED=true \
  --dart-define=MUTE=true >"$run/build.log" 2>&1

xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner \
  -configuration Profile -derivedDataPath build/macos_capture \
  ONLY_ACTIVE_ARCH=YES ARCHS="$(uname -m)" \
  CODE_SIGN_ENTITLEMENTS="$ent" CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM= PROVISIONING_PROFILE_SPECIFIER= build >>"$run/build.log" 2>&1

# The sandboxed app writes inside its own container.
container="$HOME/Library/Containers/com.ol1n.tyrianMobile/Data/tmp/kirian_capture/$id"
rm -rf "$container"
app="build/macos_capture/Build/Products/Profile/tyrian_mobile.app/Contents/MacOS/tyrian_mobile"
"$app" >"$run/capture.log" 2>&1 || true

test -f "$container/events.json" || { echo "capture failed, see $run/capture.log" >&2; exit 1; }
rm -rf "$run/capture"
cp -R "$container" "$run/capture"
echo "$run/capture"
