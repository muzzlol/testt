#!/usr/bin/env bash
# Generate GIF frames for gecko-eats-bug animation.
# Outputs: assets/gecko-eater.gif
set -euo pipefail

cd "$(dirname "$0")"

OUT_DIR="frames"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# Timeline (40 frames @ 10fps = 4s loop)
# Frames 0-15 : bug walks in (x: 380 -> 150)
# Frames 16-19: tongue extending
# Frame 20    : chomp (bug gone, mouth open)
# Frames 21-22: tongue retracting
# Frames 23-39: pause (gecko alone)
TOTAL=40

# GameBoy palette
C_DARKEST="#0f380f"
C_DARK="#306230"
C_LIGHT="#8bac0f"
C_LIGHTEST="#9bbc0f"
C_RED="#e83b3b"
C_REDDARK="#a91e1e"

# Static gecko SVG fragment (no animation)
read -r -d '' GECKO <<'GECKO_EOF' || true
<!-- ground -->
<g fill="#306230"><rect x="0" y="84" width="400" height="4"/></g>
<g fill="#0f380f"><rect x="0" y="88" width="400" height="4"/></g>
<g fill="#8bac0f">
  <rect x="20" y="84" width="4" height="4"/>
  <rect x="72" y="84" width="4" height="4"/>
  <rect x="140" y="84" width="4" height="4"/>
  <rect x="208" y="84" width="4" height="4"/>
  <rect x="276" y="84" width="4" height="4"/>
  <rect x="344" y="84" width="4" height="4"/>
</g>
<!-- gecko outline -->
<g fill="#0f380f">
  <rect x="8" y="72" width="4" height="4"/>
  <rect x="12" y="68" width="4" height="4"/>
  <rect x="16" y="68" width="4" height="4"/>
  <rect x="20" y="68" width="4" height="4"/>
  <rect x="24" y="64" width="4" height="4"/>
  <rect x="28" y="60" width="4" height="4"/>
  <rect x="32" y="56" width="4" height="4"/><rect x="36" y="56" width="4" height="4"/>
  <rect x="40" y="56" width="4" height="4"/><rect x="44" y="56" width="4" height="4"/>
  <rect x="48" y="56" width="4" height="4"/><rect x="52" y="56" width="4" height="4"/>
  <rect x="56" y="56" width="4" height="4"/>
  <rect x="60" y="52" width="4" height="4"/><rect x="64" y="52" width="4" height="4"/>
  <rect x="68" y="52" width="4" height="4"/><rect x="72" y="52" width="4" height="4"/>
  <rect x="76" y="52" width="4" height="4"/>
  <rect x="80" y="48" width="4" height="4"/><rect x="84" y="48" width="4" height="4"/>
  <rect x="88" y="48" width="4" height="4"/><rect x="92" y="48" width="4" height="4"/>
  <rect x="96" y="52" width="4" height="4"/>
  <rect x="100" y="56" width="4" height="4"/>
  <rect x="100" y="60" width="4" height="4"/>
  <rect x="104" y="60" width="4" height="4"/>
  <rect x="104" y="64" width="4" height="4"/>
  <rect x="100" y="68" width="4" height="4"/>
  <rect x="96" y="68" width="4" height="4"/>
  <rect x="24" y="76" width="4" height="4"/><rect x="28" y="76" width="4" height="4"/>
  <rect x="32" y="76" width="4" height="4"/><rect x="36" y="76" width="4" height="4"/>
  <rect x="40" y="76" width="4" height="4"/><rect x="44" y="76" width="4" height="4"/>
  <rect x="48" y="76" width="4" height="4"/><rect x="52" y="76" width="4" height="4"/>
  <rect x="56" y="76" width="4" height="4"/><rect x="60" y="76" width="4" height="4"/>
  <rect x="64" y="76" width="4" height="4"/><rect x="68" y="76" width="4" height="4"/>
  <rect x="72" y="76" width="4" height="4"/><rect x="76" y="76" width="4" height="4"/>
  <rect x="80" y="76" width="4" height="4"/><rect x="84" y="76" width="4" height="4"/>
  <rect x="88" y="72" width="4" height="4"/><rect x="92" y="72" width="4" height="4"/>
