---
name: release-note-builder
description: 把一次产品上线整理成「发版说明 / 上线公告」HTML（仿 JoySpace 四段式：标题 · 【上线时间】· 【版本内容】扫读清单 · 【功能介绍】逐功能 文字+真实页面截图）。固化「真实环境逐页截图 → 默认脱敏 → 套四段式模板 → 本地预览 →（可选）一键发布到 JoySpace」整条流水线，跨 AI 工具通用（Claude Code / Codex 等有 shell 即可）。还能把发版说明发布成 JoySpace 在线文档：用纯净语义 HTML 全选复制粘贴，自动生成多级目录 + 加粗 + 列表 + 截图，一键成型（见 references/joyspace-publish.md）。只要用户提到写发版说明、上线公告、release note、VX.X 发版说明、按 JoySpace 模板出发版、把这次上线整理成公告、做个版本说明、这次上线写一下、把这次迭代写成公告、发到 JoySpace、创建 JoySpace 上线公告、把发版说明同步到 JoySpace、把发版说明更新到产品索引页 / 登记到门户上线公告，就使用本 skill —— 即使没明说"发版说明"四个字，只要意图是"把已上线的功能整理成给人看的公告"，都应触发。
---

# Release Note Builder · 发版说明 / 上线公告生成器

## 这个 Skill 解决什么

把"系统功能已上线"这件事，产出一份**对运营 / 客户 / 团队可直接阅读**的发版说明 HTML。沉淀的是一整条踩过坑的流水线，让每次发版不必从零摸索：

1. **范式固定** — 上线公告四段式（标题 / 【上线时间】/ 【版本内容】/ 【功能介绍】），结构锁死保证一致，样式留开关。
2. **截图管线固化** — 逐页采集**真实环境页面**截图（不是原型），并绕过"截图不落本地盘""浏览器边框/录制横幅入镜""光标入镜"等坑。
3. **脱敏默认开** — 账号、邮箱、姓名、电话、证件号等 PII 自动打码；脱敏前原图不入库。
4. **一致排版** — 仿 JoySpace 公告视觉，自包含 HTML（内联 CSS），离线在线都能开。
5. **一键发布 JoySpace** — 额外产出一份**纯净语义 HTML**，线上打开全选复制、粘进 JoySpace 即自动成型（多级目录 + 加粗 + 列表 + 截图全带入），免去富文本逐字段手敲的脆弱与周折。见 [`references/joyspace-publish.md`](references/joyspace-publish.md)。

> 核心理念：**发版说明 = 文字摘要 + 真实页面带标注截图**。截图要用线上真实页（原型会和线上有出入，失去公告的可信度）。
> **两份 HTML 各司其职**：卡片美化版给门户/本地展示；纯净语义版专供 JoySpace 粘贴（卡片版的 CSS 装饰粘进 JoySpace 会变垃圾文本，详见发布指南）。

## 触发场景

- 「写发版说明」「上线公告」「VX.X 发版说明」「按 JoySpace 模板出发版」
- 「把这次上线整理成公告」「做个版本说明」「这次上线写一下」「把这次迭代写成公告」
- 用户描述"某某功能上线了，要告诉客户 / 团队"，即使没说"发版说明"

## 跨平台说明（能力分层）

本 skill 分两层，**核心层工具无关**，**采集层按平台适配**：

| 层 | 内容 | 依赖 | 跨工具 |
|---|---|---|---|
| 核心层 | 四段式模板、脱敏、HTML 生成、预览 | Python3(含 Pillow)、shell | ✅ Claude Code / Codex / 任意有 shell 的工具 |
| 采集层 | 逐页截图 | 浏览器自动化 **或** 系统截图 **或** 手动 | ⚠️ 按平台选方式，见 [`references/screenshot-and-redact.md`](references/screenshot-and-redact.md) |

工具名对照（本文件用 Claude Code 术语 Read/Write/Bash）：Codex 用 shell + 读写文件；无浏览器自动化的环境，采集层降级为"用户提供截图，skill 只做脱敏+排版"。详见 [`references/platform-adaptation.md`](references/platform-adaptation.md)。

## 输入（对话式逐步问）

启动后**依次问**（一次一项，别一股脑要），缺省项给出合理默认并说明：

1. **版本号**（如 V0.1 / v1.2.0）
2. **上线时间**（YYYY 年 M 月 D 日；不确定就先占位并标注"待运营确认"）
3. **页面清单** —— 每页：`URL` + `名称` + `一句话描述`。这是截图与功能介绍的来源。
4. **范围说明** —— 本版覆盖什么、明确**不含**什么（避免越界，例如把规划中的功能写进已上线公告）。
5. **样式开关** —— 报默认值让用户一次确认（见下）。
6. **是否发布到 JoySpace** —— 问一句；要发布则在生成 HTML 后额外走发布流程（见 [`references/joyspace-publish.md`](references/joyspace-publish.md)）。

## 主流程（5 步 + 可选发布 + 可选登记索引页）

