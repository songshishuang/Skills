# Wiki 目录结构与页面格式约定

## 顶层目录

```
docs/wiki/
├── index.md                  # 内容导向 catalog（必有）
├── log.md                    # 时间导向 append-only（必有）
├── CLAUDE.md                 # 工作规则（让 AI 看到目录就按 Karpathy 模式工作）
├── concepts/                 # 概念页（产品概念 / 技术概念 / 方法论概念）
├── entities/                 # 实体页（对象、产品、客户、竞品、角色）
├── decisions/                # LLM 综合视图（与 docs/decisions/ 不同！）
├── topics/                   # 跨多源的主题汇总页
└── glossary.md               # 名词表
```

## 各类页面的内容模式

### concepts/<concept-name>.md — 概念页

**何时建？** 某个概念在 ≥2 个源里被提到，且**项目里需要统一定义**。

**格式**：
```markdown
---
type: concept
created: 2026-05-18
sources: [PRD-V0.5, user-interview-3, ADR-007]
related: [ai-fallback, gradual-rollout]
---

# AI 兜底策略

## 一句话定义
当主模型超时 / 低置信 / 错误时，自动切到备用模型或预置回复，保证用户体验不挂。

## 在本项目里如何应用
- 主模型：deepseek-v3（生效中）
- 触发条件：超时 > 3s · 置信度 < 0.6 · 5xx 错误
- 备用：qwen-7b（沿用 ADR-007）
- 终极兜底：预置话术 + 转人工

## 来源 / 演进
- PRD-V0.5 §4.3 首次定义（示意 · 实际节号见 prd-writer 当前版本）→ ADR-007 选 qwen-7b → ADR-012 主模型切 deepseek

## 相关
- [decisions/llm-model.md](../decisions/llm-model.md)
- [topics/客服 AI 自托管.md](../topics/客服-AI-自托管.md)
```

### entities/<category>/<name>.md — 实体页

**何时建？** 项目里反复提到的"具象对象"——客户、竞品、产品线、模型、角色等。

**子分类约定**：
- `entities/customers/` — 客户
- `entities/competitors/` — 竞品
- `entities/products/` — 自家产品线
- `entities/vendors/` — 供应商 / 模型供应商
- `entities/roles/` — 业务角色
- `entities/people/` — 团队成员（**注意：必须脱敏！**只记角色/职责，不写真名）

**格式**：
```markdown
---
type: entity
category: competitor
created: 2026-05-18
sources: [competitor-analysis-2026-Q2, market-research-客服]
---

# 某竞品 X

## 一句话定位
做 SCRM + AI 客服一体化，强项是企微生态深度集成。

## 关键能力
- 加微策略执行
- 流失预警（情绪雷达）

## 我们 vs 他们
| 维度 | 我们 | X |
|---|---|---|
| AI 自托管 | ✅ | ⚠️ 基础 |
| 评测体系 | ✅ Golden 集 | ❌ |

## 来源
- [docs/competitor-analysis/2026-Q2.md](../../competitor-analysis/2026-Q2.md)
```

### decisions/<topic>.md — 决策综合视图（方案 ii）

**何时建？** 同一主题有 ≥2 个 ADR，需要看演进史时。

**格式**：见 SKILL.md 「方案 ii 关键设计」中的 llm-model.md 示例。

**关键约束**：
- ❌ 不复制 ADR 原文（raw source 不可改，wiki 只综合）
- ✅ 引用 ADR 编号 + 日期 + 状态（✅ 生效 / ⚠️ 部分替代 / ❌ 已过时）
- ✅ 标注**为什么这么决策**（关键考量、A/B 数据、人证）

### topics/<主题>.md — 跨源主题汇总

**何时建？** 一个业务主题（如"支付灰度策略"）分散在多个 PRD / 决策 / 用户访谈里。

**格式**：
```markdown
---
type: topic
created: 2026-05-18
sources: [PRD-V0.5, PRD-V0.7, user-interview-3, ADR-009]
---

# 支付灰度策略

## 现状（截至 2026-05）
新 V0.7 上线，灰度策略：用户分群 + 渠道 + 设备三维

## 演进史
| 版本 | 灰度方式 | 来源 |
|---|---|---|
| V0.5 | 用户分群（10%）| PRD-V0.5 §5.1（示意 · 实际节号见 prd-writer 当前版本）|
| V0.7 | 加渠道 + 设备维 | PRD-V0.7 §5.1 |

## 关键决策
- ADR-009 选 LaunchDarkly 不选自研 → see [decisions/feature-flag-platform.md](../decisions/feature-flag-platform.md)

## 用户反馈
- user-interview-3 用户抱怨"灰度切流后 Bug 找不到归属" → 解决：trace_id 标记灰度桶
```

