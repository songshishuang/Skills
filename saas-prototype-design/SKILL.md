---
name: saas-prototype-design
description: 设计企业 SaaS 高保真原型的完整方法论：v1 设计语言（品牌红 + tokens.css + chrome 框架）、组件模式（sidebar/topbar/filter-form/list-toolbar/wizard/drawer/modal/toast）、3 级嵌套结构、状态机徽章、历史版本保护机制。蒸馏自 企业 SaaS 项目 30+ 轮迭代实战，覆盖 33+ 页原型从 0 到 1 + 多次推倒重做的踩坑经验。触发场景：「做原型」「画产品 demo」「按 v1 风格做新页」「修筛选区按图例风格」「设计 SaaS 管理后台 UI」「派 Agent 改原型」「保护历史版本不被 Agent 覆盖」「prototype design」。
---

# SaaS 原型设计

## 这个 Skill 解决什么

1. **风格一致性** — 多人 / 多 Agent 同时改原型时，设计语言不漂移
2. **效率** — 复用现成 chrome / token / 组件模式，新页面 30 分钟到 1 小时完成
3. **历史版本保护** — Agent 大改时不会覆盖之前精心迭代的功能
4. **避坑** — 固化 企业 SaaS 项目踩过的 20+ 个返工经验，新项目不重蹈覆辙

## 触发场景

- 「做一个高保真原型」「画产品 demo」
- 「按 v1 风格做新页面」「跟 v1 设计语言 一致」
- 「修条件查询区 / 表格工具栏」
- 「派 Agent 改原型 + 保护历史版本」
- 「设计 SaaS 管理后台 UI」「企业级 admin / portal 界面」

## 何时不用

- ❌ 生产前端工程(本 skill 产出评审 / 对接用高保真原型,不是生产代码规范)
- ❌ C 端营销页 / 官网落地页(设计语言是企业后台向)
- ❌ 画产品架构图 / 功能架构图 → 用 `saas-arch-diagrams`
- ❌ 从原型反推 PRD → 用 `prd-writer` Stage 0.5(本 skill 只管原型本身,衔接点是 prototype-meta 的 prd-mapping 字段)

## 主工作流:从 0 做一个新页(7 步)

1. **起手**:复制 [`templates/page-skeleton.html`](templates/page-skeleton.html),改 prototype-meta + `<title>` + sidebar 菜单组
2. **铺数据**:示例行换成真实业务语料(原则 12 · 每个字段答得出"真实系统谁产出它")
3. **搭区块**:按页面类型选组件——列表页 = filter-form + list-toolbar + tbl + pager;详情用 drawer 不开新页;多步表单用 wizard(速查见下两节)
4. **接交互**:行点击 drawer / modal 新建(反模式 28 写法)/ 每个 tab 都有内容(原则 10)/ 批量操作真实联动(§18)
5. **过反模式**:对照 [`references/anti-patterns.md`](references/anti-patterns.md) 高频 5 类自查——文案残留 / tab 空白 / 占位按钮 / 评审注解混入 UI(1e)/ PM 术语
6. **跑自检**:`bash scripts/check-residual.sh <file>` 7 项全过
7. **留痕**:更新 prototype-meta(version / last-modified / key-features);此后任何大改先 `bash scripts/snapshot.sh <file>`

## 不可违反的 12 条原则（来自实战返工）

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
| 11 | **字段名优先中文** · label / column / placeholder / message / toast 一律中文（仅 ID/code/mono 标识保留英文） | 「model_id」「vendor」「context_window」直接呈现给业务用户 |
| 12 | **原型用真实业务示例数据**，不用 `data1`/`Lorem`/`测试模型 A`；**mock 结构与字段必须可溯源**（每个字段都答得出"真实系统哪个组件产出它"，不臆造平行数据结构） | 列表里 16 条都是 "测试模型 1-16"；探针明明只输出 case 命中列表，mock 却另造 `modelIdentity` 身份核对产物（详见反模式 29） |

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

