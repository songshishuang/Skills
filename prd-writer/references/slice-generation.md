# PRD 切片生成规则

> PRD 全本是**评审 / 治理 source of truth**，但下游消费者各有特化关注点。本文档定义如何从全本 7 节 PRD **自动派生**多个角色切片，避免「一份文档让所有人都不爽」。

## 设计原则

1. **全本 7 节是 source of truth** —— 切片永远从全本自动生成，禁止手工编辑切片
2. **切片只读 + 标注 source** —— 每个切片 frontmatter 标注 `slice` 类型 + `source_prd` 路径 + `generated_at` 日期
3. **切片不删项 · 切节** —— 章节整段保留或整段砍，**不要从段落中间挑句子**（避免上下文断裂）
4. **下游引用稳定** —— 全本章节号 + slice 章节号都稳定；下游 link 不会因为重新生成而断
5. **生成由 prd-writer 触发** —— 每次写完 / 修改全本 PRD 后，**默认同步生成 stories/ 目录 + 3 个角色切片**

## stories/ 目录 + 3 个标准切片

### `stories/` — AI 编码 agent / 研发（⭐ v2.4 替代原 `for-coding.md` 单文件）

> 设计依据：研发 AI 一次只做一个功能,喂版本级大切片仍有噪音。stories/ 把编码切片做细一层——
> 每次上下文 = `00-overview.md` + 单个 `ST-XXXX` 卡片。原 `for-coding.md` 模板转 legacy 保留兼容。

模板：[`story-overview-template.md`](../templates/story-overview-template.md) / [`story-template.md`](../templates/story-template.md) / [`story-template-lite.md`](../templates/story-template-lite.md)

**全本章节 → stories/ 的派生映射**：

| 全本章节 | 派生到 |
|---|---|
| §1 Summary | overview §1 版本目标（只取交付项,砍北极星/市场背景） |
| §3.1 需求清单 | overview §2 story 索引（每行需求归入某个 story,P0/P1/P2 带入） |
| §7.1 本期新术语 | overview §3.1 术语表 |
| §4.1.4 业务规则清单 | overview §3.2 跨 story 规则（R 编号,story 内按编号引用） |
| §2.2 用户角色 | overview §3.3 角色权限速览（两列,砍诉求散文） |
| §4.2 页面 7 段 | 各 story：业务场景→背景 · 关键字段→关键字段 · 交互动作→交互动作 · 状态变化+异常处理→状态与异常 · **验收点→AC（升格为 Given-When-Then）** |
| §2.4 非目标 | 各 story「范围-不做」+ overview |
| §4.1.3 生命周期 | 对应 story 的状态机段 |
| §7.2 ADR | 涉及的 story 内一行引用（防 second-guess） |

**砍掉的全本章节**：§2.3 北极星/KR · §2.6 Open Questions · §3.2 大部分非功能 · §5 Rollout & Risks · §6.2 评测指标 · §6.3 验收清单（QA 切片有）· §7.3 历史版本 · frontmatter 治理字段。

**⚠️ 砍 §6.2/§6.3 的例外——验收数据必须随 story 自包含**：研发 AI **只读 `00-overview.md` + 单个 story**、读不到全本 PRD。故 story 的 AC 凡把 **golden fixture / 数据样例 / 期望值 / 枚举对照表** 当**复跑或验收依据**引用的，这部分内容必须**内联到 overview（如新增「§3.5 验收基线 / Golden Fixture」节）或 story 内**——派生时从全本 §6.2 等带入、标注"派生自 §x"保真相源。**只写"见 PRD §6.2"而内容不进 stories/ = 研发不可复跑、AC 形同虚设**（frontmatter `source:` 回链全本仅供治理跳转，不替代研发必读数据的内联）。

**story 拆分粒度**：
- 一个 story = 一个可独立交付的功能闭环（通常对应 §4.2 一个页面或一条端到端流程）,正文 ≤100 行
- **拆分轴 = 垂直价值增量,不是水平 UI 层**：每片穿透 展示+逻辑+数据、是用户可独立交付/验收的成品。沿价值缝切——MVP→增强 / 流程步骤 / CRUD / 角色 / 主路 vs 异常 / 多端。**禁止**把一个页面/组件按 UI 层(框架 / 行 / 区域)水平拆(会造出"零件 A 怎么插进零件 B"的假集成缝)。一个页面**通常 = 1 增量,但可拆成数个垂直增量**(如 MVP 表 → 进度条增强),关键是每片能独立交付,而非按层切
- **反向自检**：若一张卡的「依赖与边界」需要描述"我怎么插进兄弟卡的内部",即过度拆分 → 合并；切不出第二个**能独立交付**的价值块,就别切
- 小改动 / 文案修正用 lite 模板,**不强拆**
- 命名 `ST-{版本两位}{序号两位}-{标题}.md`;依赖用 frontmatter `depends_on` 显式声明,禁止成环

