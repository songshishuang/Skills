# Ingest 工作流：摄入新源到 Wiki

> Karpathy 原文：「the LLM doesn't just index it for later retrieval. It reads it, extracts the key information, and integrates it into the existing wiki — updating entity pages, revising topic summaries, noting where new data contradicts old claims, strengthening or challenging the evolving synthesis.」

## 触发场景

用户说：
- 「**把这份 X 存进 wiki**」「ingest 这份 PRD」「沉淀这次客户访谈」「归档 ADR-012 进知识库」
- 提供新源（粘贴文件路径 / drag-drop / 粘贴 URL）+ 暗示要进 wiki

## 流程档位（v1.3+ 新增 · 按源大小分轻重）

> 旧版「8 步必走」对会议纪要 / Slack 截图等小源过重。v1.3 分两档：

| 档位 | 适用源 | 步骤数 | 总耗时 |
|---|---|---|---|
| 🟢 **轻 ingest** | 会议纪要 / Slack 截图 / 短客户反馈（≤ 1 屏 / ≤ 200 字） | **3 步** | 2-3 分钟 |
| 🟡 **完整 ingest** | PRD / 研究报告 / 完整 ADR / 长用研纪要（≥ 1 屏 / ≥ 500 字） | **8 步** | 10-20 分钟 |

> **默认档位**：用户指明源时，AI 按源类型对照表（文末）查表自动选择档位。
> **降级例外**：用户明确说"快速 ingest" / "随便存一下" → 强制走轻 ingest；用户说"细致 ingest" / "完整归档" → 强制走完整 ingest。

### 🟢 轻 ingest（3 步 · 小源）

适合短源 —— 不值得建独立 summary 页，散布到现有 wiki 页即可。

1. **读源 + 快确认**：Read 源 + 一句话跟用户确认核心信息（「这次纪要核心是 X，对吗？」），不做深度讨论
2. **散布 + 追加 log**：把信息**散布**到 1-2 个现有 concept/entity/decision 页 + 追加 `log.md` 一条
3. **简短报告**：「✅ 已散布到 N 页：A / B。`log.md` +1。如要建独立 topic 页告诉我」

> **何时升级到完整 ingest**：发现源内含新决策（应进 decisions/）或新概念（值得独立 page）→ 中断轻 ingest，跟用户确认后升档。

### 🟡 完整 ingest（8 步 · 大源）

## 8 步流程

### 1️⃣ 读源
- **Read** 用户指定的源文件（如 `docs/prd/V0.7-需求.md`）
- 如果是 URL：用 `WebFetch` 抓取
- 如果是大文件（> 500 行）：先扫目录 / 段落标题，再按需读细节

### 2️⃣ 讨论关键点（**不要默默处理**）
跟用户**对话提炼**：
- "这份源的核心信息是 A / B / C / D，其中哪些是项目新增？哪些是修订旧观点？"
- "里面提到 X 实体（如 客户 / 竞品 / 模型）—— 我们 wiki 已经有 X 页吗？要不要新建？"

⚠️ **禁忌**：用户给个文件路径就开始写 wiki —— 必须先讨论再动笔。

### 3️⃣ 决定影响面（要触达哪些 wiki 页）
扫 wiki `index.md`，列出本次 ingest **可能要改动**的页面：

- 新建：summary 页（必有）
- 可能新建：1-3 个新 concept / entity / topic
- 可能更新：N 个已有 concept / entity / decision / topic
- 可能新增 cross-reference：M 对页面

**报告给用户**：「本次 ingest 预计触达 X-Y 页：[列表]。继续？」

### 4️⃣ 写 summary 页（如有）
某些源（如新 PRD / 完整研究报告）值得**独立 summary 页**：
- 位置：取决于源类型（PRD → `topics/产品-V0.X.md` / 研究 → `topics/<研究主题>.md`）
- 内容：1 句话定位 + 核心 takeaways（3-7 点）+ 链接回 raw source 路径

