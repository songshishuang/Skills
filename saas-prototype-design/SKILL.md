---
name: saas-prototype-design
description: 设计企业 SaaS 高保真原型的完整方法论：v1 设计语言（品牌红 + tokens.css + chrome 框架）、组件模式（sidebar/topbar/filter-form/list-toolbar/wizard/drawer/modal/toast）、3 级嵌套结构、状态机徽章、历史版本保护机制。蒸馏自 某 SaaS 平台 项目 30+ 轮迭代实战，覆盖 33+ 页原型从 0 到 1 + 多次推倒重做的踩坑经验。触发场景：「做原型」「画产品 demo」「按 v1 风格做新页」「修筛选区按图例风格」「设计 SaaS 管理后台 UI」「派 Agent 改原型」「保护历史版本不被 Agent 覆盖」「prototype design」。
---

# SaaS 原型设计

## 这个 Skill 解决什么

1. **风格一致性** — 多人 / 多 Agent 同时改原型时，设计语言不漂移
2. **效率** — 复用现成 chrome / token / 组件模式，新页面 30 分钟到 1 小时完成
3. **历史版本保护** — Agent 大改时不会覆盖之前精心迭代的功能
4. **避坑** — 固化 某 SaaS 平台 项目踩过的 20+ 个返工经验，新项目不重蹈覆辙

## 触发场景

- 「做一个高保真原型」「画产品 demo」
- 「按 v1 风格做新页面」「跟 v1 设计语言 一致」
- 「修条件查询区 / 表格工具栏」
- 「派 Agent 改原型 + 保护历史版本」
- 「设计 SaaS 管理后台 UI」「企业级 admin / portal 界面」

## 不可违反的 10 条原则（来自实战返工）

| # | 原则 | 反例 |
|---|---|---|
| 1 | **原型是交付物，不带 PM 规划性术语** | "主战场" / "本期" / "v0.x 启用" / "远期" / "MVP" 一律不出现在页面 |
| 2 | **端的定义纯粹** | 端只能是「运营 / 供应商 / 客户 / 第三方平台」客户端；「后端 / 业务服务 / 中间件」**不是端** |
| 3 | **服务和页面分层** | 「评测任务列表」（页面）和「评测流水线 controller」（服务）不能混在一个子组 |
| 4 | **能力域不能平铺** | 域内 5+ 卡片必须按子能力（A1/A2/A3）3 级嵌套 |
| 5 | **col-span 填满 12** | 每行加起来必须 = 12，禁止留右侧空白 |
| 6 | **不省略合并** | "④-⑧ 5 节点合并 1 卡" 违反内容逻辑，必须独立展开 |
| 7 | **Agent 大改前先备份** | 不备份就被覆盖丢失（已发生 3 次） |
| 8 | **改完文案残留必查** | 删功能时容易留下"在 Step 3 配置"这种过时引用 |
| 9 | **状态徽章用 ● 圆点 + 弱色背景**，不用纯色实心 badge | 表格列充满高饱和色会炫晕 |
| 10 | **Tab 切换内容必须填充**（不能只默认 tab 有内容） | 「待审 / 已通过」tab 切换变空白是高频 bug |

## 设计语言速查（v1 / v1 设计语言）

完整规范见 [`references/design-tokens.md`](references/design-tokens.md)。**核心 6 条**：

1. **主色**：品牌红 `#E1251B`（主 CTA / brand）
2. **状态 5 态**：pending_eval（灰）/ evaluating（蓝）/ pending_approval（橙）/ online（绿）/ rejected（红）
3. **字号梯度**：xs 12 / sm 13 / base 14 / lg 16 / xl 18 / 2xl 22 / 3xl 28
4. **圆角**：sm 4 / md 6 / lg 8 / xl 12
5. **栅格**：12 列 grid · 最大宽度 1440 · sidebar 224 · topbar 56
6. **字体**：PingFang SC + Inter + JetBrains Mono（数字 tabular-nums 等宽）

模板文件可直接复用：
- [`templates/tokens.css`](templates/tokens.css) — 设计 token CSS variable
- [`templates/chrome.css`](templates/chrome.css) — 侧栏 + 顶栏 + 主区栅格
- [`templates/chrome.js`](templates/chrome.js) — Toast / Modal / Drawer / Tab / ⌘K
- [`templates/page-skeleton.html`](templates/page-skeleton.html) — 起手页面骨架

## 组件模式速查

完整规范见 [`references/component-patterns.md`](references/component-patterns.md)。**8 大常用组件**：