## 组件模式速查（v2.0 拆 2 文件 · 通用 + 业务特化）

### 🟢 通用核心组件（§1-§18 · 任何 SaaS 都用）

完整规范见 [`references/component-patterns.md`](references/component-patterns.md)。**8 大最常用**：

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

> 其余 10 件套见 component-patterns.md：modal / toast / 上传 / CSV / 状态徽章 / 数字格式 / 状态机字典 / 分页器 / 批量操作 / page-header 等

### 🟡 业务特化组件（§19-§25 · 按业务需要引用）

按需引用 [`references/business-components.md`](references/business-components.md)。**v2.0 拆出**：

| § | 组件 | 业务领域 | 何时用 |
|---|---|---|---|
| §19 | 混合表单 + JSON | API 接入 | 模型/接口接入页 |
| §20 | 申请流程 stepper | vendor 入驻 / 工单 | 多步审批 / 注册 |
| §21 | RatingBadge ABCDE | 评级 / SLA | 综合评分 / 信用等级 |
| §22 | RadarChart 多维雷达 | 对标 / 能力评估 | 多维度对比 |
| §23 | AlarmCard P0-P3 | 监控 / 告警台 | 事件管理 |
| §24 | ServiceLamp 3 态 | 服务健康 / pipeline | 顶栏服务状态指示 |
| §25 | ThemeSwitcher 4 维 | 多品牌 SaaS | 主题切换器 |

> **通用 SaaS 项目通常用不到 §19-§25**，可忽略 business-components.md。

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
- ❌ **不要让 anti-patterns 超过 30 条 / component-patterns 超过 20 条**——超过即触发简化评审（v2.x 新增防膨胀约束）

### 简化驱动评估（v2.x 新增 · 每次 evolution 必问）

**反向简化清单 · 防止 28 反模式 / 25 组件单调累加**：

- [ ] **未引用检查**：哪条反模式 / 组件模式 ≥ 3 个月没被实际场景命中？标 deprecated 候选
- [ ] **重复检查**：本次踩坑跟现有反模式 X 是不是同一根因？应**合并**而不是新加一条
- [ ] **业务特化检查**：这条规则只在某个项目踩到吗？加 `scope: 项目特化` 元字段或拆到独立目录（如 `business-components.md`）
- [ ] **Changelog 反向流**：最近 N 条 changelog 是不是全是 `+§X` 新增？这次能不能落一条「合并 / 删除 / 降级 / 拆分」记录？
- [ ] **配色 / token 收敛**：5 套主色 + 4 维切换是否所有项目都用到？少用的可以从主 token 降到 references 附录
- [ ] **scripts 实际使用**：`check-residual.sh` / `snapshot.sh` 上次真实运行是什么时候？长期不用应迁到 `scripts/legacy/`

任一勾选 → 显式回头**简化** skill + 告知用户「本轮新增 N 条 / 简化 M 条」。**简化驱动至少与增长驱动同等优先**。

## Changelog

- **2026-06-12 · v2.2** — **营造大修（勘验 61 → 复评 ~85 · 测试驱动三关）**
  - **资产一致性**：补 `templates/page-skeleton.html` 起手骨架（类名与 chrome.css / chrome.js 契约 1:1 核对，自检 7 项 0 报告）；design-tokens 4 处引用修正（§21-25 指回 business-components）；history-protection 不再内嵌脚本副本（scripts/ 为单一真相源——曾因副本漂移导致两边检查规则不一致）
  - **check-residual.sh 修复**：ERE `(?!)` 负向断言非法 + `||echo 0` 掩错导致「占位按钮」检查**永远静默输出 0**；改 `-o` 逐标签提取+排除法（同行多按钮不再被首个 onclick 掩护漏检；disabled 为声明性非交互不算占位）
  - **新增主工作流「从 0 做一个新页」7 步** + 「何时不用」负触发 4 条 + README（开源首屏：一句话钩子 + 资产数字表 + 30 秒上手）
  - **Changelog v1.x 12 条归档** `references/changelog-archive.md`（SKILL.md 352 → 256 行）
  - **反模式 1e 补条**：评审备注贴「上线前删除」标签仍渲染 = 违例（盲测抓获原版半失守；§20 演示控件先例仅限功能控件不限说明文案）
  - **测试资产**：`tests/test-prompts.md` 三 prompt 四件套（组件正链路 / 改写保护诱饵 / 1e 对抗诱饵），裸基线对照三题均可区分;盲评 TP-1 6→9.5、TP-3 8.5→9.5 无劣化