某些源（如短会议纪要 / Slack 截图）**不需要独立 page**——直接把信息**散布**到现有 concept/entity/decision 页。

### 5️⃣ 更新相关 wiki 页（核心动作）
按"原文 → wiki 段落"的映射，**精确改动**多页：

| 原文片段 | wiki 触达 |
|---|---|
| 新决策（"V0.7 主模型切 deepseek"）| → `decisions/llm-model.md` 加新条目 + 标 ADR-001 为过时 |
| 提到客户 X | → `entities/customers/X.md` 添加"V0.7 试点信息" |
| 出现新概念 Y（无独立页）| → 决定要不要建 `concepts/Y.md`（标准：是否会被未来 ≥2 个源引用？）|
| 与现有 wiki 内容矛盾 | → 在相关页加 ⚠️ 标记 + 注明来源 + 询问用户怎么解决 |

**每改一处都加 frontmatter `updated: YYYY-MM-DD` + `sources: [...]` 追加来源**。

### 6️⃣ 更新 `index.md`
- 新建的 page → 加到对应 category 段
- 旧 page 的 1-line summary 如果不准确了 → 修订

### 7️⃣ 追加 `log.md`
**强制 append-only**，单条格式：
```markdown
## [2026-05-18] ingest | <源标题>
- 触达 N 页：A / B / C
- 重要发现：⚠️ X 与 wiki 现有 Y 矛盾 / ✨ 新概念 Z（已建独立页）
- raw source: `docs/prd/V0.7-需求.md`
```

### 8️⃣ 报告完成
给用户一个简明 summary：
```
✅ Ingest 完成：V0.7 需求.md

变更摘要（共触达 8 页）：
- 新建 1 页：topics/V0.7-客服 AI.md
- 更新 5 页：decisions/llm-model.md / decisions/gradual-rollout.md / 
            entities/customers/A.md / concepts/ai-fallback.md / index.md
- 追加 log.md
- ⚠️ 1 处矛盾待你确认：concepts/ai-fallback.md 旧值 0.6 vs 新 PRD 0.7 → 默认采纳新值，已加注。
```

## 源类型对照表

不同源类型 → 不同 ingest 策略：

| 源类型 | 触达页数 | 主要影响 | 是否建独立 summary | **档位**（v1.3 新增） |
|---|---|---|---|---|
| 完整 PRD（新版本）| 10-20 | 大量 entity/concept/decision/topic | ✅ 必建 topic 页 | 🟡 完整 ingest |
| ADR（架构决策）| 3-5 | decisions/ + 1-2 相关 concept | ✅ 必更新 decisions 综合页 | 🟡 完整 ingest |
| 用户访谈纪要 | 2-5 | entities/customers + concepts + glossary | 🟡 视长度，长的建独立页 | 🟢 轻（短） / 🟡 完整（长） |
| 竞品分析 | 5-10 | entities/competitors + concepts | ✅ 建独立 competitor 页 | 🟡 完整 ingest |
| 会议纪要 | 1-3 | 散布到现有页 | ❌ 一般不建独立页 | 🟢 轻 ingest |
| Slack 讨论截图 | 1-2 | 散布 + 提示用户去落 ADR | ❌ | 🟢 轻 ingest |
| 行业研究报告 | 8-15 | 大量新 concept/entity | ✅ 必建 topic 页 | 🟡 完整 ingest |
| 客户邮件 / 短反馈 | 1-2 | 散布到 entities/customers | ❌ | 🟢 轻 ingest |

## 从 prd-writer / saas-arch-diagrams 产出物 ingest 的范式

PRD 和架构图是 PM 的两类"正式产出"。它们的原文留在标准目录（`docs/prd/`、`docs/product-planning/`），**只提炼后入 wiki**。具体策略：

### 从 PRD ingest（约 6-10 页 wiki 改动 · 基于 prd-writer v2.3 7 节结构）