| 组件 | 用途 | 模板 |
|---|---|---|
| **sidebar** | 左侧导航 5-7 分组 + brand + footer | chrome.css `.sidebar` |
| **topbar** | 搜索 ⌘K + 通知红点 + 头像 | chrome.css `.topbar` |
| **KPI 卡** | 仪表盘型（24px padding · 28px 大字）/ 紧凑型（12-16px padding · 22px · 副标 inline） | `.kpi-card` `.kpi-value` `.kpi-row` |
| **filter-form** | 3 列 label-input 横向 + 展开/重置/搜索 | `.filter-form` `.filter-grid` `.filter-actions` |
| **list-toolbar** | 左批量 + 右主操作（红） | `.list-toolbar` `.list-toolbar-left/right` |
| **表格** | tbl-compact + tr hover + 行 click drawer | `.tbl` `.tbl-compact` |
| **drawer** | 详情面板 · 多 tab · 滑入 | chrome.js `showDrawer()` |
| **wizard** | 3-5 步 stepper + 步骤跳转 + 实时校验 | stepper-item + step-panel |

## 历史版本保护机制

完整实施见 [`references/history-protection.md`](references/history-protection.md)。**3 条铁律**：

1. **大改前自动备份**：执行 `bash scripts/snapshot.sh <file>` 或派 Agent 前手动 `cp file.html prototypes/.history/file.{YYYYMMDD-HHMM}.html`
2. **HTML 头部加 prototype-meta 注释**，含 version + last-modified + 关键功能 checklist
3. **派 Agent 改原型时强制使用"保留 / 修改 / 删除"声明 prompt 模板**（见 [`references/agent-protocol.md`](references/agent-protocol.md)）

## 反模式速查（20+ 真实返工案例）

详见 [`references/anti-patterns.md`](references/anti-patterns.md)。常见 5 类：

1. **文案残留** — 删 Step 3 后忘记改"下一步：Metric 配置"按钮文案
2. **Tab 空白** — 只默认 tab 有内容，切换其他 tab 变空
3. **col 等宽留白** — col-span-3 等宽分配但 4 个子组卡片数不均
4. **设计混搭** — Tailwind CDN + v1 tokens.css 同时引入，类名冲突
5. **Agent 覆盖** — Agent 复制 v1 页面到 v0.1 时覆盖了之前迭代功能

## 派 Agent 改原型的标准 prompt 模板

详见 [`references/agent-protocol.md`](references/agent-protocol.md)。

```
必读 _BUILD_SPEC.md + 当前文件 + 历史版本（如有）。

在现有 HTML 基础上扩展/微调，**不重写整页**。

【保留】sidebar / topbar / 现有 tokens 类 / 现有交互（Modal / Drawer / Toast）
【修改】<列出具体要改的 section + 改成什么样>
【删除】<列出要删的 section>
【新增】<列出要加的内容>

完成后报告：原行数 → 新行数 + 改动清单（不复述设计内容）
```

## 项目目录约定

```
prototypes/
├── v0.1/                 ← 当前迭代版（业务真实开发对接）
│   ├── *.html            ← 页面（13 个）
│   ├── assets-v1/        ← 设计 token + chrome + JS
│   └── assets/templates/ ← CSV / JSON 模板下载
├── v1/                   ← 远期完整方案（演示 + 跨域全功能）
│   ├── operator/         ← 运营端 24 页
│   ├── vendor/           ← 供应商端 11 页
│   └── assets/           ← 设计资源
├── .history/             ← 自动备份目录（.gitignore 之外，需要 git track）
│   └── {file}.{YYYYMMDD-HHMM}.html
└── _BUILD_SPEC.md        ← 全局原型约定（每个新 Agent 必读）
```

## 演进与维护

本 skill 是 **living document**，每次返工或新发现都应该更新：

1. **每次踩坑后** → 在 `references/anti-patterns.md` 加一条案例
2. **每次新模式出现** → 在 `references/component-patterns.md` 增补
3. **每次设计 token 改动** → 同步 `templates/tokens.css` + `references/design-tokens.md`

更新时记得在 SKILL.md 末尾的 `## Changelog` 段加一行（日期 + 改动摘要）。

### 强制评估时机（每轮迭代必做）

每次完成以下任一原型工作后，**主动评估是否需要更新 skill**，不要等用户提醒：

| 触发时机 | 评估问题 |
|---|---|
| 完成一个页面 / 一轮"改动清单" | 这轮有没有可复用的新模式 / 新数值规格 / 新反模式？ |
| 用户给出明确否定（"不要 X" / "去掉 Y"） | 这条否定是不是普适规则？要不要进反模式？ |
| 用户给出明确肯定（"这样对" / "保留这个交互"） | 这条肯定能不能写进组件模式？ |
| 跑 `check-residual.sh` 出现脚本误报 / 漏检 | 检查脚本是不是要补正则？ |
| 派 Agent 改原型出问题 | agent-protocol 是不是要补 prompt 模板？ |
| 同样的设计决策反复出现（≥ 2 次） | 第 3 次再决策就晚了，第 2 次就应该固化 |

### 评估流程（3 步）

1. **盘点本轮改动**：列出"删了什么 / 改了什么 / 新增了什么"
2. **逐条问 5 个问题**：
   - 这条会不会再出现？（**不再出现 → skip**）
   - 现有 skill 已经覆盖？（**已覆盖 → skip，最多补子案例**）
   - 反模式 / 组件模式 / 设计 token / 历史保护，**归到哪一类**？
   - 写下来时**别人能不能 1 分钟理解**？（写不清就别勉强加）
   - 加进去会不会让 skill 信息密度下降？（**会下降 → skip**）
