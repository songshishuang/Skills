---
name: prd-writer
description: Use when user asks to write a new PRD / 产品需求文档 / V0.X 需求, structure raw requirements (会议纪要 / 需求列表 / Figma 链接) into a formal spec, or upgrade an older PRD to a versioned standard. Strongly applies when the product contains AI/LLM/RAG modules that need tracking events, evaluation metrics, gradual rollout, and acceptance criteria. Triggers include phrases like "写 PRD" "需求文档" "生成需求" "PRD V0.X" "产品需求" "写需求" "PRD 模板" "把这段需求结构化" "补全 V0.X 的埋点和评测" "按 PRD 标准写".
---

# PRD Writer

## Overview

按 **7 节标准结构** 产出 AI 产品 PRD（Summary / Problem & Goals / Scope / Design / Rollout & Risks / Quality / Appendix）。

结构源自作者 V0.5 实际使用版本，借鉴 **Amazon Working Backwards / Basecamp Shape Up / Google Design Doc / Linear spec / Atlassian Poster** 等社区现代产品文档模式，将原 V2.x 的 13 节压缩为 7 节，治理元信息（修订/评审/参考链接）移到 frontmatter，业务核心 Design 章节权重从 1/13 提升到 1/7。

**配套交付 · 角色切片**：每次产出全本 PRD 后，自动派生 **stories/ 目录**（研发 AI 编码用：`00-overview.md` + 按 story 拆分的 `ST-XXXX` 卡片）+ 3 个只读切片（`for-qa` / `for-bi` / `for-ops`，与 stories/ 合计 4 类角色产物）—— 解决"一份 PRD 撑 6 个消费者互相污染"的问题。AI 编码 agent 每次只读 `00-overview.md` + 单个 story 卡片，上下文最小化。

**核心原则**：
1. 全本 7 节是 source of truth · 切片自动派生 · 切片只读
2. 章节"按场景必填"而非"全员必填"—— 不适用的节就**删**而不是标 N/A
3. AI 产品必备的 6 大缺口（业务目标 / 用户故事 / 数据埋点 / 评测指标 / 灰度上线 / 验收清单）仍然覆盖 · 仅重组归类

## 何时使用

- 写一份新版本的 PRD（如 "V0.9 需求"、"下个迭代的 PRD"）
- 把一段需求描述 / 会议纪要 / Figma 链接结构化为正式文档
- 升级旧 PRD 到 7 节标准结构
- **⭐ 从已有高保真原型反推 PRD**（HTML 原型 / Figma 链接 / 设计稿截图 / 多页面 demo）
- 用户问 "AI 产品 PRD 怎么写" 这类元问题

## 何时不用

- ❌ 一次性技术调研 → 用 doc-coauthoring
- ❌ 内部 RFC / 决策记录 → 用 doc-coauthoring
- ❌ 客户营销文档 → 直接 frontend-design 写 HTML
- ❌ 单个功能的 spec（< 1 屏内容）→ 直接写 markdown，不需要 7 节
- ❌ 工程文档 / API 文档 → 用对应技术文档模板

## 工作流（Stage 0 → 4 · 共 6 阶段）

### Stage 0：读项目 wiki（如存在）⭐

**触发条件**：项目存在 wiki 根目录（由 `pm-wiki-maintainer` skill 维护）——按 `docs/wiki/` → `docs/pm/wiki/` 顺序探测，取首个存在者记为 `{wiki_root}`（MaaS 在 `docs/pm/wiki/`）。

**目的**：把之前所有项目知识沉淀（PRD / 决策 / 概念 / 主题 / 竞品 / 角色）作为**先验上下文**，避免"重新发明轮子"。

**3 步**：

1. **读 wiki 索引**：`Read {wiki_root}/index.md`
2. **判断本期 PRD 主题关键词**，drill 进相关页：
   - PRD 涉及 X 业务 → 读 `topics/{X}.md`
   - PRD 涉及新决策 → 读 `decisions/{相关主题}.md`（综合视图）
   - PRD 涉及核心概念 → 读 `concepts/{概念}.md`
   - PRD 涉及客户 / 竞品 / 角色 → 读 `entities/{category}/{name}.md`
3. **必读 `{wiki_root}/glossary.md`** —— 保持术语一致性

**沉淀回填**：本次 PRD 产出的新决策 / 新概念 / 新主题，写完 PRD 后建议触发 `pm-wiki-maintainer` ingest。

**反模式**：
- ❌ 项目有 wiki 但跳过 Stage 0 → PRD 跟项目历史脱节
- ❌ 把 wiki 内容直接 copy 进新 PRD → wiki 是 synthesis；引用链接，不复制内容
- ❌ 发现 wiki 冲突默默改 wiki → 这是 pm-wiki-maintainer 的职责

### Stage 0.5：从高保真原型反推（如有）⭐

**触发条件**：用户提供了高保真原型 —— `prototypes/` 目录下的 HTML、Figma / Sketch 链接、设计稿截图、可点击 demo。

**目的**：原型已隐含大量需求信息（页面布局 / 交互 / 字段 / 状态 / 角色 / 流程）。本阶段把原型"反推"为 PRD 结构化内容。

**反推映射表**（原型元素 → PRD 章节）：