| PRD 节 | 提炼到 wiki 的什么 | 目标页 |
|---|---|---|
| §2.3 北极星 + KR | 项目目标演进史 | `topics/目标-演进.md`（每个 PRD 版本一条记录） |
| §2.2 用户角色 | 新增角色 / 既有角色画像更新 | `entities/users/<role>.md` |
| §3.1 需求范围 | 新增功能模块 | `concepts/<模块>.md` |
| §4.3 AI 模块特化 | 模型选型 / 提示词版本 / 工具调用维度 | `concepts/ai-module-spec.md`（综合页） |
| §5.5 成本预算 | token 单价 + 月度预算演进 | `topics/成本-演进.md` |
| §7.2 ADR | **每条 ADR 一页**，标 active / superseded | `decisions/ADR-NNN-<决策>.md` |

**不进 wiki 的内容**：frontmatter 治理元信息（revision_log / review_log）、§4.2 具体字段表 / 页面 7 段细节、§6.1 完整埋点表、§6.3 验收清单 —— 这些是版本快照，留在 PRD 原文。

> ⚠️ **节号兼容**：上表基于 prd-writer **v2.3+ 7 节结构**。如遇旧版 PRD（13 节结构 v2.2-），映射关系为：§13.4→§7.2 / §4→§2.2 / §5→§3.1 / §6.3→§4.3 / §3.3→§2.3 / §10.4→§5.5。

### 从架构图 ingest（约 3-5 页 wiki 改动）

| 架构图变更 | 提炼到 wiki 的什么 | 目标页 |
|---|---|---|
| 新增能力域 | 能力域定义 + 涵盖范围 | `concepts/<能力域>.md` |
| 模块边界调整 | 哪些模块拆分 / 合并 / 移交下游 | `decisions/ADR-NNN-<重构>.md` |
| 新增下游平台 | 下游平台职责 / 协同接口 | `entities/platforms/<下游>.md` |
| 4 层结构变化 | 角色层 / 产品层 / 能力层 / 底座层的边界变化 | `topics/架构-演进.md` |

### 触发方式

- **prd-writer 完成 PRD** → Self-Evolving 自检时建议：「本轮 PRD 含 N 条新 ADR / M 个新概念，建议执行 `ingest PRD 到 wiki`」
- **saas-arch-diagrams 完成架构图** → Self-Evolving 自检时建议：「本轮架构图引入 X 能力域 / Y 边界变化，建议执行 `ingest 架构图到 wiki`」
- **用户接受建议** → 调用本 skill 的 ingest 流程，AI 按上述映射表自动 touch 对应 wiki 页

## 反模式

- ❌ **默默写完整 wiki 不问用户** —— Karpathy 强调"the LLM agent on one side and Obsidian on the other"，**协作而非自动化**
- ❌ **每次 ingest 都建新页** —— 多数源应该**改动已有页**而非新建；建页门槛是「未来 ≥ 2 个源会引用」
- ❌ **不 log** —— log.md 是 wiki 的演进历史，跳过 log = 失去 audit trail
- ❌ **复制原文到 wiki** —— wiki 是 **synthesis**，不是复制粘贴；如要原文请引用 raw source 路径
- ❌ **不处理矛盾** —— 新源与旧 wiki 矛盾时，**主动标 ⚠️ 并问用户**，不要默认覆盖

## 与 conversation-logging skill 的区别

- **conversation-logging-and-insight-extraction**：归档**对话过程**（流水账 + 业务洞察）到 `Logs/YYYY-MM/YYYY-MM-DD.md`
- **pm-wiki-maintainer ingest**：把**业务源**（PRD / 研究 / ADR / 访谈）的 synthesis 入 wiki

两者互补：
- `Logs/` 是会话过程档案（事件流）
- `docs/wiki/` 是知识沉淀（按主题组织）

如果一段对话产出了重要业务结论 → **可以**先归档到 `Logs/` 再 ingest 到 wiki（双轨制）。