3. **报告给用户**：「本轮 N 条改动，建议固化 M 条到 skill：A / B / C。其他 N-M 条是本项目特定，不入库。」让用户判断。

### 不要做的事

- ❌ **不要每条改动都进 skill**——只有可复用、有判断标准、能 1 分钟理解的才进
- ❌ **不要等到 30+ 轮再一次性蒸馏**——错过太多上下文，记不清当时为什么改
- ❌ **不要默默更新 skill**——必须告诉用户「本轮新增 N 条」，让用户有否决权

## Changelog

- **2026-05-17 · v1.5** — endpoint-management v1.1 对齐 model-management 蒸馏
  - 反模式 7（删功能时文案残留）：补案例 B「Tab 标签括号数字 (N) vs 内部节点数错位」子案例
  - 新增反模式 27：segmented tab 与 filter 中 status 字段双入口（语义重复 / source of truth 冲突）
  - 来源：endpoint-management 同时存在 seg-tab 6 态分段 + filter 中 status 下拉，状态机历史 tab 标签写「(4)」实际渲染 5 个节点
  - 适用：所有带状态机的资源列表页（endpoint / 工单 / 订单 / 任务 / 评测 run / 审批流）

- **2026-05-15 · v1.4** — eval-sets v2.1 清理蒸馏
  - 反模式 1（PM 术语）：补「列表分组顶部 N 个示例 · 点击卡片查看详情」子案例
  - 新增反模式 26：filter-form 筛选项必须对应数据模型上的实际列，派生字段不进筛选
  - 来源：eval-sets filter-form 里的 Metric 项实际是 template 派生，无法真实查询

- **2026-05-15 · v1.3** — eval-sets v2.0 重设计蒸馏
  - 新增反模式 25：列表卡片字段必须 ⊆ 上游收集字段 ∪ 系统派生字段
  - 来源：eval-sets 卡片显示「Metric」但上传向导没收集 Metric（实际是模板类型决定的）
  - 适用：所有「上游表单 → 下游列表卡片」链路（订单 / 任务 / 用户 / 评测集）

- **2026-05-15 · v1.2** — 加入「强制评估时机 + 3 步评估流程」
  - 在「演进与维护」段加 6 个触发时机表 + 5 个评估问题 + 3 个反向禁忌
  - 目的：避免「等用户提醒才更新」/「积压太多一次性蒸馏」两种失败模式

- **2026-05-15 · v1.1** — eval-sets 6 条改动清单蒸馏
  - 反模式 1（PM 术语）：补「v0.1 评测范围 banner」子案例
  - 新增反模式 22：KPI 副标用占位文案而非真实数据构成
  - 新增反模式 23：单层列表页加面包屑
  - 新增反模式 24：KPI 卡 padding 太松占满首屏
  - 组件模式 §4 拆为「4a 仪表盘型 / 4b 紧凑型」两种 KPI 规格

- **2026-05-14 · v1.0** — 初版（某 SaaS 平台 v0.1 迭代 30+ 轮后蒸馏）
  - 设计语言：品牌红 + tokens.css + chrome.css
  - 组件模式：sidebar / topbar / filter-form / list-toolbar / wizard / drawer / modal
  - 历史版本保护机制（snapshot + meta + agent-protocol）
  - 反模式案例 20+ 条

## 🌐 跨平台支持（codex / cursor / antigravity / gemini / copilot）

本 skill 原生含 Self-Evolving Protocol（每次返工/新组件主动更新 references/）。各平台执行差异：

| 平台 | 安装路径 | Self-Evolving 触发方式 |
|---|---|---|
| Claude Code / Desktop | `~/.claude/skills/saas-prototype-design/` | 🟢 **全自动**（AI 主动更新 anti-patterns / component-patterns / design-tokens） |
| Cursor | `<project>/.cursor-plugin/skills-songshishuang/saas-prototype-design/` | 🟡 **半自动**（用户提示自检） |
| Codex CLI / App | `~/.codex/plugins/songshishuang-skills/skills/saas-prototype-design/` | 🟡 半自动 |
| Gemini CLI / Antigravity | `gemini extensions install github.com/songshishuang/Skills` | 🟡 半自动 |
| GitHub Copilot CLI | `gh copilot marketplace add songshishuang/Skills` | 🟡 半自动 |

**半自动平台的触发咒语**（完成一个页面 / 一轮原型改动后手动发给 AI）：
```
请按本 skill 的「演进与维护」段自检本轮工作，
评估有没有新组件 / 新数值 / 新反模式 / 新 token 要进 references/。
```

一键安装脚本与详细说明见仓库根 [INSTALL-MULTI-PLATFORM.md](https://github.com/songshishuang/Skills/blob/main/INSTALL-MULTI-PLATFORM.md)。

- **2026-05-15 · v1.2** — 新增跨平台支持段（codex / cursor / antigravity / gemini / copilot 路径与 Self-Evolving 触发方式）
