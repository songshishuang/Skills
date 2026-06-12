#!/usr/bin/env bash
#
# PM Project Scaffolding · init.sh
# 一键生成标准 PM 项目目录骨架
#
# 用法：
#   bash init.sh --name "proj-name" --tagline "一句话定位" \
#                --type "ai-saas|generic-saas|mobile-app|internal-tool" \
#                --roles "operator,agent,admin" \
#                --target "/abs/parent/path"
#
# 退出码：
#   0  成功
#   1  参数错误
#   2  目标目录已存在
#   3  模板目录找不到
#

set -euo pipefail

# ============== 参数解析 ==============
NAME=""
TAGLINE=""
TYPE=""
ROLES=""
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)     NAME="$2"; shift 2 ;;
    --tagline)  TAGLINE="$2"; shift 2 ;;
    --type)     TYPE="$2"; shift 2 ;;
    --roles)    ROLES="$2"; shift 2 ;;
    --target)   TARGET="$2"; shift 2 ;;
    *)
      echo "❌ 未知参数: $1" >&2
      exit 1
      ;;
  esac
done

# ============== 参数校验 ==============
if [[ -z "$NAME" || -z "$TAGLINE" || -z "$TYPE" || -z "$TARGET" ]]; then
  echo "❌ 缺少必填参数。需要 --name --tagline --type --target" >&2
  exit 1
fi
# NAME 字符集硬校验（目录名安全：防 a/b 嵌套与 sed 注入面，与 SKILL.md 命名约定一致）
if [[ ! "$NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "❌ --name 仅允许小写字母/数字/连字符（收到: $NAME）" >&2
  exit 1
fi

case "$TYPE" in
  ai-saas|generic-saas|mobile-app|internal-tool) ;;
  *)
    echo "❌ --type 必须为 ai-saas / generic-saas / mobile-app / internal-tool 之一" >&2
    exit 1
    ;;
esac

if [[ ! -d "$TARGET" ]]; then
  echo "❌ 目标父目录不存在: $TARGET" >&2
  exit 1
fi

PROJECT_DIR="$TARGET/$NAME"
if [[ -e "$PROJECT_DIR" ]]; then
  echo "❌ 项目目录已存在: $PROJECT_DIR" >&2
  exit 2
fi

# ============== 找到模板目录 ==============
# 脚本所在目录 = .../skills/pm-project-scaffolding/scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$SKILL_DIR/assets/templates"

if [[ ! -d "$TEMPLATES_DIR" ]]; then
  echo "❌ 找不到模板目录: $TEMPLATES_DIR" >&2
  exit 3
fi

# ============== 派生变量 ==============
DATE_TODAY="$(date +%Y-%m-%d)"
YEAR_MONTH="$(date +%Y-%m)"

# 决定要不要 prototypes / skills 目录
HAS_PROTOTYPES="no"
HAS_SKILLS="no"
case "$TYPE" in
  ai-saas)        HAS_PROTOTYPES="yes"; HAS_SKILLS="yes" ;;
  generic-saas)   HAS_PROTOTYPES="yes" ;;
  mobile-app)     HAS_PROTOTYPES="yes" ;;
  internal-tool)  ;;
esac

# roles 默认值
if [[ -z "$ROLES" && "$HAS_PROTOTYPES" == "yes" ]]; then
  ROLES="user"
fi

# ============== 占位符替换函数 ==============
render_file() {
  local src="$1"
  local dst="$2"
  if [[ ! -f "$src" ]]; then
    echo "⚠️  模板不存在，跳过: $src" >&2
    return
  fi
  # 用 sed 替换占位符——replacement 侧先转义 sed 特殊字符（& 回插原文、| 撞分隔符、\ 转义链），
  # 否则 tagline 含 "AI & Data" 类文案会损坏渲染（Y-012 大修实测）
  local esc_name esc_tagline esc_roles
  esc_name=$(printf '%s' "$NAME" | sed -e 's/[&|\\]/\\&/g')
  esc_tagline=$(printf '%s' "$TAGLINE" | sed -e 's/[&|\\]/\\&/g')
  esc_roles=$(printf '%s' "$ROLES" | sed -e 's/[&|\\]/\\&/g')
  sed \
    -e "s|{{PROJECT_NAME}}|$esc_name|g" \
    -e "s|{{PROJECT_TAGLINE}}|$esc_tagline|g" \
    -e "s|{{PROJECT_TYPE}}|$TYPE|g" \
    -e "s|{{ROLES}}|$esc_roles|g" \
    -e "s|{{DATE}}|$DATE_TODAY|g" \
    -e "s|{{YEAR_MONTH}}|$YEAR_MONTH|g" \
    "$src" > "$dst"
}

