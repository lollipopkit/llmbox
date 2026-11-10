#!/usr/bin/env bash
# Fails when a native library in the given APKs has a LOAD segment aligned
# below 16 KB: a 16 KB-page device refuses to load it.
#   READELF  llvm-readelf, e.g. from the NDK
set -euo pipefail

: "${READELF:?set READELF to llvm-readelf}"
(( $# )) || { echo "usage: $0 APK..." >&2; exit 2; }

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
checked=0
bad=0
for apk in "$@"; do
  dir="$work/$(basename "$apk")"
  unzip -q "$apk" 'lib/*' -d "$dir"
  while IFS= read -r -d '' so; do
    checked=$((checked + 1))
    name="$(basename "$apk"): ${so#"$dir/"}"
    headers="$("$READELF" -lW "$so")" || { echo "::error::$name: llvm-readelf failed"; exit 1; }
    aligns="$(awk '$1 == "LOAD" { print $NF }' <<<"$headers")"
    [ -n "$aligns" ] || { echo "::error::$name: no LOAD segment"; exit 1; }
    while read -r align; do
      if (( align < 0x4000 )); then
        echo "::error::$name has LOAD align $align"
        bad=1
        break
      fi
    done <<<"$aligns"
  done < <(find "$dir/lib" -name '*.so' -print0)
done

(( checked )) || { echo "::error::no native library found"; exit 1; }
(( bad )) && exit 1
echo "$checked native libraries, all 16 KB aligned"