1. **整理四段式内容** —— 把页面清单归纳成【版本内容】扫读清单（按端/模块），逐页写【功能介绍】文字。
2. **逐页截图** —— 见 [`references/screenshot-and-redact.md`](references/screenshot-and-redact.md)。每页一张**干净的应用界面**截图，统一尺寸，存素材目录。
3. **脱敏**（默认开）—— `python3 scripts/redact.py`（账号块 + PII）。脱敏前原图存 `_raw/` 并用 `.gitignore` 排除。
4. **生成 HTML** —— 套 [`templates/release-note-skeleton.html`](templates/release-note-skeleton.html)，填四段式内容、按开关调样式。
5. **本地预览验证** —— `python3 -m http.server` 打开核对（**不要直接 file:// 让浏览器自动化导航**，部分工具会给 file:// 误加 https 前缀；起本地服务器最稳）。
6. **（可选）发布到 JoySpace** —— 若要建成 JoySpace 在线文档：另出一份**纯净语义 HTML**（套 [`templates/joyspace-pure-skeleton.html`](templates/joyspace-pure-skeleton.html)）→ 部署线上 → 浏览器打开**线上版**全选复制（`Cmd+A`/`Cmd+C`）→ 粘进 JoySpace（`Cmd+V`，默认保留源格式）一键成型，自动生成多级目录 + 加粗 + 列表 + 截图。完整步骤、坑、富文本手敲备选、反向同步见 [`references/joyspace-publish.md`](references/joyspace-publish.md)。
7. **（可选但默认做）登记到门户 / 产品索引页** —— 若项目有产品文档门户/索引页（如 `index.html`），发版后应在其「上线公告 / 发版说明」区**最新在前**追加一张版本卡片：`VX.X 发版说明` 标题 + 上线时间 + 一句话范围 + 链接到本版发版说明 HTML，让门户能直接点进新版。卡片样式沿用门户既有风格。⚠️ 门户索引页的**具体位置 / 卡片 HTML / 链接路径 / 部署方式属项目特定**，记在项目记忆而非本 skill（不同项目门户结构不同）——如 Maas：`docs/pm/index.html`「上线公告」区卡片、`releases/VX/` 路径、主分支与工作分支路径可能不一致、用 worktree 部署 master，详见对应 memory。

## 四段式结构（锁死 —— 不改结构，只改内容）

完整 HTML 骨架见 [`templates/release-note-skeleton.html`](templates/release-note-skeleton.html)。

1. **标题**：`【上线公告】<产品> VX.X · <一句话主题>`
2. **【上线时间】**：`YYYY 年 M 月 D 日`
3. **【版本内容】**：编号清单，每条 = `端/模块：改动点`，一句话扫读级摘要（给快速浏览的人）
4. **【功能介绍】**：按端/模块分组，逐功能 = `小标题 + 1-2 句描述 + 能力 chip + 真实页面截图`

## 样式开关（可调 —— 报默认值让用户确认）

| 开关 | 默认 | 说明 |
|---|---|---|
| 标题尽量一行 | 开 | 主标题 + 副标题（淡色小字）同行 |
| 目录索引 · 左侧悬浮 | 开 | 宽屏（≥1340px）左侧固定悬浮 + 滚动高亮；窄屏隐藏 |
| 线上数据统计 | **关** | 描述/chip 里**不放**线上统计数字（如"已上架 9 模型"），只写功能；除非用户要 |
| 作者署名 / 状态徽章 | 关 | 顶部不放署名头像和"运营中"徽章 |
| 图下 caption（URL+页名） | 关 | 卡片标题已说明页面，图下不再重复地址 |
| 截图脱敏 | 开 | 账号 + PII 打码 |

## 关键铁律（避免重踩坑）

- **截图必须真落到可访问磁盘** —— 很多浏览器自动化的"保存截图"并不写到你能读到的本地盘；优先用系统截图（macOS `screencapture`）落盘，或确认返回的真实路径。详见 reference。
- **截图要干净** —— 统一窗口尺寸、光标移到角落、关掉弹窗、裁掉浏览器边框与扩展"录制中"横幅。
- **脱敏闭环要延伸到 git** —— 只打码展示图不够，**未脱敏原图 `_raw/` 必须 `.gitignore` 排除**，否则 PII 进 git 历史难清除。
- **预览用本地服务器** —— `python3 -m http.server`，不要依赖 file:// 直开（相对资源/部分工具导航有坑）。
- **若要进文档门户 / 在线部署** —— 链接用相对路径 + 在 `<head>` 注入动态 `<base>` 锚定到内容根目录，避免"无尾斜杠访问"和"SPA fallback"导致相对链接 404。模式见 [`references/screenshot-and-redact.md`](references/screenshot-and-redact.md) 末尾。

## 文件清单

- `templates/release-note-skeleton.html` —— 四段式自包含 HTML 模板（卡片美化版，门户/本地展示用）
- `templates/joyspace-pure-skeleton.html` —— **JoySpace 专用纯净语义 HTML 模板**（仅 h1-h4/p/ul/img，粘贴即成型）
- `references/screenshot-and-redact.md` —— 截图采集（按平台）+ 脱敏 + 预览 + base 锚定 的完整技术细节与坑
- `references/joyspace-publish.md` —— **发布到 JoySpace 的完整指南**（纯净 HTML 粘贴 / 富文本手敲备选 / 坑 / 反向同步 / 模板范式）
- `references/platform-adaptation.md` —— 跨 AI 工具的能力映射与降级方案
- `scripts/capture.sh` —— macOS 截图 helper（窗口提前台 + 区域截图 + 自适应裁顶）
- `scripts/redact.py` —— 纯 Python(Pillow) 脱敏（圆角块遮账号 / 白底擦输入框 / 打码 PII）