</g>
<!-- gecko fill -->
<g fill="#306230">
  <rect x="24" y="68" width="4" height="4"/>
  <rect x="28" y="64" width="4" height="4"/>
  <rect x="32" y="60" width="4" height="4"/><rect x="36" y="60" width="4" height="4"/>
  <rect x="40" y="60" width="4" height="4"/><rect x="44" y="60" width="4" height="4"/>
  <rect x="48" y="60" width="4" height="4"/><rect x="52" y="60" width="4" height="4"/>
  <rect x="56" y="60" width="4" height="4"/>
  <rect x="60" y="56" width="4" height="4"/><rect x="64" y="56" width="4" height="4"/>
  <rect x="68" y="56" width="4" height="4"/><rect x="72" y="56" width="4" height="4"/>
  <rect x="76" y="56" width="4" height="4"/>
  <rect x="80" y="52" width="4" height="4"/><rect x="84" y="52" width="4" height="4"/>
  <rect x="88" y="52" width="4" height="4"/><rect x="92" y="52" width="4" height="4"/>
  <rect x="96" y="56" width="4" height="4"/>
  <rect x="96" y="64" width="4" height="4"/>
  <rect x="32" y="64" width="4" height="4"/><rect x="36" y="64" width="4" height="4"/>
  <rect x="40" y="64" width="4" height="4"/><rect x="44" y="64" width="4" height="4"/>
  <rect x="48" y="64" width="4" height="4"/><rect x="52" y="64" width="4" height="4"/>
  <rect x="56" y="64" width="4" height="4"/>
  <rect x="60" y="60" width="4" height="4"/><rect x="64" y="60" width="4" height="4"/>
  <rect x="68" y="60" width="4" height="4"/><rect x="72" y="60" width="4" height="4"/>
  <rect x="76" y="60" width="4" height="4"/>
  <rect x="80" y="56" width="4" height="4"/><rect x="84" y="56" width="4" height="4"/>
  <rect x="88" y="56" width="4" height="4"/><rect x="92" y="56" width="4" height="4"/>
  <rect x="28" y="68" width="4" height="4"/><rect x="32" y="68" width="4" height="4"/>
  <rect x="36" y="68" width="4" height="4"/><rect x="40" y="68" width="4" height="4"/>
  <rect x="44" y="68" width="4" height="4"/><rect x="48" y="68" width="4" height="4"/>
  <rect x="52" y="68" width="4" height="4"/><rect x="56" y="68" width="4" height="4"/>
  <rect x="60" y="68" width="4" height="4"/><rect x="64" y="68" width="4" height="4"/>
  <rect x="68" y="68" width="4" height="4"/><rect x="72" y="68" width="4" height="4"/>
  <rect x="76" y="68" width="4" height="4"/><rect x="80" y="68" width="4" height="4"/>
  <rect x="84" y="68" width="4" height="4"/><rect x="88" y="68" width="4" height="4"/>
  <rect x="92" y="68" width="4" height="4"/>
  <rect x="28" y="72" width="4" height="4"/><rect x="32" y="72" width="4" height="4"/>
  <rect x="36" y="72" width="4" height="4"/><rect x="40" y="72" width="4" height="4"/>
  <rect x="44" y="72" width="4" height="4"/><rect x="48" y="72" width="4" height="4"/>
  <rect x="52" y="72" width="4" height="4"/><rect x="56" y="72" width="4" height="4"/>
  <rect x="60" y="72" width="4" height="4"/><rect x="64" y="72" width="4" height="4"/>
  <rect x="68" y="72" width="4" height="4"/><rect x="72" y="72" width="4" height="4"/>
  <rect x="76" y="72" width="4" height="4"/><rect x="80" y="72" width="4" height="4"/>
  <rect x="84" y="72" width="4" height="4"/>
</g>
<!-- highlights -->
<g fill="#8bac0f">
  <rect x="84" y="52" width="4" height="4"/>
  <rect x="68" y="56" width="4" height="4"/>
  <rect x="40" y="60" width="4" height="4"/>
  <rect x="44" y="60" width="4" height="4"/>
</g>
<!-- eye -->
<rect x="88" y="56" width="4" height="4" fill="#0f380f"/>
<rect x="92" y="56" width="4" height="4" fill="#9bbc0f"/>
<rect x="92" y="56" width="2" height="2" fill="#0f380f"/>
<!-- legs -->
<g fill="#0f380f">
  <rect x="36" y="80" width="4" height="4"/>
  <rect x="40" y="80" width="4" height="4"/>
  <rect x="76" y="80" width="4" height="4"/>
  <rect x="80" y="80" width="4" height="4"/>