| 原型里看到 | 反推到 PRD 哪节 |
|---|---|
| 角色切换器 / 多端 tab | §2.2 用户角色 |
| sidebar 菜单 + 页面清单 | §3.1 需求范围 |
| 单页整体布局 | §4.2 页面 7 段第 ②「页面布局」|
| 表单字段 / 表格列 | §4.2 页面 7 段第 ③「关键字段」+ §4.1 业务对象 |
| 按钮 / 链接 / hover / click | §4.2 页面 7 段第 ④「交互动作」|
| 状态徽章 | §4.1.3 业务对象生命周期 stateDiagram-v2 |
| 表单校验 / 错误 toast | §4.2 页面 7 段第 ⑥「异常处理」|
| 列表的 demo 数据 | 推断业务对象类型 + §4.1.1 业务对象总览 |
| wizard / stepper | §2.5 端到端流程图 |
| 页面间跳转 | §4.1.5 对象-页面映射 + §4.2 交互动作 |
| AI Copilot 侧栏 / 推荐卡 / 兜底文案 | §4.3 AI 模块特化 |
| 卡片色 chip / 优先级色 | §4.2 第 ⑤「状态变化」配色约定 |
| 空态 / loading 文案 | §4.2 第 ⑥「异常处理」|

**4 步反推流程**：

1. **盘点原型**：HTML 原型 → Read 所有 .html · Figma 链接 → 用户导出 PNG / 描述 · 截图 → 逐张读
2. **页面级提炼**：每个核心页面跑 §4.2 7 段标准模板
3. **跨页面综合**：业务对象（多页反复出现的实体）/ 状态机（带徽章的对象）/ 角色（不同端的页面差异）/ 流程（连续跳转的 wizard）
4. **回填 Stage 1 的 6 个核心问题**：原型通常能直接回答 Q2 / Q3，仍需找用户确认剩余 4 个——Q1 版本号与背景、Q4 优先级、Q5 AI 模块、Q6 灰度与上线时间（与 Stage 1「信息收集捷径」一致）

**反模式**：
- ❌ 看到原型就直接开写 —— 必须先和用户对 ground truth
- ❌ 把原型 demo 数据当业务规则 —— 真实约束（如"最多 100 条/天"）必须问用户
- ❌ 只看一个页面就泛化业务对象
- ❌ 把原型视觉细节写进 PRD（PRD 不是设计文档）
- ❌ 跳过角色权限差异

**与 `saas-prototype-design` skill 协作**：业务讨论 → saas-prototype-design 出原型 → 客户评审 → prd-writer Stage 0.5 反推 PRD → 研发评审。

### Stage 1：信息收集（不要直接动笔）

向用户问 6 个核心问题。**没拿全答案前禁止进 Stage 2**：

1. **版本号 + 业务背景**：要做 V0.X？解决什么痛点？为什么这个版本要做这些？
2. **目标用户 + 核心场景**：谁用？典型场景是什么？
3. **本次需求范围**：列出本版本要改的功能点（新增 / 修改 / 废弃）
4. **优先级判断**：P0 / P1 / P2 怎么分
5. **是否包含 AI 模块**：LLM / RAG / Agent / 多模态？是哪些功能？
6. **目标上线时间 + 灰度策略**：硬截止？要不要灰度？

**信息收集捷径**：
- 上一版 PRD → 沿用作者风格、表头、版本号格式
- 完成了 Stage 0.5 → Q2 / Q3 已被原型回答，只剩 Q1 / Q4 / Q5 / Q6

### Stage 2：按 7 节结构生成 PRD

读取 `templates/prd-template.md` 作骨架，按收集到的信息逐节填充。

**7 节结构**：

```
─── frontmatter（YAML：version / status / owner / revision_log / review_log / links）
一、Summary 版本说明              ← 3-5 bullets 核心变化
二、Problem & Goals 问题与目标    ← 业务背景 + 用户角色 + 北极星/KR + 非目标 + 端到端流程图 + Open Questions
三、Scope 需求范围                ← 需求清单（P0/P1/P2）+ 非功能性需求（精简）
四、Design 需求设计 ⭐            ← 4.1 业务对象关系 + 4.2 页面 7 段 + 4.3 AI 模块特化
五、Rollout & Risks 上线与风险    ← 灰度 + 回滚 + 上下游依赖 + 风险 + 成本预算
六、Quality 质量保障              ← 数据埋点 + 评测指标 + 验收清单
七、Appendix 附录                ← 术语 + ADR + 历史版本 + 链接
```

**🚫 PRD 不写的内容（留给工程文档）**：
- ❌ REST API 接口清单（path / method / params）→ OpenAPI yaml / `docs/api/`
- ❌ 数据库 schema（PK / FK / 字段类型 / 索引）→ DDL / `docs/data/`
- ❌ 类图 / 时序图 / 组件图（UML）→ ADR / arch doc

§4.1 业务对象关系从**业务视角**说清楚：业务对象总览 + 关系图（mermaid · 业务概念不含技术字段）+ 生命周期 + 业务规则清单 + 业务对象与页面映射。这是开发 / 测试 / 验收的业务依据，不是技术依据。

