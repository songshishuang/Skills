#!/bin/bash
# 用法：bash snapshot.sh <file-or-dir>
# 备份单文件或整目录到 .history/，文件名带时间戳

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "用法：bash snapshot.sh <file-or-dir>" >&2
  exit 1
fi

TARGET="$1"
STAMP=$(date +%Y%m%d-%H%M)

if [ -f "$TARGET" ]; then
  # 单文件
  DIR=$(dirname "$TARGET")
  BASE=$(basename "$TARGET")
  EXT="${BASE##*.}"
  NAME="${BASE%.*}"
  HIST_DIR="$DIR/.history"
  mkdir -p "$HIST_DIR"
  SNAP="$HIST_DIR/${NAME}.${STAMP}.${EXT}"
  cp "$TARGET" "$SNAP"
  echo "✓ 已备份 → $SNAP ($(wc -l < "$SNAP") 行)"
elif [ -d "$TARGET" ]; then
  # 整目录
  PARENT=$(dirname "$TARGET")
  NAME=$(basename "$TARGET")
  HIST_DIR="$PARENT/.history-dir"
  mkdir -p "$HIST_DIR"
  SNAP_DIR="$HIST_DIR/${NAME}.${STAMP}"
  cp -r "$TARGET" "$SNAP_DIR"
  echo "✓ 已备份目录 → $SNAP_DIR ($(find "$SNAP_DIR" -type f | wc -l) 文件)"
else
  echo "❌ 找不到文件或目录：$TARGET" >&2
  exit 1
fi