# ============== 开始创建 ==============
echo "🚀 开始初始化项目: $NAME"
echo "   类型: $TYPE"
echo "   位置: $PROJECT_DIR"
echo ""

mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# --- 顶层文件 ---
echo "📄 顶层文件..."
render_file "$TEMPLATES_DIR/README.md" "README.md"
render_file "$TEMPLATES_DIR/CHANGELOG.md" "CHANGELOG.md"
render_file "$TEMPLATES_DIR/CLAUDE.md" "CLAUDE.md"

# --- docs/ ---
echo "📚 docs/ ..."
mkdir -p docs/{prd,decisions,product-planning,market-research/{competitors,industry-reports,trends},user-research,data-analysis,releases}
render_file "$TEMPLATES_DIR/docs/roadmap.md" "docs/roadmap.md"
render_file "$TEMPLATES_DIR/docs/prd/README.md" "docs/prd/README.md"
render_file "$TEMPLATES_DIR/docs/decisions/README.md" "docs/decisions/README.md"
render_file "$TEMPLATES_DIR/docs/decisions/ADR-template.md" "docs/decisions/ADR-template.md"
render_file "$TEMPLATES_DIR/docs/product-planning/README.md" "docs/product-planning/README.md"
render_file "$TEMPLATES_DIR/docs/market-research/README.md" "docs/market-research/README.md"
render_file "$TEMPLATES_DIR/docs/user-research/README.md" "docs/user-research/README.md"
render_file "$TEMPLATES_DIR/docs/data-analysis/README.md" "docs/data-analysis/README.md"
render_file "$TEMPLATES_DIR/docs/releases/README.md" "docs/releases/README.md"
render_file "$TEMPLATES_DIR/docs/releases/TEMPLATE.md" "docs/releases/TEMPLATE.md"

# --- docs/wiki/ LLM Wiki 骨架（真相源 = pm-wiki-maintainer/templates，本脚本只消费不自造） ---
echo "📚 docs/wiki/ LLM Wiki 骨架..."
mkdir -p docs/wiki/{concepts,entities/{customers,competitors,products,roles},decisions,topics}
touch docs/wiki/{concepts,decisions,topics}/.gitkeep docs/wiki/entities/{customers,competitors,products,roles}/.gitkeep  # 防 git init 后空目录丢失

# 探测 pm-wiki-maintainer 模板（同仓 bundle 布局 → 各平台安装目录），找到即复制（防双源漂移）
WIKI_TPL=""
for cand in "$SKILL_DIR/../pm-wiki-maintainer/templates" \
            "$HOME/.claude/skills/pm-wiki-maintainer/templates" \
            "$HOME/.codex/skills/pm-wiki-maintainer/templates"; do
  if [[ -f "$cand/INDEX.md" && -f "$cand/LOG.md" && -f "$cand/CLAUDE-wiki.md" ]]; then
    WIKI_TPL="$cand"; break
  fi
done

if [[ -n "$WIKI_TPL" ]]; then
  sed -e "s|{{DATE}}|$DATE_TODAY|g" "$WIKI_TPL/INDEX.md" > docs/wiki/index.md
  sed -e "s|{{DATE}}|$DATE_TODAY|g" "$WIKI_TPL/LOG.md"   > docs/wiki/log.md
  cp "$WIKI_TPL/CLAUDE-wiki.md" docs/wiki/CLAUDE.md
  echo "  ✅ wiki 三件（index/log/CLAUDE）← pm-wiki-maintainer 模板真相源"
else
  # 降级：未装 pm-wiki-maintainer 时给最小占位骨架，并提示装后重建（不再维护完整内联副本，防双源漂移）
  printf '# %s · Wiki Index\n\n> 占位骨架（pm-wiki-maintainer 未安装）。安装后对 AI 说「初始化 wiki 骨架」即按其模板重建。\n\n最后更新：%s · 总页数：0\n' "$NAME" "$DATE_TODAY" > docs/wiki/index.md
  printf '# Wiki Maintenance Log\n\n## [%s] init | 占位骨架（scaffolding 降级模式）\n' "$DATE_TODAY" > docs/wiki/log.md
  printf '# Wiki 工作规则（占位）\n\n> 本目录按 Karpathy LLM Wiki 模式维护。完整工作规则随 pm-wiki-maintainer skill 安装后重建。\n' > docs/wiki/CLAUDE.md
  echo "  ⚠️ pm-wiki-maintainer 模板未找到——已建占位骨架，建议安装后说「初始化 wiki 骨架」重建"
fi