**质量门禁与状态权属**：story 派生后默认 `status: draft`（spec 状态，PM 仓权属）；过 `prd-reviewer` 分级关卡（标准=三关，lite=两关）`spec_test: passed` → `ai-passed`；研发 48h 走查全过 → `ready` 才交研发。交付状态（`pending → in-dev → done`）记**研发仓** `specs/V{X.Y}/delivery-status.md`，研发对 PM 仓派生文件零修改，重派生不会覆盖签收记录。

### `slices/for-qa.md` — QA / 算法

**保留**：
- §1 Summary
- §3.1 需求清单（看 P0 / P1 测试范围）
- §4.2 页面 7 段中**仅「业务场景 / 关键字段 / 异常处理 / 验收点」4 段**
- §4.3.5 兜底策略（兜底文案测试用）
- §6.2 评测指标（全保留 · QA 核心）
- §6.3 验收清单（全保留 · QA 核心）

**砍**：业务背景 / KR / 页面布局 / Design 业务对象（除非状态机）/ Rollout / 埋点表 / ADR

### `slices/for-bi.md` — BI / 数据

**保留**：
- §1 Summary（看本期要监控什么）
- §2.3 北极星 + KR（业务目标 · BI 核心）
- §6.1 数据埋点（**BI 9 列** = 全本 5 列继承 + 4 列 BI 扩展：事件描述 / 页面路径 / 页面名称 / 告警阈值，PM 补全或标 TBD · 转换规则见 `tracking-events-spec.md` 第二节）
- §6.2.2 在线指标（看板设计依据）

**砍**：用户角色 / 业务对象 / 页面设计 / AI 模块特化 / Rollout / 评测 / 验收 / ADR

### `slices/for-ops.md` — SRE / 运营

**保留**：
- §1 Summary
- §2.4 非目标（运营对外口径 · 防止过承诺）
- §3.2 非功能性需求（全保留）
- §4.3.5 兜底策略（运营事故应对）
- §5 Rollout & Risks 整节（全保留 · SRE 核心）
- §6.2.2 在线指标（运维告警阈值）
- §6.3 验收清单（上线前自查）

**砍**：业务背景 / KR / 用户故事 / 业务对象 / 页面设计（运营不直接管 UI）/ 埋点字段 / 评测集 / ADR / 历史版本

## 生成时机

| 触发 | 生成 |
|---|---|
| 全本 PRD 首次写完 | stories/ 目录 + 3 个切片同时生成 |
| 全本 PRD 修改任何 §1-§7 章节 | 重新生成 3 个切片；stories/ 只重派生**受影响的 story**（overview 索引 + 变更记录同步更新；已 `in-dev` 的 story 需研发重新签收） |
| 全本仅 frontmatter（revision_log / review_log）更新 | 不重新生成切片 |
| 评审通过 status: draft → approved | 重新生成 + 写入 git tag |

## 切片之间禁止互引

- ❌ story 卡片链接 `for-bi.md`（切片之间割裂消费）
- ✅ story 卡片 frontmatter `source:` 回链全本 `PRD-V{X.Y}.md` 的具体章节锚点
- ✅ 例外：stories/ 目录**内部**允许 story → `00-overview.md` 的 R 编号引用（overview 就是为消除 story 间重复而存在）
- ❌ story 正文（尤其「依赖与边界」）**点兄弟 story 的 ID 描述其职责**（如 ST-0701 写"告警动作由 ST-0703 消费本页数据"、ST-0703 反向"依赖 ST-0701"）——双向点名 = 隐性耦合，改一个要改俩、依赖散落正文难维护；跨 story 依赖**只在 overview 索引表的「依赖」列声明**（单向、集中），story 正文「依赖与边界」只描述本 story 自身边界

## Anti-patterns（切片设计反模式）

| ❌ 反模式 | ✅ 正确做法 |
|---|---|
| 切片里手工编辑内容 | 改全本 + 重新生成切片 |
| 从段落中间挑句子 | 章节整段保留 / 砍 |
| 切片之间互引 | 都引全本 |
| story 正文点兄弟 story_id 述其职责 | 依赖只在 overview 索引「依赖」列声明（单向）；正文只说本 story 自身边界 |
| 切片含 N/A 章节 | 不适用的章节直接不出现在切片里 |
| 切片不写 `source_prd` 路径 | frontmatter 必含 source_prd · generated_at · slice 类型 |
| 给切片加非全本内容 | 切片永远是全本的子集 · 不引入新信息 |
| story AC 把 §6.2 golden fixture / 期望值当复跑依据，但内容只在全本、不进 stories/ | 研发只喂 overview+story 读不到 = AC 不可复跑 | 被引用的 fixture/期望值内联到 overview/story（标注"派生自 §x"）|

## 协作约定

- **PM**：只维护全本 PRD。stories/ 与切片自动派生，PM 不手工管；story 过 `prd-reviewer` 分级关卡标 `ai-passed`，研发走查过才标 `ready`。
- **研发 / QA / BI / SRE**：默认读对应切片。需要看全本上下文时通过链接跳转。
- **AI 编码 agent**：**默认只读 `stories/00-overview.md` + 当前实现的单个 `ST-XXXX` 卡片**。读全本只在 story + overview 不足以决策时；发现需求问题回流 PM，不改 story 文件。