### Stage 2 附属规范 A · §4.1「业务对象关系」5 子段标准

| 子段 | 内容 |
|---|---|
| 4.1.1 业务对象总览 | 表格列出所有核心业务对象（名 / 业务定义 / 谁拥有 / 维护）|
| 4.1.2 关系图 | mermaid erDiagram · **不写 PK/FK/类型** · 用业务概念命名 |
| 4.1.3 生命周期 | 每个有状态机的对象画流转图（stateDiagram-v2）|
| 4.1.4 业务规则清单 | 跨对象的关键业务约束，表格化 |
| 4.1.5 对象-页面映射 | 表格：每个业务对象在哪些页面展示 / 在哪些页面被操作 |

### Stage 2 附属规范 B · §4.2「页面功能详细设计」7 段标准

每个核心页面用以下 7 段表格化展示（详见 `templates/page-design-template.md`）：

| 维度 | 说明 |
|---|---|
| 业务场景 | 这页解决什么业务问题 · 谁主要用 |
| 页面布局 | 区块布局（sidebar / topbar / 主区结构 / KPI 卡 / filter / 表格 / drawer / modal）|
| 关键字段 | 数据字段清单 ⊆ §4.1 业务对象 · 字段闭环校验 |
| 交互动作 | 所有 click / hover / 提交触发的反馈 + 跳转 |
| 状态变化 | 涉及状态机的页面要列状态迁移 |
| 异常处理 | 校验 / 失败 / 二次确认 / 权限不足 等边界场景 |
| 验收点 | ① ② ③ ... 明确可勾选的验收条件 |

**用途**：让开发知道"做什么"、QA 知道"验什么"、运营知道"怎么用"。一条 ≤ 30 字精炼，整体每页 ≤ 50 行。

### Stage 3：AI 模块特化（条件触发）

**先区分 AI 类型**：

| AI 类型 | 是否详化 §4.3 | 处理方式 |
|---|---|---|
| **对外生成式 AI**（用户直接看到生成内容） | ✅ 详化 6 小节 | 在 §4.3 完整 6 小节 |
| **内部 AI 依赖**（不对用户暴露） | ⚠️ 不详化 | 在 §5.3 依赖中简述 |
| **传统规则 / 检索 / 算法**（无 LLM） | ❌ 不触发 | 删除 §4.3 整节 |

**对外生成式 AI 6 小节**：模型选择 + 提示词版本 + 知识库依赖 + 工具调用清单 + 兜底策略 + 可观测性。

参考 `references/ai-product-checklist.md`（7 维度 checklist + 评审 5 问）。

埋点 §6.1 按 `references/tracking-events-spec.md`。

### Stage 4：生成切片（自动）

写完全本 PRD 后，**默认同时生成 stories/ 目录 + 3 个角色切片**：

| 切片 | 消费者 | 模板 |
|---|---|---|
| `stories/`（⭐ v2.4 替代原 for-coding.md） | AI 编码 agent / 研发 | `templates/story-overview-template.md` + `templates/story-template.md`（小改动用 `story-template-lite.md`） |
| `slices/for-qa.md` | QA / 算法 | 见 `references/slice-generation.md` |
| `slices/for-bi.md` | BI / 数据 | 见 `references/slice-generation.md` |
| `slices/for-ops.md` | SRE / 运营 | 见 `references/slice-generation.md` |

**stories/ 派生规则**（详见 `references/slice-generation.md`）：
- 一个 story = 一个可独立交付的功能闭环（通常对应全本 §4.2 的一个页面或一条端到端流程），正文 ≤100 行
- **粒度弹性**：小改动 / 文案修正用 lite 模板，**不强拆**成标准 story（防"小 bug 拆 4 story 16 AC"式过度工程）
- 公共信息（术语 / 跨 story 规则 / 角色权限）只写 `00-overview.md`，story 内按 R 编号引用
- AC 一律 Given-When-Then；「范围-不做」必填，相邻功能注明所属 story
- story 命名：`ST-{版本两位}{序号两位}-{标题}.md`（如 V0.4 第 1 个 → `ST-0401-告警规则管理.md`）

切片规则：**章节整段保留或整段砍 · 不从段落中间挑句子 · 不允许切片间互引 · 切片只读**。详见 `references/slice-generation.md`。

**与 `prd-reviewer` 衔接**：stories/ 生成后默认 `status: draft`（spec 状态，PM 仓权属），立即跑 `prd-reviewer` 分级关卡（标准=三关，lite=两关）全过标 `ai-passed`；研发 48h 走查过才 `ready` 交研发。交付状态（in-dev/done）记**研发仓** `specs/V{X.Y}/delivery-status.md`，PM 仓不记、重派生不覆盖。

## 输出格式

PRD 默认**同时**生成 `.md` 和 `.html` 两个版本（本 skill 固有约定，不依赖外部偏好配置）：

- `.md` —— 给 git 历史 / AI agent 解析 / 评审讨论用
- `.html` —— 主版本，给业务方 / 团队浏览，含 TOC / 卡片化样式 / 响应式

HTML 风格参考：
- 左侧 sticky TOC（7 章节锚点）
- 顶部 hero（含 version badge + 北极星 + KR 速览 chips）
- 卡片式分节，红色顶部 hero 区
- 表格 + badge（P0/P1/P2 优先级、新增/修改类型）
- 内联全部 CSS，自包含，可直接双击打开

