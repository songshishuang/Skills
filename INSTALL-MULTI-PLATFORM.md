# 🌐 跨平台安装指南

5 个 skill 设计上**与模型无关**——核心知识（PRD 模板、架构图反模式、组件 patterns、日志规范）在任何 AI 代码助手中都能复用。差异在于：

1. **物理安装路径**不同
2. **Self-Evolving Protocol 执行能力**不同（仅 `prd-writer` / `saas-arch-diagrams` 有此协议）

---

## 📊 平台支持矩阵

| 平台 | SKILL.md 加载 | AI 能改 SKILL.md | Self-Evolving 自动化 | 推荐用法 |
|---|---|---|---|---|
| **Claude Code** | ✅ 原生 `~/.claude/skills/` | ✅ Write/Edit 工具 | 🟢 全自动 | 主用环境 |
| **Claude Desktop** | ✅ 原生（同上） | ✅ | 🟢 全自动 | 主用环境 |
| **Cursor** | ✅ `.cursor-plugin/skills/` (需 plugin.json) | ✅ Edit 工具 | 🟡 半自动（需用户提示自检）| 配合主环境 |
| **Codex CLI / App** | ✅ OpenAI plugin marketplace 或本地 `.codex/plugins/<name>/skills/` | ✅ | 🟡 半自动 | 团队协作 |
| **Gemini CLI / Antigravity** | ✅ `gemini extensions install <github-url>` | ✅ | 🟡 半自动 | 备用 |
| **GitHub Copilot CLI** | ✅ 通过 marketplace | ✅ | 🟡 半自动 | 集成 GitHub 工作流 |
| **OpenCode** | ✅ `.opencode/plugins/` | ✅ | 🟡 半自动 | 备用 |
| **ChatGPT Web / Plus** | 🟡 复制 SKILL.md 进 GPT instructions | ❌ 文件系统隔离 | 🔴 仅能"建议改" | 临时使用 |
| **本地模型**（Ollama / LM Studio） | 🟡 注入 system prompt | ❌ 多数无 tool use | 🔴 不支持 | 不推荐 |

---

## 🚀 各平台快速安装

### 1. Claude Code / Claude Desktop（推荐）

```bash
cd ~/.claude/skills
git clone https://github.com/songshishuang/Skills.git temp
mv temp/{prd-writer,pm-project-scaffolding,saas-arch-diagrams,saas-prototype-design,conversation-logging-and-insight-extraction} .
rm -rf temp
```

或单独装某个 skill：
```bash
cd ~/.claude/skills
git clone --depth=1 --filter=blob:none --sparse https://github.com/songshishuang/Skills.git tmp
cd tmp && git sparse-checkout set prd-writer && mv prd-writer ../ && cd .. && rm -rf tmp
```

### 2. Cursor

**方式 A**：直接克隆到项目内
```bash
cd <你的项目>
mkdir -p .cursor-plugin
git clone https://github.com/songshishuang/Skills.git .cursor-plugin/skills-songshishuang
```

然后在 `.cursor-plugin/plugin.json` 注册：
```json
{
  "name": "songshishuang-skills",
  "displayName": "songshishuang Skills",
  "skills": "./skills-songshishuang/"
}
```

**方式 B**：用本仓库脚本一键安装（见末尾 [`scripts/install-platform.sh`](./scripts/install-platform.sh)）
```bash
./scripts/install-platform.sh cursor --project /path/to/your/cursor/project
```

### 3. Codex CLI

```bash
# 本地路径方式（适合自用）
mkdir -p ~/.codex/plugins/songshishuang-skills/skills
git clone https://github.com/songshishuang/Skills.git ~/.codex/plugins/songshishuang-skills/repo
ln -s ~/.codex/plugins/songshishuang-skills/repo/{prd-writer,pm-project-scaffolding,saas-arch-diagrams,saas-prototype-design,conversation-logging-and-insight-extraction} ~/.codex/plugins/songshishuang-skills/skills/
```

未来若发布到 OpenAI plugin marketplace，用：
```bash
# Codex CLI 内
/plugins
# 搜索 songshishuang-skills 并安装
```

### 4. Codex App