TAGLINE_TBL="${TAGLINE//|/\\|}"  # markdown 表格单元内 | 须转义，防撑列
cat > docs/wiki/glossary.md <<WIKI_GLOSSARY_EOF
# Glossary · 术语表

> 项目专属术语 + 业务对象命名约定。**保持 PRD / 架构图 / 训练材料术语一致**。

| 术语 | 定义 | 首次出现 |
|---|---|---|
| ${NAME} | ${TAGLINE_TBL} | ${DATE_TODAY} |

（后续由 pm-wiki-maintainer 增量沉淀）
WIKI_GLOSSARY_EOF

# --- prototypes/（条件生成） ---
if [[ "$HAS_PROTOTYPES" == "yes" ]]; then
  echo "🎨 prototypes/ ..."
  mkdir -p prototypes/assets
  render_file "$TEMPLATES_DIR/prototypes/README.md" "prototypes/README.md"
  render_file "$TEMPLATES_DIR/prototypes/index.html" "prototypes/index.html"
  # 按 roles 创建子目录
  IFS=',' read -ra ROLE_ARRAY <<< "$ROLES"
  for role in "${ROLE_ARRAY[@]}"; do
    role_trimmed="$(echo "$role" | xargs)"
    # 与 NAME 同款字符集硬校验——防 ../ 路径穿越在 target 外建目录（Y-012 复评破坏性实测确认的洞）
    if [[ ! "$role_trimmed" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
      echo "  ⚠️ 跳过非法角色名: $role_trimmed（仅允许小写字母/数字/连字符）" >&2
      continue
    fi
    mkdir -p "prototypes/$role_trimmed"
    echo "# prototypes/$role_trimmed" > "prototypes/$role_trimmed/README.md"
    echo "" >> "prototypes/$role_trimmed/README.md"
    echo "$role_trimmed 工作台原型——按业务场景描述这个角色的核心使用流程。" >> "prototypes/$role_trimmed/README.md"
  done
fi

# --- skills/（条件生成） ---
if [[ "$HAS_SKILLS" == "yes" ]]; then
  echo "🧩 skills/ ..."
  mkdir -p skills/plan
  render_file "$TEMPLATES_DIR/skills/README.md" "skills/README.md"
  render_file "$TEMPLATES_DIR/skills/plan/README.md" "skills/plan/README.md"
fi

# --- training/ ---
echo "📚 training/ ..."
mkdir -p training/{customer,internal}
render_file "$TEMPLATES_DIR/training/README.md" "training/README.md"
render_file "$TEMPLATES_DIR/training/customer/README.md" "training/customer/README.md"
render_file "$TEMPLATES_DIR/training/customer/onboarding-guide.md" "training/customer/onboarding-guide.md"
render_file "$TEMPLATES_DIR/training/customer/operation-manual.md" "training/customer/operation-manual.md"
render_file "$TEMPLATES_DIR/training/customer/faq.md" "training/customer/faq.md"
render_file "$TEMPLATES_DIR/training/internal/README.md" "training/internal/README.md"
render_file "$TEMPLATES_DIR/training/internal/sales-kit.md" "training/internal/sales-kit.md"
render_file "$TEMPLATES_DIR/training/internal/support-playbook.md" "training/internal/support-playbook.md"
render_file "$TEMPLATES_DIR/training/internal/new-hire-onboarding.md" "training/internal/new-hire-onboarding.md"

# --- app/ ---
echo "📦 app/ ..."
mkdir -p app
render_file "$TEMPLATES_DIR/app/README.md" "app/README.md"

# --- archive/ ---
echo "🗄️  archive/ ..."
mkdir -p archive
render_file "$TEMPLATES_DIR/archive/README.md" "archive/README.md"

# --- Logs/ ---
echo "📝 Logs/ ..."
mkdir -p "Logs/$YEAR_MONTH"
render_file "$TEMPLATES_DIR/Logs/README.md" "Logs/README.md"

# ============== 完成报告 ==============
echo ""
echo "✅ 项目骨架创建完成！"
echo ""
echo "📂 项目位置: $PROJECT_DIR"
echo ""
echo "下一步建议:"
echo "  1. cd $PROJECT_DIR"
echo "  2. 编辑 README.md 完善项目描述"
echo "  3. 在 docs/prd/ 写第一份 PRD"
echo "  4. git init && git add -A && git commit -m 'init: PM scaffolding'"
echo ""
echo "目录树:"
if command -v tree >/dev/null 2>&1; then
  tree -L 2 -a -I '.git' "$PROJECT_DIR"
else
  find "$PROJECT_DIR" -maxdepth 2 -not -path "*/\.*" | sed -e "s|$PROJECT_DIR|.|"
fi