- **2026-06-12 · v2.1.1** — 反模式 1e 深化（第 3 次踩坑 · MaaS v0.3 监测列表）
  - 新增违例形态「**PageHeader desc 写成页面使用说明书**」：页签机制 / 派生口径 / 跨页导览（「全局态势请看监控看板」）/ 交互指引（「点详情下钻」）串成副标题；「已上线 endpoint 的实时监测」式**范围注解**同属此类
  - 识别口径扩展：回答「这个页怎么用 / 页签是什么机制 / 点哪去哪 / 本页范围怎么圈」= 页面说明书，删——真实产品交互靠自明性（页签 label / 按钮 / 空态 / tooltip），不靠页头印说明书
  - 修正规则补：**desc 槽存在 ≠ 必须填**，填只填用户视角一句话，写不出就留空；机制说明正确去处 = 代码注释（给维护者）/ PRD §4.2 或 story 卡片（给评审与研发）
  - 隐蔽性升级提示：前两次是卡片底部/配置旁注解，这次**伪装成页面副标题**（位置"合法"内容违例）——全页扫描范围明确含每个 PageHeader 的 desc
- **2026-06-10 · v2.1** — 反模式 1e「评审/研发向注解混入产品 UI」+ 反模式 29「mock 臆造无来源数据结构」
  - **反模式 29（原则 12 深化）**：mock 是前后端数据契约的原型——每个字段必须答得出"真实系统哪个组件产出它"；不臆造平行结构（独立身份核对产物）、不残留已砍口径（抽样样本计数）、不造处置链数据（工单/已采取）；同一事实跨区块要对账自洽（探针未通过数 = 矩阵失败维度数）
  - 反模式 1 新增子条 1e「评审/研发向注解混入产品 UI」
  - 状态判定口径 / token 成本估算 / 数据血缘（「同源只读」「单一真相源」）/ 设计权衡说明 不进原型 UI → 降级为代码注释或写 PRD
  - 识别口径：文案回答「怎么算的 / 从哪同步 / 花多少成本」= 注解删；回答「填什么 / 当前状态」= 产品文案留
  - 来源：MaaS v0.3 监测配置同类踩 2 次（第一次只删「契约 §5.1」漏了成本估算与口径声明，第二次用户点名整类）

- **2026-06-01 · v2.0** — **脱敏 + 边界拆分 + 强契约 + Self-Evolving 反向简化**
  - **通用化命名**：原项目特定的业务组件命名 / CSS 变量前缀 / 品牌色注释 全部替换为通用术语，确保跨项目复用
  - **边界拆分**：7 条架构图相关反模式（原反模式 3, 11, 12, 13, 14, 15, 16）迁出到 `saas-arch-diagrams/references/anti-patterns.md`，原位置留迁出 stub；anti-patterns.md 907 → 769 行（-15%）
  - **prototype-meta 加 `prd-mapping` 字段**：与 `prd-writer` Stage 0.5 反推 PRD 的**唯一强契约点**；prd-mapping 含 page-role / user-roles / state-machine / key-flows / business-entities / api-touch-points 6 字段，直接映射 PRD v2.3 7 节结构
  - **Self-Evolving 加反向简化驱动**：「不要做的事」增加防膨胀约束「anti-patterns ≤ 30 / component-patterns ≤ 20」+ 6 条反向简化清单

> 更早的 v1.x 演进记录（v1.0-v1.9 · 12 条）已归档至 [`references/changelog-archive.md`](references/changelog-archive.md)。

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

