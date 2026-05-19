---
name: pm-wiki-maintainer
description: 维护 PM 项目的 LLM Wiki —— 增量构建持久化知识库（不是临时 RAG），自动摄入源文档、查询历史决策、体检矛盾与过期。当用户提到「ingest 进 wiki」「归档进知识库」「沉淀进 wiki」「整理项目沉淀」「lint wiki」「wiki 体检」「找历史决策」「这个项目的 X 是什么」「项目演进史」「跨 PRD 的 Y」「为新人生成入门索引」时使用。基于 Andrej Karpathy LLM Wiki 模式（raw sources + wiki + schema 三层架构）。适用于单项目 PM 知识沉淀（PRD / 用户研究 / 竞品分析 / 决策 / 客户反馈跨文档关联与综合视图）。
---

# PM Wiki Maintainer

## Overview

按 [Karpathy LLM Wiki 模式](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 维护 PM 项目的知识沉淀。

**核心区别于 RAG**：
- ❌ RAG：每次 query 从 raw documents 临时检索，无积累，"the LLM is rediscovering knowledge from scratch on every question"
- ✅ LLM Wiki：增量构建**持久化、可累积、自动维护**的中间层。每次 ingest 触达 10-15 个相关页面，cross-reference / contradiction / synthesis 已写好

**核心洞察**："The wiki is a persistent, compounding artifact." —— wiki 越用越富，不是越用越乱。

## 三层架构（映射 PM 项目）

| 层 | 谁拥有 | 在 PM 项目里对应 |
|---|---|---|
| **Raw Sources** | 你 —— 只读 | `docs/prd/` · `docs/user-research/` · `docs/market-research/` · `docs/competitor-analysis/` · `docs/decisions/`（原始 ADR）· `Logs/`（对话归档）· 客户访谈纪要 · 会议纪要 |
| **Wiki** | LLM 全权维护 | `docs/wiki/`（自动维护的 markdown 网） |
| **Schema** | 你 + LLM 共演化 | 本 SKILL.md + 项目内 `docs/wiki/CLAUDE.md` |

## 触发场景

### 🟢 Ingest 摄入（写入 wiki）

新源进来时：
- 「**把这份会议纪要存进 wiki**」「ingest 这份客户访谈」
- 「**归档 V0.7 PRD 进知识库**」
- 「这篇竞品分析归到 wiki」「沉淀 ADR-012 到 wiki」

### 🟡 Query 查询（读 wiki）

需要历史信息时：
- 「**项目里 X 是什么**」「V0.5 我们的 fallback 是什么」
- 「**找 Y 的所有讨论**」「列出所有跟"灰度策略"相关的决策」
- 「**为新人生成项目入门索引**」「这个产品的核心概念」

### 🔴 Lint 体检（健康度检查）

定期或人为触发：
- 「**整理项目沉淀**」「lint wiki」「wiki 体检」
- 「**找过期决策**」「找矛盾」「找 orphan 页面」
- 「**下一步该读什么源**」「wiki 哪里薄弱」

## 不要触发本 skill 的场景

- ❌ 用户只是闲聊问问题（不涉及项目历史）→ 直接回答
- ❌ 写新 PRD → 用 `prd-writer` skill
- ❌ 建项目目录 → 用 `pm-project-scaffolding` skill
- ❌ 归档对话 → 用 `conversation-logging-and-insight-extraction` skill

## 标准 Wiki 目录约定（单项目）

```
docs/wiki/
├── index.md           ← 内容导向 catalog（每页 1 行 summary · 按 category 分组 · 必有）
├── log.md             ← 时间导向 append-only（## [YYYY-MM-DD] action | title · 可 grep · 必有）
├── CLAUDE.md          ← 投放到本目录的工作规则（让任何 AI 看到目录就按 Karpathy 模式工作）
│
├── concepts/          ← 概念页（产品概念、技术概念、方法论概念）
│   ├── ai-fallback.md
│   ├── gradual-rollout.md
│   └── ...
│
├── entities/          ← 实体页（项目相关的"对象"）
│   ├── customers/{客户A}.md
│   ├── competitors/{对手1}.md
│   ├── products/{产品线}.md
│   └── roles/{角色}.md
│
├── decisions/         ← LLM 综合视图（方案 ii：跨 ADR 关联 + 过时标记）
│   ├── _index.md     ← 决策按主题分类汇总
│   └── {topic}.md    ← 各主题决策综合（如 llm-model.md 汇总所有跟 LLM 选型相关的 ADR）
│
├── topics/            ← 跨多文档的主题页
│   └── {主题}.md      ← 如「支付灰度策略.md」汇总多个 PRD 的相关章节
│
└── glossary.md        ← 名词表（自动从 ingest 提取专有名词）
```

详细页面格式与 frontmatter 约定见 [`references/wiki-structure.md`](./references/wiki-structure.md)。

## 三类操作的工作流

### Ingest 摄入（8 步）

完整工作流见 [`references/ingest-workflow.md`](./references/ingest-workflow.md)。**核心流程**：

1. **读源** —— Read 用户指定的源文件
2. **讨论关键点** —— 跟用户对话提炼核心信息（**不要默默处理**）
3. **写 summary 页** —— 在 wiki 适当位置创建/更新该源的 summary
4. **更新 index.md** —— 添加新 summary 到 catalog
5. **追加 log.md** —— `## [YYYY-MM-DD] ingest | <源标题>` + 1 行摘要
6. **更新相关 entity/concept/topic 页** —— 触达可能 10-15 个相关页面
7. **报告** —— 告诉用户「本次 ingest 触达 N 页：A / B / C」让用户验证
8. **不要默默修改** —— 重大新增 / 矛盾 / 删除前先问

### Query 查询

详见 [`references/query-workflow.md`](./references/query-workflow.md)。**核心 4 步**：

1. **先读 `index.md`** —— 看 wiki 整体结构，找候选页面 slug
2. **drill 进相关页面** —— Read 候选页详细内容
3. **综合回答** —— 附 citation（`docs/wiki/topics/X.md:L42` 格式）
4. **回填规则** —— 好答案（如跨页 comparison / 新发现 connection / 用户拍板的判断）**应回填进 wiki 成新 topic 页 / 追加进现有 page**，不让 explorations 消失在对话里

**集成场景**：被 `prd-writer` 的 Stage 0 调用时（写新 PRD 前读 wiki）—— 提供"项目历史决策 / 概念 / 主题"的先验上下文。

### Lint 体检

详见 [`references/lint-workflow.md`](./references/lint-workflow.md)。**6 类检查**：
1. **Contradictions** —— 跨页面声明矛盾
2. **Stale claims** —— 旧页面声明被新源 superseded
3. **Orphan pages** —— 无 inbound link 的页面
4. **Missing concepts** —— 多次提到但无独立页的概念
5. **Missing cross-references** —— 应该相互引用但没引用的页面对
6. **Data gaps** —— 提议下一步该查的源 / web search

## 方案 ii 关键设计：Decisions 独立综合视图

你已有 `docs/decisions/`（原始 ADR）—— **raw source，不可改**。
本 skill 在 `docs/wiki/decisions/` 维护 **LLM 综合视图**：

| `docs/decisions/`（raw） | `docs/wiki/decisions/`（LLM 维护） |
|---|---|
| 原始 ADR 文件（不可改） | LLM 综合视图（可演化） |
| 单条记录 · 按时间 | 跨 ADR 关联 · 按主题分组 |
| 静态 | 动态：新 ADR 进来时自动更新关联，老 ADR 被替代时标记 `[过时]` |

**示例**：
- 原始：ADR-001（选 gpt-4o-mini）+ ADR-007（fallback 到 qwen-7b）+ ADR-012（V0.7 改主模型为 deepseek-v3）
- Wiki 综合视图 `docs/wiki/decisions/llm-model.md`：
  ```
  # LLM 模型选择决策演进
  
  ## 当前生效
  - 主模型：deepseek-v3（ADR-012，2026-05）
  - Fallback：qwen-7b（ADR-007，沿用）
  
  ## 决策时间线
  - 2026-03 ADR-001 — 选 gpt-4o-mini ⚠️ 被 ADR-012 替代
  - 2026-03 ADR-007 — fallback qwen-7b ✅ 仍生效
  - 2026-05 ADR-012 — 主模型改 deepseek-v3 ✅ 当前
  
  ## 关键考量
  - 中文能力 + 调用稳定性 + 价格三角衡量
  - V0.7 切 deepseek 的原因：A/B 测试采纳率 +8%
  
  ## 关联 wiki
  - 见 [concepts/ai-fallback.md](../concepts/ai-fallback.md)
  - 见 [topics/支付灰度策略.md](../topics/支付灰度策略.md)
  ```

实施细节内嵌本 SKILL.md（不单独抽 reference，避免过度文档化）。

## 与其他 Skill 的协作沉淀矩阵

PM Copilot Kit 4 个 skill 协同工作时，**wiki 是项目知识的中心枢纽**。各 skill 职责分工如下：

### 沉淀边界（什么进 wiki / 什么不进）

```
┌──────────────────────────────────────────────────┐
│  原始产出物（留在标准目录，wiki 不重复）              │
│   ├── docs/prd/V0.x/PRD-V0.x.md       ← prd-writer 产出 │
│   ├── docs/product-planning/产品架构图.md  ← saas-arch-diagrams 产出 │
│   ├── docs/product-planning/功能架构图.md  ← saas-arch-diagrams 产出 │
│   ├── docs/user-research/访谈纪要.md      ← PM 手工产出 │
│   └── prototypes/                         ← 高保真原型 │
└─────────────────┬────────────────────────────────┘
                  │  ingest（提炼综合，不复制原文）
                  ↓
┌──────────────────────────────────────────────────┐
│   docs/wiki/  ── 提炼后的、综合的、跨版本可复用知识     │
│    ├── decisions/ADR-XXX.md   从 PRD §13.4 抽出关键决策 │
│    ├── concepts/<概念>.md      跨 PRD 反复出现的概念    │
│    ├── entities/<实体>.md      产品角色 / 竞品 / 模型 / 客户 │
│    └── topics/<主题>.md        综合视图（如商业化假设）  │
└──────────────────────────────────────────────────┘
```

### 各 Skill 与 Wiki 的协作触发矩阵

| 来源 Skill | 触发时机 | 沉淀到 wiki 的内容 | 触发方式 |
|---|---|---|---|
| `pm-project-scaffolding` | 立项当天 | `docs/wiki/` 骨架 + INDEX/LOG/CLAUDE.md 模板 | **一次性自动** |
| `prd-writer` | PRD 评审通过后 | §13.4 ADR 中的关键决策 / §4 新增用户角色 / §5 新功能模块概念 / §6.3 AI 模块新维度 | **prd-writer Self-Evolving 时建议 → 用户触发 ingest** |
| `saas-arch-diagrams` | 架构图定稿后 | 新引入的能力域 / 模块边界变更 / 与下游平台的关系变化 | **saas-arch-diagrams Self-Evolving 时建议 → 用户触发 ingest** |
| 用户手动 | 会议 / 用研 / 客户反馈 / 竞品调研 | 原文进 `raw/`，提炼综合进 wiki | **用户主动调用 ingest 命令** |

### 三条核心原则

1. **原文不重复**：PRD、架构图原文留在标准目录（`docs/prd/`、`docs/product-planning/`），wiki 只存提炼后的 ADR / concept / entity / topic 综合页
2. **wiki 是综合层**：跨版本可复用、需要持续演化的内容才进 wiki；单版本快照（V0.5 vs V0.6 哪个字段长度变了）留在 PRD 原文里
3. **协作触发不强制**：其他 skill 完成工作后只**建议**用户 ingest，最终入 wiki 的内容由用户决策 —— wiki 不是自动归档器，是 PM 主动维护的项目大脑

### 完整流程（新项目示例）

```
Day 0   pm-project-scaffolding     建项目目录（含 docs/wiki/ 空骨架）
Week 1  saas-arch-diagrams         画产品架构图 → 完成后建议 ingest「能力层 / 下游平台关系」
Week 2  prd-writer                 写 V0.5 PRD（Stage 0 自动从 wiki query 历史决策）
                                   → 完成后建议 ingest「§13.4 ADR / §4 新角色」
Week 3+ pm-wiki-maintainer         用户按建议 ingest，wiki 增长 8-10 页
        周期性                      lint 体检（每月 / 每 PRD 发版前）
V0.6 时  prd-writer Stage 0         自动加载 V0.5 ADR + 概念页 → 新 PRD 站在 V0.5 决策之上
```

## Self-Evolving Protocol

本 skill 是 **living document**。Karpathy 文中说："Schema 是你和 LLM 共同演化的"——每次用新场景，可能要更新本 SKILL.md。

### 触发评估时机

| 触发时机 | 评估问题 | 归档路径 |
|---|---|---|
| Ingest 完成 N 次后发现某类源没合适页面归位 | 是不是要新增 entity/concept/topic 子分类？ | `references/wiki-structure.md` |
| Lint 发现的 contradiction 模式高频出现 | 是不是要进 anti-patterns 表？ | 新增 `references/anti-patterns.md` |
| Query 同样问题被问 3+ 次 | 是不是要写一份固化 topic 页？ | 主动建议建 `topics/<主题>.md` |
| 发现新的源类型（如 Slack 截图、客户邮件） | ingest workflow 是不是要补这类源的处理？ | `references/ingest-workflow.md` |
| schema 与实际工作流偏差 | 本 SKILL.md 是不是要更新约定？ | 本文件 |

### 更新约束

- ❌ 不要默默更新 skill —— 告知用户「本轮新增 N 条 X」
- ❌ 不要把项目特定字段当通用规则 —— 跨 ≥2 项目验证过才进 references
- ✅ 更新必加 Changelog 行（日期 + 改动摘要 + 来源项目）

## 🌐 跨平台支持

| 平台 | Wiki 维护能力 |
|---|---|
| Claude Code / Desktop | 🟢 全自动（AI 主动 ingest / 触达多页 / Self-Evolving） |
| Cursor / Codex / Gemini | 🟡 半自动（用户手动提示「按 Karpathy 模式 ingest 这份源」） |
| ChatGPT Web | 🔴 仅能"建议"（无法直接改宿主文件，需用户手动落盘） |

详见仓库根 [INSTALL-MULTI-PLATFORM.md](https://github.com/songshishuang/Skills/blob/main/INSTALL-MULTI-PLATFORM.md)。

## Bottom Line

**好的 wiki = 你只负责 sourcing、exploration、asking the right questions；LLM 负责 summarizing、cross-referencing、filing、bookkeeping。**

用 Karpathy 的话："Obsidian 是 IDE，LLM 是 programmer，wiki 是 codebase。"
用 PM 的话："`docs/` 是 raw sources，`docs/wiki/` 是经过 LLM 反复推敲的项目记忆。"

## Changelog

- **2026-05-20 · v1.2** — 新增「与其他 Skill 的协作沉淀矩阵」：明确 prd-writer / saas-arch-diagrams 产出物如何沉淀到 wiki（原文留标准目录，wiki 只存提炼综合页）；`ingest-workflow.md` 增加「从 PRD / 架构图 ingest 的范式」章节（6 行 PRD 映射表 + 4 行架构图映射表）（自比赛包回流）
- **2026-05-19 · v1.1** — 与 `prd-writer` skill 集成（Tier 1）
  - 写完整 `references/query-workflow.md`（4 步流程 + 回填规则 + 与 prd-writer Stage 0 集成）
  - 主 SKILL.md Query 段完善（明示集成场景）
  - 与 prd-writer Stage 0 协作：prd-writer 启动时主动读 wiki 作为先验上下文，写完 PRD 建议 ingest 回填

- **2026-05-18 · v1.0** 初始版本（基于 [Karpathy LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 设计）
  - 三层架构（raw / wiki / schema）+ 三类操作（ingest / query / lint）
  - 方案 ii：decisions 独立综合视图（跨 ADR 关联 + 过时标记）
  - 单项目模式（每个项目自己一个 docs/wiki/）
  - 与 pm-project-scaffolding 协作约定