### glossary.md — 名词表

**自动从 ingest 提取**（行业术语 / 内部代号 / 缩写）。

**格式**：
```markdown
# 名词表

## A
- **ADR** (Architecture Decision Record) — 架构决策记录，原始版在 `docs/decisions/`

## B
- **Brand badge** — 品牌徽章组件

## ...
```

## 关键文件：index.md 格式

**index.md 是 Karpathy 模式的"内容导向 catalog"**——LLM 在 query 时**先读 index 找候选页**再 drill 进去。

```markdown
# Wiki Index

> 本 wiki 由 pm-wiki-maintainer skill 维护。
> 最后更新：2026-05-18
> 总页数：23

## 概念（concepts/）
- [AI 兜底策略](./concepts/ai-fallback.md) — 主模型挂时的自动切换 + 预置话术
- [灰度切流](./concepts/gradual-rollout.md) — 按用户/渠道/设备三维分流
- ...

## 实体（entities/）
### 客户
- [客户 A](./entities/customers/A.md) — 某电商，2026 Q1 接入
### 竞品
- [某竞品 X](./entities/competitors/X.md) — SCRM + AI 客服一体化

## 决策（decisions/）
- [LLM 模型选择演进](./decisions/llm-model.md) — 跨 ADR-001/007/012
- [灰度平台选型](./decisions/feature-flag-platform.md) — ADR-009

## 主题（topics/）
- [支付灰度策略](./topics/支付灰度策略.md) — 跨 V0.5/V0.7 PRD

## 名词表
- [glossary.md](./glossary.md)
```

## 关键文件：log.md 格式

**log.md 是 Karpathy 模式的"时间导向 append-only"**——可 grep。

```markdown
# Wiki Maintenance Log

> Append-only。每条以 `## [YYYY-MM-DD] <action> | <title>` 开头，可 grep。

## [2026-05-18] init | wiki 骨架就位
首次初始化，索引/日志/CLAUDE.md/子目录占位。

## [2026-05-18] ingest | PRD-V0.5 客服 Agent 需求
- 新建 concepts/ai-fallback.md
- 新建 decisions/llm-model.md（综合 ADR-001/007）
- 更新 entities/customers/A.md（提到该客户为试点）
- 触达 5 页

## [2026-05-19] query | "灰度怎么做的"
- 综合 PRD-V0.5/V0.7 + ADR-009
- 回填到 topics/支付灰度策略.md（新页）

## [2026-05-25] lint | 周一体检
- 发现矛盾：ai-fallback.md 写 0.6 阈值，PRD-V0.7 已改 0.7 → 修正
- 发现 orphan：concepts/old-feature-X.md 无 inbound → 标 [废弃]
- 发现缺概念："非工作时间托管"被 5 处提到无独立页 → 建议建页
```

## 命名规则

| 文件类型 | 命名 |
|---|---|
| Index / Log | 固定名（`index.md` / `log.md`）|
| 概念页 | 英文小写 + 连字符（`ai-fallback.md`） |
| 实体页 | 实体名，中文 OK（如 `客户A.md`），但**真实姓名脱敏** |
| 决策综合 | 主题英文小写连字符（`llm-model.md` / `feature-flag-platform.md`） |
| 主题页 | 中文 OK（`支付灰度策略.md`），便于 PM 浏览 |

## frontmatter 约定

每个 wiki 页**强烈建议**加 frontmatter（便于 Dataview / Obsidian / 自动化工具识别）：

```yaml
---
type: concept | entity | decision | topic
created: YYYY-MM-DD
updated: YYYY-MM-DD（每次改动更新）
sources: [PRD-V0.5, ADR-007]（引用了哪些 raw source）
related: [other-concept-1, other-topic-2]（wiki 内相关页面 slug）
status: active | stale | deprecated（仅 decision 用）
---
```

## 反模式

- ❌ **复制 raw source 原文进 wiki** —— wiki 只放 synthesis，不放复制粘贴
- ❌ **不更新 log.md** —— 每次 ingest / query / lint 都要 log，不然失去演进记录
- ❌ **真实姓名 / 邮箱 / 客户名直接进 wiki** —— wiki 是项目知识，不是 CRM；人物用角色名（如"项目管理员李 X" → "项目管理员"）
- ❌ **wiki 页 ≥ 500 行** —— 拆分；wiki 页该是中粒度（100-300 行）便于交叉引用
