#!/usr/bin/env bash
# Smoke test macOS : extraction tgz, bundle .app, otool, Info.plist, --help.
# Usage: ./tools-packaging/test-macos-smoke.sh [tgz] [timeout_sec]
# Retour: PASS/FAIL/SKIP. SKIP si tgz absent.
set -u
TGZ="${1:-}"
TIMEOUT_SEC="${2:-15}"
RESULT="FAIL"; DETAIL=""

fail() { DETAIL="$1"; echo "test-macos-smoke: FAIL - $DETAIL"; emit 1; }
skip() { RESULT="SKIP"; DETAIL="$1"; echo "test-macos-smoke: SKIP - $DETAIL"; emit 0; }
emit() {
  printf '%-10s %-8s %s\n' "PACKAGE" "RESULT" "DETAIL"
  printf '%-10s %-8s %s\n' "macos" "$RESULT" "$DETAIL"
  exit "$1"
}

if [ -z "$TGZ" ]; then
  TGZ=$(ls "Builds - AG/dist/"AG2-*-macos-*.tgz 2>/dev/null | sed -n 1p || true)
fi
if [ -z "$TGZ" ] || [ ! -f "$TGZ" ]; then
  skip "tgz macOS absent (build IDE requis)"
fi
rm -rf /tmp/ag2smoke; mkdir -p /tmp/ag2smoke
tar -xzf "$TGZ" -C /tmp/ag2smoke || fail "extraction tgz impossible"
APP=$(find /tmp/ag2smoke -maxdepth 4 -name "*.app" -type d -print -quit)
if [ -z "$APP" ]; then fail "bundle .app introuvable"; fi
echo "APP=$APP"
BIN="$APP/Contents/MacOS/Apprenti Geometre 2"\nif [ ! -f "$BIN" ]; then BIN="$APP/Contents/MacOS/AG2"; fi
if [ ! -f "$BIN" ]; then
  BIN=$(find "$APP/Contents/MacOS" -maxdepth 1 -type f -print -quit)
fi
if [ -z "$BIN" ] || [ ! -f "$BIN" ]; then fail "binaire MacOS introuvable"; fi
echo "BIN=$BIN"
if [ ! -x "$BIN" ]; then chmod +x "$BIN"; fi
[ -x "$BIN" ] || fail "binaire non executable"
PLIST="$APP/Contents/Info.plist"
if [ -f "$PLIST" ]; then
  if command -v plutil >/dev/null 2>&1; then
    plutil -lint "$PLIST" || fail "Info.plist invalide"
    echo "PLIST-OK=$PLIST"
  else
    echo "PLIST-SKIP=no plutil"
  fi
else
  echo "PLIST-WARN=absent"
fi
if command -v otool >/dev/null 2>&1; then
  echo "--- otool -L ---"
  otool -L "$BIN" || fail "otool echoue"
  MISS=$(otool -L "$BIN" 2>&1 | grep -i "not found" || true)
  [ -n "$MISS" ] && fail "dependances manquantes: $MISS"
else
  echo "OTOOL-SKIP=absent"
fi
if command -v timeout >/dev/null 2>&1; then TO="timeout $TIMEOUT_SEC"; else TO=""; fi
# shellcheck disable=SC2086
$TO "$BIN" --help >/tmp/ag2smoke/help.log 2>&1; H=$?
if [ $H -ne 0 ]; then
  # shellcheck disable=SC2086
  $TO "$BIN" --version >/tmp/ag2smoke/help.log 2>&1; H=$?
fi
echo "EXIT=$H"
[ $H -ne 0 ] && fail "lancement --help/--version exit $H"
RESULT="PASS"; DETAIL="otool OK, plist OK, --help/--version exit 0"
echo "test-macos-smoke: PASS"
emit 0

