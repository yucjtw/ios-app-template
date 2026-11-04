#!/usr/bin/env bash
# Rename the template project in place.
#
#   scripts/rename.sh <NewAppName> <bundle-id-prefix>
#   scripts/rename.sh MyApp com.mycompany
#
# Replaces every occurrence of the template name (iOSAppTemplate) and the
# template bundle id prefix (com.example) in file contents and in file and
# directory names, then removes itself. Run it once, right after creating a
# repo from this template, before adding any code of your own.
set -euo pipefail

OLD_NAME="iOSAppTemplate"
OLD_PREFIX="com.example"

NEW_NAME="${1:-}"
NEW_PREFIX="${2:-}"
if [[ -z "$NEW_NAME" || -z "$NEW_PREFIX" ]]; then
  echo "usage: $0 <NewAppName> <bundle-id-prefix>" >&2
  echo "   eg: $0 MyApp com.mycompany" >&2
  exit 1
fi
if [[ ! "$NEW_NAME" =~ ^[A-Za-z][A-Za-z0-9]*$ ]]; then
  echo "error: app name must be a valid Swift identifier (letters and digits, no spaces or dashes): $NEW_NAME" >&2
  exit 1
fi
if [[ ! "$NEW_PREFIX" =~ ^[A-Za-z0-9.-]+$ ]]; then
  echo "error: bundle id prefix must look like com.company: $NEW_PREFIX" >&2
  exit 1
fi

cd "$(dirname "$0")/.."

# 1. File contents. Bundle id first, so "com.example.iOSAppTemplate" becomes
#    "<prefix>.iOSAppTemplate" before the name pass turns it into "<prefix>.<NewName>".
grep -rl --exclude-dir=.git --exclude-dir=scripts -e "$OLD_PREFIX" -e "$OLD_NAME" . | while IFS= read -r f; do
  sed -i '' -e "s/$OLD_PREFIX\.$OLD_NAME/$NEW_PREFIX.$OLD_NAME/g" -e "s/$OLD_NAME/$NEW_NAME/g" "$f"
done

# 2. File and directory names, deepest first so parents are renamed after children.
find . -path ./.git -prune -o -name "*$OLD_NAME*" -print | awk '{ print length, $0 }' | sort -rn | cut -d' ' -f2- | while IFS= read -r p; do
  dir="$(dirname "$p")"
  base="$(basename "$p")"
  mv "$p" "$dir/${base//$OLD_NAME/$NEW_NAME}"
done

# 3. Remove this script; the template name no longer exists anywhere.
rm -- "$0"
rmdir scripts 2>/dev/null || true

echo "Renamed $OLD_NAME -> $NEW_NAME, bundle ids now under $NEW_PREFIX."
echo "Next: open $NEW_NAME.xcodeproj once and pick your Team under Signing & Capabilities."
