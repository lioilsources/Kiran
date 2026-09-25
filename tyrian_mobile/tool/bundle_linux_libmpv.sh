#!/usr/bin/env bash
# Copies libmpv and its private dependencies into a Flutter Linux bundle's lib/.
#
#   tool/bundle_linux_libmpv.sh build/linux/x64/release/bundle
#
# Why this exists: `media_kit_libs_linux` sounds like it ships the libraries,
# but all it does is wire up mimalloc — libmpv itself is expected to come from
# the distro. That is fine for a .deb, useless for a Steam depot: the player's
# machine owes us nothing, and without libmpv media_kit cannot initialise, so
# the game runs mute (see main.dart's _bundledLibmpv / the guarded init).
#
# What gets copied: libmpv plus everything `ldd` reports, minus EXCLUDE below.
# The exclusions are the libraries that MUST come from the host — the C/C++
# runtime, the graphics stack, and the audio daemons' client libraries. Bundling
# any of those either clashes with the host copy at symbol-resolution time or
# cuts us off from the host's device configuration.
set -euo pipefail

BUNDLE="${1:?usage: bundle_linux_libmpv.sh <bundle-dir>}"
DEST="$BUNDLE/lib"
[ -d "$DEST" ] || { echo "not a Flutter Linux bundle: $BUNDLE" >&2; exit 1; }

# Host-owned. Matched as a prefix against the soname.
#
# The GTK entries and everything under them (pango, fontconfig, freetype, zlib)
# are safe to leave out for a second reason: the Flutter runner links libgtk-3
# itself, so a machine that cannot run GTK cannot run the game either way.
EXCLUDE='^(ld-linux|libc\.|libm\.|libdl\.|libpthread\.|librt\.|libresolv\.|libnsl\.|libutil\.|libcrypt\.|libgcc_s\.|libstdc\+\+\.|libGL|libEGL|libOpenGL|libGLX|libGLdispatch|libdrm|libgbm|libX|libxcb|libwayland|libasound|libpulse|libjack|libpipewire|libsystemd|libdbus|libudev|libgtk-3|libgdk-3|libglib-2|libgobject-2|libgio-2|libgmodule-2|libcairo|libgdk_pixbuf|libpango|libatk|libfontconfig|libfreetype|libharfbuzz|libfribidi|libz\.)'

SRC="$(ldconfig -p | awk '/libmpv\.so\.[0-9]+/ {print $NF; exit}')"
[ -n "$SRC" ] || { echo "libmpv not found — apt-get install libmpv2 (or libmpv1)" >&2; exit 1; }
echo "libmpv: $SRC"

# ldd resolves the whole transitive graph in one shot, so no recursion needed.
copied=0
while read -r soname path; do
  [ -n "$path" ] && [ -f "$path" ] || continue
  if [[ "$soname" =~ $EXCLUDE ]]; then continue; fi
  # -L dereferences the symlink chain so the depot gets a real file, named by
  # the soname the loader will actually ask for.
  cp -Lf "$path" "$DEST/$soname"
  copied=$((copied + 1))
done < <(ldd "$SRC" | awk '/=> \//{print $1, $3}'; echo "$(basename "$SRC") $SRC")

echo "bundled $copied libraries into $DEST"

# A depot that ships a libmpv the loader then cannot satisfy is worse than no
# bundling at all — it fails at runtime on the player's machine instead of here.
MPV_SO="$(basename "$SRC")"
missing="$(LD_LIBRARY_PATH="$DEST" ldd "$DEST/$MPV_SO" | grep 'not found' || true)"
if [ -n "$missing" ]; then
  echo "unresolved after bundling:" >&2
  echo "$missing" >&2
  exit 1
fi
echo "OK: $MPV_SO resolves against the bundle"