**输出位置**：**沿用项目既有 PRD 目录结构**（先看上一版 PRD 在哪——MaaS 为全本 `docs/pm/prd/PRD-v{X.Y}.md` + 附属 `docs/pm/prd/V{X.Y}/`）；新项目无既有结构时默认 `02_PRD/V{X.Y}/V{X_Y}_产品需求文档.{md,html}`。**不要把既有项目的产物写进默认目录**。

**附属交付物**（每次同步交付）：
```
{prd_dir}/V{X.Y}/   # {prd_dir} 沿用项目既有 PRD 目录;示例为默认结构(MaaS:全本在 docs/pm/prd/ 根,以下附属在 docs/pm/prd/V{X.Y}/)
├── V{X_Y}_产品需求文档.md         # 全本 7 节
├── V{X_Y}_产品需求文档.html       # 同上 HTML
├── 埋点表.csv                     # 给 BI 同学建表
├── 评测集要求.md                  # 给 QA / 算法准备评测集
├── stories/                       # ⭐ 研发 AI 编码区（v2.4 替代 for-coding.md）
│   ├── 00-overview.md             # 版本目标 + story 索引 + 公共约定
│   ├── ST-{XY}01-{标题}.md        # 标准 story 卡片（≤100 行）
│   └── ST-{XY}NN-{标题}.md        # 小改动用 lite 模板
└── slices/                        # 其余角色切片（自动派生）
    ├── for-qa.md
    ├── for-bi.md
    └── for-ops.md
```

## 完成标准（DoD · 分层必填）

> 旧版"11 项必填"已分层。**不适用的章节直接删除，不要保留 `N/A`**（保留 N/A 会污染 AI 编码切片）。

### 🔴 核心必填（任何 PRD 都要 · 10 项）

- [ ] **Stage 0 完成**：如探测到 wiki 根（`docs/wiki/` → `docs/pm/wiki/` 顺序），已读 index.md + 相关页（两处均不存在才注明"项目无 wiki"）
- [ ] **Stage 0.5 完成**：如用户提供了高保真原型，已按反推映射表提炼 + 与用户确认（如未提供则注明"无原型输入"）
- [ ] **frontmatter 完整**：含 version / status / owner / revision_log / review_log / links 完整字段
- [ ] §1 Summary 3-5 bullets
- [ ] **§2.4 非目标**：明确写"不做什么"
- [ ] **§2.5 端到端流程图**：mermaid flowchart 必填
- [ ] §3.1 需求清单按 P0/P1/P2 排序（**不按系统排**）
- [ ] **§4.1 业务对象关系**（5 子段：总览 / 关系图 mermaid / 生命周期 / 业务规则 / 对象-页面映射）· 业务视角不是技术字段
- [ ] **§4.2 页面功能 7 段**（业务场景 / 页面布局 / 关键字段 / 交互动作 / 状态变化 / 异常处理 / 验收点）
- [ ] **§7.2 ADR 至少 1 条**关键决策记录

### 🟡 场景必填（视项目特点）

- [ ] **涉及对外生成式 AI** → §4.3（6 小节）+ §3.2 AI 合规子段 + §5.5 成本预算
- [ ] **涉及多端 / 多角色** → §2.2 含权限矩阵列
- [ ] **涉及 LLM 时延敏感** → §3.2 性能 P99 阈值
- [ ] **涉及埋点上报** → §6.1 事件清单 5 列结构
- [ ] **涉及灰度** → §5.1 灰度计划 + §5.2 回滚预案
- [ ] **交付研发 AI 编码** → stories/ 目录派生完成 + 每个 story 过 `prd-reviewer` 分级关卡（`spec_test: passed` → `ai-passed`）+ 研发 48h 走查过才标 `ready`

### 🟢 推荐填写（可选 · 留空不算违规）

- [ ] §2.3 北极星 + KR（业务方关心，编码无关）
- [ ] §2.6 Open Questions（待评审决议）
- [ ] §6.2 评测指标（涉及 AI 时由算法侧补，不强制 PM 一稿包圆）
- [ ] §6.3 验收清单（QA 主导）

### 🚫 永远不写（PRD 不该有的）

- [ ] ❌ 技术 API / 数据库 schema / UML 图（属工程文档）
- [ ] ❌ 任何 `N/A` 占位章节（不适用就删除，**不要保留**）

## 反模式（不要这样做）

