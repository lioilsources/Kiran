#!/bin/sh
# Raw store screenshots from the real app on a simulator.
#
#   tool/store_screenshots.sh <simulator name or udid> [out dir] [lang]
#
# Drives test_driver/store_app.dart (seeded save, every skin owned) through
# the scenes in test_driver/store_app_test.dart and captures each with simctl.
# The status bar is pinned to 9:41 / full battery and the simulator's language
# set for the run, then both are restored. Captions and store sizes come after:
# marketing/screenshots/compose.py.
set -u
SIM=${1:?simulator name or udid}
OUT=${2:-build/store_screenshots}
LANG_CODE=${3:-ja}

cd "$(dirname "$0")/.."
xcrun simctl boot "$SIM" 2>/dev/null
xcrun simctl bootstatus "$SIM" -b >/dev/null
xcrun simctl status_bar "$SIM" override --time 9:41 \
  --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3
xcrun simctl spawn "$SIM" defaults write -g AppleLanguages -array "$LANG_CODE"

SHOTS_DIR="$OUT" SHOTS_DEVICE="$SIM" flutter drive \
  --driver=test_driver/store_app_test.dart \
  --target=test_driver/store_app.dart \
  -d "$SIM"
rc=$?

xcrun simctl spawn "$SIM" defaults delete -g AppleLanguages
xcrun simctl status_bar "$SIM" clear
exit $rc
