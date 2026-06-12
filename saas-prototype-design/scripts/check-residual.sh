#!/bin/bash
# 用法：bash check-residual.sh <file-or-glob>
# 检查原型文件常见残留：PM 术语 / 过时引用 / 死链 / 占位

set -uo pipefail
# Note: 不用 -e（grep 无匹配返回非零会导致提前退出）

if [ $# -lt 1 ]; then
  echo "用法：bash check-residual.sh <file>" >&2
  exit 1
fi

FILE="$1"
[ -f "$FILE" ] || { echo "❌ 文件不存在：$FILE"; exit 1; }

echo "=== 残留检查 · $FILE ==="
echo ""

echo "[1] PM 规划性术语（应为 0）："
grep -cE "主战场|本期|远期|TBD|TODO|待补充|MVP|v0\.x 启用|v[0-9]\.0 启用" "$FILE" || true

echo ""
echo "[2] Step / 步数残留（应一致 · 不应有 N/M 混杂）："
grep -oE "Step [0-9]" "$FILE" | sort -u
grep -oE "[0-9] 步向导" "$FILE" | sort -u

echo ""
echo "[3] 死链 href=\"#\"（数量）："
grep -cE 'href="#"' "$FILE" || true

echo ""
echo "[4] 占位按钮（无 data-action / 无 onclick / 非 submit / 非 disabled · 数量）："
# 注 1:POSIX ERE 不支持 (?!...) 负向断言(曾导致本项静默输出 0),改为提取+排除法
# 注 2:必须 -o 逐标签提取——按行匹配时,同行多个 button 会被第一个的 onclick 掩护漏检
# 注 3:disabled 是显式声明的非交互态,不算"忘绑动作"的占位
PB=$(grep -oE '<button[^>]*>' "$FILE" | grep -cvE 'data-action|onclick|type="submit"|disabled' || true)
echo "${PB:-0}"
if [ "${PB:-0}" -gt 0 ]; then
  grep -oE '<button[^>]*>' "$FILE" | grep -vE 'data-action|onclick|type="submit"|disabled' | head -3 | sed 's/^/  ↳ /'
fi

echo ""
echo "[5] data-action 全部种类："
grep -oE 'data-action="[a-z-]+"' "$FILE" | sort -u

echo ""
echo "[6] Modal / Drawer 配对："
MO_T=$(grep -cE 'data-action="modal-open"' "$FILE")
MO_C=$(grep -cE 'class="modal-mask"' "$FILE")
DO_T=$(grep -cE 'data-action="drawer-open"|showDrawer\(' "$FILE")
DO_C=$(grep -cE 'class="drawer[ "]' "$FILE")
echo "  Modal 触发数: $MO_T · 容器数: $MO_C $([ $MO_T -gt 0 ] && [ $MO_C -eq 0 ] && echo '⚠️ 触发无对应容器')"
echo "  Drawer 触发数: $DO_T · 容器数: $DO_C $([ $DO_T -gt 0 ] && [ $DO_C -eq 0 ] && echo '⚠️ 触发无对应容器')"

echo ""
echo "[7] prototype-meta 是否存在："
if grep -q "prototype-meta" "$FILE"; then
  echo "  ✓ 已就位"
  grep -A1 "version:" "$FILE" | head -1
  grep -A1 "last-modified:" "$FILE" | head -1
else
  echo "  ⚠️  未配置 prototype-meta（建议补全）"
fi

echo ""
echo "=== 行数 ==="
wc -l "$FILE"