| 反模式 | 为什么不行 | 怎么做 |
|---|---|---|
| 用户给一段话直接动笔写 | 跳过 Stage 1，业务背景必然空泛 | 先问 6 个核心问题 |
| 业务目标写「提升体验」 | 不可验收 | 用具体百分比 / 数值 / 频率 |
| 评测章节写「具体指标待定」 | 把工作丢给下游 | 给可挑战的初稿（如 Golden ≥ 85%），让 QA 改 |
| 埋点章节只写「需要埋点」 | BI 没法建表 | 列 5 列事件表，每行可执行 |
| **保留全空章节 / 标 N/A** | N/A 章节污染 AI 编码切片噪音 | **不适用就删除**；如需保留思考线索用一行 HTML 注释 `<!-- 本期不涉及，见 V0.X+1 -->` |
| 把所有需求都标 P0 | 等于没排优先级 | 至少有 1 个 P2，强制取舍 |
| **自创全本章节名（如改成 "Goals" / "Stories"）** | 跟模板不一致，切片派生失败 | 严格沿用 §1-§7 中文章节名 |
| **PRD 写 REST API 接口清单（path/method/params）** | 技术细节 · 业务方看不懂 · 与工程文档重复 | 在 §4 业务对象段简述业务概念 · API 留 OpenAPI yaml |
| **「数据模型」段写 PK/FK/字段类型/JSON schema** | 技术视角 · 业务方读不懂业务关系 | 改用「业务对象关系」+ mermaid erDiagram 仅写业务概念 |
| **「核心页面」只列文件名+简述** | 开发不知做什么 · QA 不知验什么 | 每页 7 段标准模板 |
| **AI 章节对内部 AI 依赖也详化 6 小节** | 评测引擎 LLM-Judge 不是对外功能 · 详化浪费篇幅 | 区分对外生成式 AI（详化）vs 内部 AI 依赖（在 §5.3 简述）|
| **流程图 / 状态机 / 业务对象图 用文字描述代替** | 文字难懂 · 评审说不清 | mermaid 必填 |
| AI 模块没写兜底策略 | 上线后 LLM 挂会被骂 | §4.3.5 必明写：超时 / 低置信 / 错误 三种兜底 |
| **手工编辑 slices/ 或 stories/ 的派生文件** | 派生产物手工改会被下次重新生成覆盖；研发改 story = 双头真相源 | 改全本 PRD，重新派生；研发发现问题回流 PM |
| **PRD 全本 + 切片"包山包海"** | 一份给所有人看反而谁都看不清 | 全本是 source of truth · 各角色读对应切片 |
| **小改动强拆成标准 story** | 文案修正拆出 4 story 16 AC 是杀鸡用牛刀（SDD 粒度错配） | 用 `story-template-lite.md`，3 节搞定 |
| **story 未过评审关卡直接给研发** | 歧义靠"被迫执行"暴露，不靠"读着通顺"；带歧义的 story 让 AI 自由发挥 | 跑 `prd-reviewer` 分级关卡 → `ai-passed`，研发走查过才 `ready` |
| **story 里写"友好提示""加载较快"** | AI 无法客观判定，编码各凭理解 | AC 全部 Given-When-Then + 可观察结果 |

## Red Flags — STOP and 检查

看到以下信号立刻停下复查：

- 跳过 Stage 1 直接进 Stage 2
- 业务目标全是定性描述（"提升满意度" / "优化体验"）
- 优先级列全是 P0 或全空
- 文档里有 `N/A` 章节（应该直接删）
- §5.2 回滚说「按需回滚」而没具体步骤
- 用户已经明确说了"非目标"但 PRD 没有 §2.4
- 文件只生成了 .md 没生成 .html
- 写完全本 PRD 没生成 `stories/` 目录 + 3 个角色切片
- story 标了 `ready` 但 frontmatter 还是 `spec_test: pending`

## 好 vs 坏对照

### 业务目标
| ❌ 不可用 | ✅ 可用 |
|---|---|
| "提升 AI 采纳率" | "AI 回复采纳率从 35%（基线：BI 看板）提升到 50%（KR1）" |
| "优化客服体验" | "客服平均响应时长从 90s 降到 60s（KR3）" |

### 埋点事件
| ❌ 不可用 | ✅ 可用 |
|---|---|
| "记录 AI 回复使用情况" | 事件 ID `ai_reply_send` / 上报时机「点击发送（未编辑）」/ 扩展字段 `trace_id, no_edit=true` |

### 评测门槛
| ❌ 不可用 | ✅ 可用 |
|---|---|
| "回归测试通过" | "Golden 集通过率 ≥ 85%（LLM-as-judge）+ 对抗集 100% 通过 + 不低于上一版" |

## 风格约定（沿用 V0.5 字风格 · 节号简化）

- **二级标题用「一、二、三、...」中文序号 + 英文副标题**（如「一、Summary 版本说明」）—— 中英双标方便 AI 识别意图
- 三级标题用「2.1 / 2.2 / 4.1.1」阿拉伯数字 + 小数点（替代旧版「1、2、3」纯数字）
- 需求范围表 6 列：序号 / 系统 / 功能 / 类型 / **优先级** / 摘要
- frontmatter 字段：`product / version / status / owner / revision_log / review_log / links`
- 字段说明用粗体起头 + 冒号 + 描述（例：**全局开关：** 控制项目维度...）
- 埋点事件表（全本 §6.1）5 列：事件 ID / 上报时机 / 扩展字段 / 公共字段 ✓ / 备注

## 常见 rationalization（agent 自查）

