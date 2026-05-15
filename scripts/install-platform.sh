#!/bin/bash
# 一键将 5 个 skill 安装到指定 AI 代码助手平台
# 用法：
#   ./install-platform.sh                              # 交互式选平台
#   ./install-platform.sh claude-code                  # 装到 ~/.claude/skills/
#   ./install-platform.sh cursor --project /path/...   # 装到指定项目的 .cursor-plugin/
#   ./install-platform.sh codex                        # 装到 ~/.codex/plugins/...
#   ./install-platform.sh gemini                       # gemini extensions install
#   ./install-platform.sh opencode --project /path/... # 装到指定项目的 .opencode/

set -euo pipefail

REPO_URL="https://github.com/songshishuang/Skills.git"
SKILLS=(prd-writer pm-project-scaffolding conversation-logging-and-insight-extraction saas-arch-diagrams saas-prototype-design)
GIT=/usr/bin/git

# ===== 解析参数 =====
PLATFORM="${1:-}"
PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --project) PROJECT_DIR="$2"; shift 2 ;;
        -h|--help)
            cat <<EOF
用法: $(basename "$0") <platform> [--project /path]

支持平台:
  claude-code    安装到 ~/.claude/skills/（用户全局）
  cursor         安装到 <project>/.cursor-plugin/skills-songshishuang/ (必须 --project)
  codex          安装到 ~/.codex/plugins/songshishuang-skills/
  gemini         通过 gemini extensions install
  copilot        通过 gh copilot marketplace add
  opencode       安装到 <project>/.opencode/plugins/ (必须 --project)

详细说明见 INSTALL-MULTI-PLATFORM.md。
EOF
            exit 0
            ;;
        *) shift ;;
    esac
done

# ===== 交互式选平台 =====
if [[ -z "$PLATFORM" ]]; then
    echo "选择目标平台："
    echo "  1) claude-code"
    echo "  2) cursor"
    echo "  3) codex"
    echo "  4) gemini / antigravity"
    echo "  5) copilot"
    echo "  6) opencode"
    read -p "请输入数字 [1-6]: " choice
    case "$choice" in
        1) PLATFORM="claude-code" ;;
        2) PLATFORM="cursor" ;;
        3) PLATFORM="codex" ;;
        4) PLATFORM="gemini" ;;
        5) PLATFORM="copilot" ;;
        6) PLATFORM="opencode" ;;
        *) echo "❌ 无效选择"; exit 1 ;;
    esac
fi

# ===== 临时 clone =====
TMPDIR=$(/usr/bin/mktemp -d)
trap "rm -rf $TMPDIR" EXIT

echo "📥 clone 仓库到临时目录..."
$GIT clone --depth=1 "$REPO_URL" "$TMPDIR/Skills" 2>&1 | /usr/bin/tail -2

# ===== 按平台安装 =====
case "$PLATFORM" in
    claude-code)
        DEST="$HOME/.claude/skills"
        /bin/mkdir -p "$DEST"
        for s in "${SKILLS[@]}"; do
            /bin/rm -rf "$DEST/$s"
            /bin/mv "$TMPDIR/Skills/$s" "$DEST/$s"
            echo "  ✅ $s → $DEST/$s"
        done
        ;;

    cursor)
        if [[ -z "$PROJECT_DIR" ]]; then
            echo "❌ Cursor 需要 --project <你的 Cursor 项目路径>"; exit 1
        fi
        DEST="$PROJECT_DIR/.cursor-plugin/skills-songshishuang"
        /bin/mkdir -p "$DEST"
        for s in "${SKILLS[@]}"; do
            /bin/rm -rf "$DEST/$s"
            /bin/mv "$TMPDIR/Skills/$s" "$DEST/$s"
            echo "  ✅ $s → $DEST/$s"
        done
        # 写入 plugin.json
        PLUGIN_JSON="$PROJECT_DIR/.cursor-plugin/plugin.json"
        if [[ ! -f "$PLUGIN_JSON" ]]; then
            /bin/cat > "$PLUGIN_JSON" <<EOF
{
  "name": "songshishuang-skills",
  "displayName": "songshishuang Skills",
  "description": "PRD 写作 / 项目脚手架 / SaaS 架构图 / 高保真原型 / 对话归档",
  "version": "1.0.0",
  "skills": "./skills-songshishuang/",
  "repository": "https://github.com/songshishuang/Skills"
}
EOF
            echo "  ✅ 生成 $PLUGIN_JSON"
        else
            echo "  ⚠️  plugin.json 已存在，未覆盖（请手动添加 \"skills\": \"./skills-songshishuang/\" 字段）"
        fi
        ;;

    codex)
        DEST="$HOME/.codex/plugins/songshishuang-skills"
        /bin/mkdir -p "$DEST/skills"
        /bin/mv "$TMPDIR/Skills" "$DEST/repo"
        for s in "${SKILLS[@]}"; do
            /bin/ln -sfn "$DEST/repo/$s" "$DEST/skills/$s"
            echo "  ✅ $s → $DEST/skills/$s (symlink to repo)"
        done
        echo "  ℹ️  仓库主体保留在 $DEST/repo，可 git pull 更新"
        ;;

    gemini)
        echo "🚀 安装 Gemini 扩展..."
        if ! /usr/bin/which gemini > /dev/null; then
            echo "❌ gemini CLI 未安装，请先安装: brew install --cask gemini 或 npm install -g @google/gemini-cli"
            exit 1
        fi
        gemini extensions install "$REPO_URL" 2>&1 | /usr/bin/tail -5
        echo "  ✅ Antigravity 共享 ~/.gemini/ 配置，同时生效"
        ;;

    copilot)
        echo "🚀 安装到 GitHub Copilot CLI..."
        if ! /usr/bin/which gh > /dev/null; then
            echo "❌ gh CLI 未安装，请先安装: brew install gh"
            exit 1
        fi
        gh copilot marketplace add songshishuang/Skills 2>&1 | /usr/bin/tail -5 || echo "  ⚠️ marketplace add 可能需要更新 gh copilot extension"
        ;;

    opencode)
        if [[ -z "$PROJECT_DIR" ]]; then
            echo "❌ OpenCode 需要 --project <你的项目路径>"; exit 1
        fi
        DEST="$PROJECT_DIR/.opencode/plugins/songshishuang-skills"
        /bin/mkdir -p "$(dirname "$DEST")"
        /bin/mv "$TMPDIR/Skills" "$DEST"
        echo "  ✅ 全部 skill → $DEST"
        ;;

    *) echo "❌ 未知平台: $PLATFORM"; exit 1 ;;
esac

echo ""
echo "✅ 安装完成。Self-Evolving Protocol 在该平台的执行说明见 INSTALL-MULTI-PLATFORM.md"
