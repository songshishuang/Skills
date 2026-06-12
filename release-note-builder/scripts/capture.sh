#!/bin/bash
# capture.sh — macOS 截图 helper（release-note-builder）
# 把目标 Chrome 窗口提到前台，按窗口区域截图，可选裁掉顶部 N 像素（浏览器边框 + 扩展"录制中"横幅）。
#
# 用法:  capture.sh <out.png> [crop_top_px] [url_keyword]
#   crop_top_px  裁掉顶部多少像素（默认 0）。先截一张原图，Read 量出"应用内容真正起始行"再定，不要照搬。
#   url_keyword  匹配目标 Chrome 窗口标签 URL 的关键词（默认用最前窗口）。
#
# 注意:
#   - bounds 运行时由 AppleScript 动态取（支持多显示器，不硬编码）。
#   - Retina 屏 screencapture 输出可能是 2x 像素，crop_top_px 按"截出图的实际像素"量。
#   - 截图前请把鼠标光标移到角落、关掉无关弹窗，避免入镜。
set -e
out="$1"; crop="${2:-0}"; kw="$3"
[ -z "$out" ] && { echo "用法: capture.sh <out.png> [crop_top_px] [url_keyword]"; exit 1; }

bounds=$(osascript <<EOF
tell application "Google Chrome"
  activate
  set target to missing value
  if "$kw" is not "" then
    repeat with w in windows
      repeat with t in tabs of w
        if (URL of t) contains "$kw" then set target to w
      end repeat
    end repeat
  end if
  if target is missing value then set target to front window
  set index of target to 1
  delay 0.3
  set b to bounds of target
  return (item 1 of b as string) & "," & (item 2 of b as string) & "," & (item 3 of b as string) & "," & (item 4 of b as string)
end tell
EOF
)
IFS=',' read -r L T R B <<< "$bounds"
W=$((R-L)); H=$((B-T))
raw="${TMPDIR:-/tmp}/_rnb_raw.png"
screencapture -x -R${L},${T},${W},${H} "$raw"
if [ "$crop" -gt 0 ]; then
  python3 - "$raw" "$out" "$crop" <<'PY'
import sys
from PIL import Image
raw, out, crop = sys.argv[1], sys.argv[2], int(sys.argv[3])
im = Image.open(raw); w, h = im.size
im.crop((0, crop, w, h)).save(out)
print("saved", out, "size", im.crop((0, crop, w, h)).size)
PY
else
  cp "$raw" "$out"; echo "saved $out (no crop)"
fi
rm -f "$raw"