待发布到 OpenAI 官方 plugin marketplace 后，在 App 内 Plugins 侧栏点 `+` 安装。当前可通过方式 3 走本地路径。

### 5. Gemini CLI / Antigravity

```bash
gemini extensions install https://github.com/songshishuang/Skills
```

Antigravity 共享 `~/.gemini/` 配置，通过 `gemini` CLI 安装的扩展同样对 Antigravity 生效。

**注意**：Gemini 体系下的 skill 加载机制与 Anthropic Skill 略有差异——本仓库的 `SKILL.md` 在 Gemini 中作为「extension instructions」加载，所有 references / templates / scripts 可被 AI 通过 file 工具访问。

### 6. GitHub Copilot CLI

```bash
gh copilot marketplace add songshishuang/Skills
# 然后在 gh copilot 会话中按需启用
```

### 7. OpenCode

```bash
cd <你的项目>
mkdir -p .opencode/plugins
git clone https://github.com/songshishuang/Skills.git .opencode/plugins/songshishuang-skills
```

### 8. ChatGPT Web / Plus（降级方案）

无法直接加载 SKILL.md，只能把内容**复制粘贴**到 GPT 的 instructions 或对话 system prompt：

```bash
# 在 macOS 把 SKILL.md 复制到剪贴板
cat ~/.claude/skills/prd-writer/SKILL.md | pbcopy
# 然后粘贴到 GPT 的 Custom Instructions 或对话开头
```

**限制**：
- references / templates / scripts 必须手动逐个上传
- Self-Evolving Protocol 完全失效——GPT 无法改宿主文件
- 跨会话失忆——每个新对话都要重新加载

---

## 🤖 Self-Evolving Protocol 在不同平台的执行差异

`prd-writer` 和 `saas-arch-diagrams` 含 **Self-Evolving Protocol**（每次工作后 AI 主动评估是否更新 SKILL.md 自身）。这个机制在不同平台表现不同：

### 🟢 Claude Code / Claude Desktop（全自动）
AI 自动遵循 SKILL.md 内的「触发评估时机表」+「30 秒自检清单」，**主动**调用 Edit 工具修改 SKILL.md，并在末尾 Changelog 加一行。改完会**告知用户**「本轮新增 N 条 X」让用户有否决权。

### 🟡 Cursor / Codex / Gemini / Copilot / OpenCode（半自动）
AI 具备 Edit 工具但不会**主动**触发 Self-Evolving Protocol——需要用户在每次完成 PRD/架构图后**手动提示**：

```
请按本 skill 的 Self-Evolving Protocol 自检本轮工作，
评估有没有新反模式 / 新模板 / 新维度要进 references/。
```

### 🔴 ChatGPT Web / 本地小模型（仅能"建议"）
AI 无法直接改宿主文件。最多能在回复尾部**输出建议**「本轮有 X 条新发现，建议你手动加到 references/anti-patterns.md」。用户需要手动落地。

---

## 🔁 同步策略（多平台共存时）

如果你**同时在多平台用**这套 skill，主开发位置始终是 **Claude Code/Desktop 的 `~/.claude/skills/`**，其他平台从 GitHub pull 最新版：

```bash
# 各平台自动定期 pull（如装 git auto-pull）
# 或者写个 cron / launchd 每天跑：
cd ~/.codex/plugins/songshishuang-skills/repo && git pull
cd ~/.cursor-plugin/skills-songshishuang && git pull
```

本仓库的 launchd 同步（`~/.claude/scripts/auto-sync-skills.sh` → GitHub）保证 Claude 端的改动 5 分钟内上 GitHub，其他平台从 GitHub pull 即可。

---

## ❓ 我没看到我用的平台怎么办

新平台支持请提 issue 或 PR。**核心评估维度**：

1. 该平台是否支持加载 `.md` 文件作为 AI 指令？
2. 该平台 AI 是否有 `Edit` / `Write` 工具能改文件？
3. 该平台有没有标准的 skill / plugin 安装路径？

3 项都满足 → 应该是 🟢 全自动；满足前 2 项 → 🟡 半自动；只满足第 1 项 → 🔴 仅建议。