| 借口 | 反驳 |
|---|---|
| "用户没给完整信息，先写占位符" | Stop. 回 Stage 1 问 6 个核心问题。占位符 PRD 比没 PRD 还糟 |
| "评测章节具体数值还没定，先写待定" | 给可挑战的初稿（如 P99 ≤ 3s），让算法 / QA 改 |
| "本期没 AI，§4.3 / §6.2 可以删" | **可以删**（这是 v2.3 改进点）—— 不适用的章节直接删，**不要保留 N/A** |
| "灰度策略和回滚太繁琐，简化" | 不简化。回滚预案必须能在 5 min 内执行 |
| "7 节还是太多，合并一些" | 严禁。7 节是给所有消费者覆盖的最小集；切片机制已经解决"研发觉得多"的问题，让研发读 `stories/` 即可 |
| "story 拆完直接给研发，评审下个版本再说" | 不行。三关评审 ~20 分钟/story，比研发拿着歧义 spec 跑偏一轮便宜得多 |
| "用户没提非目标，可以不写 §2.4" | 必填。让用户在评审会现场补，比上线后扯皮便宜 |
| "切片手工改一行没事" | 不行。切片是派生产物，下次重新生成会覆盖。改全本 |

## 文件清单

```
prd-writer/
├── SKILL.md                                # 本文件
├── templates/
│   ├── prd-template.md                     # 7 节全本模板（frontmatter + 业务核心）
│   ├── story-overview-template.md          # ⭐ v2.4 stories/00-overview.md 模板
│   ├── story-template.md                   # ⭐ v2.4 标准 story 卡片模板（≤100 行）
│   ├── story-template-lite.md              # ⭐ v2.4 小改动 lite 模板
│   ├── prd-template-coding-slice.md        # 编码切片模板（legacy · 被 stories/ 替代，保留兼容）
│   ├── prd-example-filled-v0.5.md          # V0.5 内容填充示例（学风格 · legacy 旧 13 节结构，仅供参考语言风格）
│   ├── page-design-template.md             # 页面 7 段标准模板
│   ├── eval-set-requirements.md            # 评测集需求模板（QA / 算法切片附属）
│   └── tracking-table-template.csv         # 埋点表 CSV（给 BI · 9 列口径）
├── tests/
│   ├── test-prompts.md                     # ⭐ v2.4.3 测试套件（4 条 × 四件套判据）
│   └── baseline-record.md                  # ⭐ v2.4.3 裸基线对照记录
└── references/
    ├── slice-generation.md                 # ⭐ stories/ 与 3 个只读切片的生成规则
    ├── ai-product-checklist.md             # AI 产品 7 维度 checklist
    └── tracking-events-spec.md             # 埋点字段规范 + 看板 SQL
```

## Self-Evolving Protocol（每次写完 PRD 主动评估）

本 skill 是 **living document**。每次写一份新 PRD 都可能产生**可复用的新经验**，必须显式回流。

### 触发评估时机

| 完成动作 | 评估问题 | 归档路径 |
|---|---|---|
| 完成一份 PRD（任何 V0.X） | 这次有没有遇到现有模板未覆盖的章节 / 字段？ | 新章节模板 → `templates/`；新评测维度 → `references/ai-product-checklist.md` |
| 用户拒绝某段写法（"不要这样写 / 删掉"） | 这条否定是不是普适规则？ | 反模式表（SKILL.md 内；条目积累过多时再拆独立 references 文件） |
| 业务方提出新埋点字段 / 新事件类型 | 项目特例还是通用模式？ | `references/tracking-events-spec.md` |
| 发现新 rationalization | 高频？要不要进自查表？ | SKILL.md 末段「常见 rationalization」 |
| 遇到新 AI 产品形态（agent / RAG / fine-tune / 多模态） | 7 节够覆盖吗？ | 主文档调整 or `references/ai-product-checklist.md` 加维度 |

### 更新约束

- ❌ **不要默默更新 skill** —— 必须告诉用户「本轮新增 N 条 X」让用户有否决权
- ❌ **不要等到 10+ 个 PRD 后再一次性蒸馏** —— 错过太多上下文
- ❌ **不要把项目特定字段当通用规则** —— 跨 ≥2 个项目验证过的才进 references
- ✅ 更新时**必须**在 SKILL.md 末尾 `## Changelog` 加一行

### 30 秒自检清单（写完 PRD 后）

**增长驱动**（有没有新东西要加）：
- [ ] 本次 PRD 有没有新 AI 模块类型？（RAG / agent / tool-use / 多模态）
- [ ] 埋点表里有没有 `tracking-table-template.csv` 没覆盖的字段？
- [ ] 评测集设计有没有新维度？（jailbreak / hallucination / bias / latency）
- [ ] 灰度策略有没有新切流维度？（用户分群 / 项目 / 渠道 / 设备）

**简化驱动**（有没有可以砍的 · v2.3 新增 · 防止模板单调膨胀）：
- [ ] 本轮 PRD 哪些章节实际 0 内容 / 应该删？这类章节是否要从「核心必填」降级为「场景必填」或「推荐填写」？
- [ ] 本轮 DoD 哪一项是「为了凑完整性」而非真的产生价值？是否要从必填降级？
- [ ] 本轮反模式表有没有自相矛盾 / 已不适用的条目？

任一项勾选 → **显式回头更新 skill** + 告知用户。**简化驱动至少与增长驱动同等优先**。

### 写完 PRD 后：建议 ingest 到项目 wiki