</g>
GECKO_EOF

# Bug SVG fragment, positioned by translate(x, ybob)
bug_at() {
  local tx=$1
  local ty=$2
  cat <<BUG
<g transform="translate($tx, $ty)">
  <rect x="0" y="68" width="4" height="4" fill="#0f380f"/>
  <rect x="4" y="68" width="4" height="4" fill="#0f380f"/>
  <rect x="8" y="68" width="4" height="4" fill="#0f380f"/>
  <rect x="0" y="64" width="4" height="4" fill="#306230"/>
  <rect x="4" y="64" width="4" height="4" fill="#306230"/>
  <rect x="8" y="64" width="4" height="4" fill="#306230"/>
  <rect x="-4" y="68" width="4" height="4" fill="#0f380f"/>
  <rect x="-4" y="60" width="2" height="4" fill="#0f380f"/>
  <rect x="-8" y="56" width="2" height="4" fill="#0f380f"/>
  <rect x="4" y="64" width="2" height="2" fill="#8bac0f"/>
  <rect x="0" y="72" width="2" height="2" fill="#0f380f"/>
  <rect x="6" y="72" width="2" height="2" fill="#0f380f"/>
  <rect x="10" y="72" width="2" height="2" fill="#0f380f"/>
</g>
BUG
}

# Tongue: red rect from x=108 with given width; tip blob at (108+width, 64)
tongue_at() {
  local w=$1
  if [ "$w" -le 0 ]; then return; fi
  local tip_x=$((108 + w))
  cat <<T
<rect x="108" y="64" width="$w" height="4" fill="#e83b3b"/>
<rect x="$tip_x" y="64" width="4" height="4" fill="#a91e1e"/>
T
}

# Mouth overlay: open or closed
mouth_at() {
  local open=$1
  if [ "$open" -eq 1 ]; then
    echo '<rect x="100" y="64" width="8" height="8" fill="#0f380f"/>'
  else
    echo '<rect x="100" y="64" width="8" height="4" fill="#0f380f"/>'
  fi
}

# Build each frame
for ((i=0; i<TOTAL; i++)); do
  bug_x=0
  bug_y=0
  bug_visible=1
  tongue_w=0
  mouth_open=0

  if (( i <= 15 )); then
    # bug walks in: 380 -> 150 over frames 0..15
    bug_x=$(( 380 - (i * (380 - 150)) / 15 ))
    # bobbing
    if (( i % 2 == 0 )); then bug_y=0; else bug_y=-1; fi
  elif (( i == 16 )); then
    bug_x=150; tongue_w=10
  elif (( i == 17 )); then
    bug_x=150; tongue_w=22
  elif (( i == 18 )); then
    bug_x=150; tongue_w=34
  elif (( i == 19 )); then
    bug_x=150; tongue_w=44
  elif (( i == 20 )); then
    # chomp! bug gone, mouth open, tongue retracting
    bug_visible=0; tongue_w=30; mouth_open=1
  elif (( i == 21 )); then
    bug_visible=0; tongue_w=15; mouth_open=1
  elif (( i == 22 )); then
    bug_visible=0; tongue_w=0; mouth_open=0
  else
    bug_visible=0; tongue_w=0; mouth_open=0
  fi

  FRAME_FILE="$OUT_DIR/frame_$(printf '%03d' $i).svg"
  {
    echo '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100" width="400" height="100" shape-rendering="crispEdges">'
    echo '<rect width="400" height="100" fill="#9bbc0f"/>'
    echo "$GECKO"
    if (( bug_visible == 1 )); then
      bug_at "$bug_x" "$bug_y"
    fi
    tongue_at "$tongue_w"
    mouth_at "$mouth_open"
    echo '</svg>'
  } > "$FRAME_FILE"

  # rasterize to PNG
  magick -background "#9bbc0f" "$FRAME_FILE" "$OUT_DIR/frame_$(printf '%03d' $i).png"
done

# Assemble GIF at 10fps (-> 10 delay/100ths, so 10 = 10fps means delay 10)
# delay 10 = 10/100s per frame = 10fps
magick -delay 10 -loop 0 "$OUT_DIR"/frame_*.png -layers Optimize gecko-eater.gif

echo "Created: $(pwd)/gecko-eater.gif"
ls -lh gecko-eater.gif
