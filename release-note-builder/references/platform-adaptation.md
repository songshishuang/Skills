# 跨平台适配（release-note-builder）

本 skill 的依赖分三类，按平台能力降级：① 读写文件 ② shell（`python3`+Pillow；macOS 的 `screencapture`/AppleScript）③ 浏览器导航（可选）。

核心价值（四段式模板 + 脱敏 + HTML 生成 + 预览）只需 ①②，**任意有 shell 的 AI 工具都能跑**。浏览器导航缺失时，截图采集降级为"用户提供截图"，skill 仍负责脱敏 + 排版。

## 能力映射

| 平台 | 文件读写 | 浏览器导航 | 系统截图 | 脱敏/模板/预览 | 截图采集方式 |
|---|---|---|---|---|---|
| **Claude Code (macOS)** | Read/Write | Chrome MCP | `screencapture` | ✅ | 方式 A 全自动（导航+capture.sh） |
| **Codex CLI (macOS)** | shell 读写 | 无内置（用户手动开页）| `screencapture` | ✅ | 方式 B：用户开页 → `capture.sh` 截 |
| **Codex / 任意 shell (Linux)** | shell 读写 | 视工具而定 | ❌（无 screencapture）| ✅（除截图）| 方式 C：用户提供截图 → 脱敏+排版 |
| **Cursor / Copilot CLI** | 读写 | 视工具而定 | macOS 上可 | ✅ | A/B/C 视具体能力 |
| **纯文本（ChatGPT Web 等）** | ❌ 用户手动落盘 | ❌ | ❌ | 仅生成 HTML 文本 | 用户自行截图+落盘 |

> 工具名对照：本 skill 文档用 Claude Code 术语（Read / Write / Bash）。在 Codex 等环境里，Read/Write = 直接读写文件，Bash = 跑 shell 命令；`scripts/` 下的 `capture.sh`、`redact.py` 是普通 shell/python，直接 `bash`/`python3` 调用即可。

## 三种采集方式（详见 screenshot-and-redact.md）

- **方式 A（全自动）**：有浏览器自动化 + macOS 系统截图。导航→提窗→`capture.sh`→裁顶。
- **方式 B（半自动）**：用户手动在浏览器打开每页，你用 `capture.sh` 截当前/指定窗口。
- **方式 C（手动素材）**：无系统截图，让用户把每页截图放进 `assets/<version>-release/`，skill 只做脱敏 + 排版。

## 不变的部分（所有平台一致）

- 四段式结构与 `templates/release-note-skeleton.html`
- `scripts/redact.py` 脱敏（纯 Pillow）
- 原图 `_raw/` + `.gitignore` 排除
- `python3 -m http.server` 预览（不要 file:// 直开）

## 同步到其它工具

本 skill 是自包含目录（SKILL.md + templates + references + scripts）。复制整个 `release-note-builder/` 目录到目标工具的 skills 路径即可（如 Codex 的 `~/.codex/plugins/<ns>/skills/`）。脚本无第三方依赖（除 Pillow：`pip install Pillow`）。