如果当前项目装了 `pm-wiki-maintainer` 且探测到 wiki 根（`docs/wiki/` 或 `docs/pm/wiki/`），写完 PRD 后**额外做一项**：

```
- [ ] 本次 PRD §7.2 ADR 中有几条新决策？
- [ ] §2.2 用户角色有没有新增 / 画像更新？
- [ ] §3.1 需求范围引入了几个新功能模块概念？
- [ ] §4.3 AI 模块特化里有没有新维度？
```

任一项 ≥ 1，**主动提示用户**：

> 「本轮 PRD 含 N 条新 ADR / M 个新概念，建议执行 `ingest PRD 到 wiki`，下次 V0.x+1 写作时 Stage 0 能自动加载这些上下文。是否现在 ingest？」

用户同意后 → 调用 `pm-wiki-maintainer` 的 ingest 流程。

## Bottom Line

**好 PRD = 业务方一眼能看懂目标 + 开发能直接拿走干活 + QA 知道怎么验收 + BI 知道埋什么点 + SRE 知道怎么灰度回滚。**

关键演进（v2.3 → v2.4）：**不再追求"一份 PRD 满足所有人"，而是"一份全本 + stories/ + 切片"**。AI 编码 agent 读 `00-overview.md` + 单个 story 卡片，QA 读 `for-qa.md`，BI 读 `for-bi.md`，SRE 读 `for-ops.md` —— 各取所需，互不干扰。

如果你的 PRD 让任何一个角色还要问"我该做什么？"，回 Stage 1。

## 🌐 跨平台支持（codex / cursor / antigravity / gemini / copilot）

本 skill 的核心知识（PRD 章节、反模式、切片规则）**跨平台通用**。Self-Evolving Protocol 的执行能力因宿主而异：

| 平台 | 安装路径 | Self-Evolving 触发方式 |
|---|---|---|
| Claude Code / Desktop | `~/.claude/skills/prd-writer/` | 🟢 **全自动** |
| Cursor | `<project>/.cursor-plugin/skills-songshishuang/prd-writer/` | 🟡 半自动（用户提示自检） |
| Codex CLI / App | `~/.codex/plugins/songshishuang-skills/skills/prd-writer/` | 🟡 半自动 |
| Gemini CLI / Antigravity | `gemini extensions install github.com/songshishuang/Skills` | 🟡 半自动 |
| GitHub Copilot CLI | `gh copilot marketplace add songshishuang/Skills` | 🟡 半自动 |
| ChatGPT Web / 本地小模型 | 复制 SKILL.md 到 instructions | 🔴 仅建议 |

**半自动平台的触发咒语**（写完 PRD 后手动发给 AI）：
```
请按本 skill 的 Self-Evolving Protocol 自检本轮 PRD，
评估有没有新反模式 / 新 AI 章节 / 新埋点字段要进 references/，
以及有没有章节应该砍 / DoD 应该降级（简化驱动）。
```

一键安装脚本见仓库根 [INSTALL-MULTI-PLATFORM.md](https://github.com/songshishuang/Skills/blob/main/INSTALL-MULTI-PLATFORM.md)。

## Changelog

- **2026-06-12 · v2.4.3** — 营造（yingzao）首次大修，四轮细作（双盲评 65→72.5，访例 32 对标确认生态位）：① **新增 tests/ 测试资产**——test-prompts.md 4 条四件套套件（正触发/负触发诱饵/时间压力纪律诱饵/小切片产物契约）+ baseline-record.md 裸基线对照（4 条全部非永真，含 T2 防回归适用性说明）；② 一致性修复 19 处——工作流标题"4 阶段"→6 阶段、Q 编号矛盾、断链引用、外围资产旧 13 节编号残留（§6.x→§4.x ×5、"第七章/八.1"→§6.1/§6.2、"3、埋点上报设置"→6.1.3）、CSV 与第五节示例表对齐 9 列双口径（删"事件名称"列+补"公共字段"列）、"反模式 25"悬空引用 ×3、DoD"9 项"→10 项、文件清单补 tests/、切片口径统一、产物内相对路径加防留提醒 ×2、去除对外部 CLAUDE.md 偏好的依赖；③ 同日完成：**§4.x 节序重排**（§4.1/§4.2 互换为正序并标注"Stage 2 附属规范 A/B"消除阶段流打断）+ **装载版对比实测**（隔离运行+独立评委：装载版 29/30 vs 裸基线 11/30，分差 18 显著优于，Pareto 无单点崩坏，记录入 tests/baseline-record.md）；下一轮入口：stories/ 派生产物契约测试、7 节填充示例
- **2026-06-12 · v2.4.2** — 第二轮评审修复(外围资产与主契约对齐):① Stage 0 wiki 根改探测式(`docs/wiki/` → `docs/pm/wiki/` 顺序,MaaS 命中后者);② 输出位置改「沿用项目既有 PRD 目录」(MaaS: `docs/pm/prd/`),默认 `02_PRD/` 仅限无既有结构的新项目;③ prd-template §7.4 切片链接 for-coding.md → stories/(清死链);④ 埋点口径统一双轨:全本 5 列 → BI 9 列显式转换(事件描述/页面路径/页面名称/告警阈值为 BI 扩展列),tracking-events-spec 旧「8 列」废弃;⑤ overview 模板正文 PRD 链接去硬编码(引 frontmatter `prd_source`)
- **2026-06-12 · v2.4.1** — 研发侧 NOT-READY 评审 7 条驱动的契约修订：模板路径去硬编码（以 story 文件位置为基准 + lint 强校验可解析 + `prototype_url` 跨仓稳定入口）；状态机拆双权属（spec 状态 draft/ai-passed/ready 归 PM 仓 · 交付状态 pending/in-dev/done 归研发仓 delivery-status.md，重派生不覆盖签收）；lite 模板补 title/spec_test 并限 ≤30 行；`spec_test: passed` 语义 = 分级关卡全过；**self-consistency 纪律：模板与样例必须能过自己的门禁**
- **2026-06-11 · v2.4** — **编码切片升级为 stories/ 目录（按 story 拆分 · 源自 MaaS 项目研发分工讨论 + 2026-06 行业 SDD 调研）**
  - **for-coding.md 单文件 → stories/ 目录**：`00-overview.md`（版本目标 + story 索引 + 公共约定）+ 按 story 拆分的 `ST-XXXX` 卡片（≤100 行，AC 全 Given-When-Then，「不做」边界必填）；研发 AI 每次只喂 overview + 单个 story，上下文最小化
  - **粒度弹性**：新增 `story-template-lite.md`，小改动不强拆（吸收 Martin Fowler 对 SDD 粒度错配的批评）
  - **与 prd-reviewer 衔接**：story 默认 draft，过分级关卡（标准=三关，lite=两关）`spec_test: passed` → ai-passed，研发 48h 走查过 → ready；spec 状态（PM 仓）与交付状态（研发仓 delivery-status.md）分仓分权属
  - **新增文件**：`templates/story-overview-template.md` + `templates/story-template.md` + `templates/story-template-lite.md`；`prd-template-coding-slice.md` 转 legacy
  - **行业对标**：story 卡片 ≈ AWS Kiro requirements.md（user story + EARS）；overview ≈ Kiro steering + Spec Kit Constitution；干跑自测 ≈ Anthropic "spec 合格 = AI 能直接建出来"
  - 完整方案见 MaaS 仓 `docs/pm/specs/2026-06-11-story-spec-workflow.md`
- **2026-05-21 · v2.3** — **重大重构：13 节 → 7 节 + 角色切片机制**
  - **结构压缩**：原 13 节合并为 7 节（Summary / Problem & Goals / Scope / Design / Rollout & Risks / Quality / Appendix），中英双标章节名；治理元信息（修订记录 / 评审记录 / 参考链接）移到 frontmatter；总行数 ~548 → ~314（-43%）
  - **新增角色切片机制**：每份 PRD 默认派生 4 个切片（`for-coding` / `for-qa` / `for-bi` / `for-ops`），AI 编码 agent 只读 `for-coding.md`（约 150 行 · 仅业务核心），解决"一份 PRD 撑 6 个消费者互相污染"问题
  - **DoD 分层**：原 11 项"必填"重排为「核心必填 9 项 / 场景必填 5 项 / 推荐填写 4 项 / 永远不写 2 项」
  - **反模式反转**：删除"保留 N/A 章节"反模式，改为"不适用就删除"（N/A 会污染 AI 编码切片）；删除"13 节太多合并"严禁约束，改为"7 节是最小集 + 切片解决冗余"
  - **Self-Evolving Protocol 加反向问题**：30 秒自检清单加 3 条「简化驱动」问题（哪些章节应删 / 哪些 DoD 应降级 / 哪些反模式过时），防止模板单调膨胀
  - **社区参考**：借鉴 Amazon Working Backwards / Basecamp Shape Up / Google Design Doc / Linear spec / Atlassian Poster
  - **新增文件**：`templates/prd-template-coding-slice.md` + `references/slice-generation.md`
  - **保留**：Stage 0 / 0.5 工作流 + page-design-template + eval-set-requirements + ai-product-checklist + tracking-events-spec 等所有 references 不变
- **2026-05-20 · v2.2** — 工作流升级为 4 阶段：① 新增 Stage 0.5 从高保真原型反推 PRD（13 行反推映射表 + 4 步流程 + 5 条反模式） ② Self-Evolving Protocol 增加「写完 PRD 后：建议 ingest 到项目 wiki」环节 ③ 完成标准加 Stage 0.5 检查
- **2026-05-19 · v2.1** — 与 `pm-wiki-maintainer` skill 集成（Tier 1）：新增 Stage 0 读项目 wiki + 完成标准加 Stage 0 检查 + 反模式新增"项目有 wiki 但跳过 Stage 0" + 沉淀回填
- **2026-05-18 · v2.0** — 企业 SaaS 项目 v0.1 PRD rev2 用户反馈蒸馏（6 条普适改进）：新增反模式 5 条 + 第六节增强为 6.1 业务对象 + 6.2 页面 7 段 + 6.3 AI 模块特化 + Stage 3 AI 触发条件精化 + 完成标准加 5 项 + 新增 page-design-template
- **2026-05-15** 初始版本（V0.5 → 模板 + 反模式 + rationalization 自查 + Self-Evolving Protocol + 跨平台支持）
