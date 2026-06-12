# Wiki 工作规则（投放到项目 docs/wiki/CLAUDE.md）

> 这个文件由 `pm-wiki-maintainer` skill 自动生成。
> 任何 AI agent 进入本目录看到本文件即按 Karpathy LLM Wiki 模式工作。
> **不要把本文件等同于 raw source；本文件是 schema（约定）**。

## 这是什么

本 `docs/wiki/` 目录是 **LLM 维护的项目知识 wiki**（按 [Karpathy LLM Wiki 模式](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)）。

**三层架构**：
- 上游 raw sources：`docs/prd/` / `docs/user-research/` / `docs/competitor-analysis/` / `docs/decisions/`（原始 ADR）/ `docs/market-research/` / 客户访谈纪要 / 会议纪要
- 本目录 wiki：LLM 维护的 markdown 网
- schema（本文件 + `pm-wiki-maintainer` skill 本体——安装位置随你的 AI 工具而异，按 skill 名调用即可）

## 你（AI agent）的核心约定

### ✅ 你应该
- 当用户说"把 X 存进 wiki / 沉淀 X / ingest X"时 → 按 `pm-wiki-maintainer` skill 的 **ingest 工作流**（skill 内 `references/ingest-workflow.md`）执行
- 当用户问"项目里 Y 是什么 / 找 Z 的所有讨论 / V0.X 的 W 怎么做"时 → 先读本目录 `index.md`，再 drill 进相关页
- 当用户说"整理沉淀 / lint wiki / 找过期决策"时 → 按 lint workflow 检查
- 每次 ingest / query / lint 都**追加** `log.md`（强制）
- 改动 wiki 后**报告给用户**「触达 N 页：A / B / C」（不要默默改）

### ❌ 你不应该
- 默默写 wiki 而不和用户讨论
- 把 raw source 原文复制粘贴进 wiki（wiki 是 synthesis）
- 跳过 `log.md` 不记录演进
- 把 wiki 当 raw source 用（wiki 是衍生物，原始信息查 `docs/{prd,user-research,decisions...}`）
- 真实姓名 / 邮箱 / 客户名直接进 wiki（脱敏：用角色名 / 客户代号）

## 目录结构速查

```
docs/wiki/
├── index.md           # 内容 catalog（找页面从这里开始）
├── log.md             # 时间 log（演进史）
├── CLAUDE.md          # 你正在读的文件
├── concepts/          # 概念页（统一定义）
├── entities/          # 实体页（客户/竞品/产品/角色）
│   ├── customers/
│   ├── competitors/
│   ├── products/
│   └── roles/
├── decisions/         # LLM 综合视图（不是原始 ADR）
├── topics/            # 跨源主题汇总
└── glossary.md        # 名词表
```

各类页面格式见 `pm-wiki-maintainer` skill 内 `references/wiki-structure.md`（按 skill 名调用，不依赖本地相对路径）。

## Decisions 特别说明

| `docs/decisions/`（raw） | `docs/wiki/decisions/`（LLM 综合） |
|---|---|
| 原始 ADR · 不可改 | LLM 综合视图 · 可演化 |
| 单条记录 | 跨 ADR 关联 + 过时标记 |

**不要修改 `docs/decisions/` 下的原始 ADR**。LLM 综合视图写在 `docs/wiki/decisions/`。

## 常见任务的工作流

### 用户提供新 PRD（如 V0.7-需求.md）

1. **Read** 该 PRD（重要章节）
2. **与用户讨论**核心信息（哪些是新增 / 修订 / 废弃）
3. **预报触达页面**（5-15 页）
4. **新建 + 更新**：
   - `topics/V0.7-<主题>.md` 新建
   - `decisions/{相关主题}.md` 更新（如有 ADR 变化）
   - `concepts/{涉及概念}.md` 更新（如有新概念定义）
   - `entities/customers/{试点客户}.md` 更新（如提到客户）
5. **更新** `index.md` + **追加** `log.md`
6. **报告** 给用户

### 用户问"V0.5 灰度策略是什么"

1. **读** `index.md` 找"灰度切流"概念页 / "支付灰度策略"主题页
2. **Drill** 进去读详细
3. **回答** 用户 + 给 citation（`docs/wiki/topics/支付灰度策略.md:L15`）
4. **判断回填**：如果回答揭示了新关联（如"灰度策略和评测集设计是耦合的"）→ 建议建新 topic 页 or 加 cross-reference

### 用户说"整理项目沉淀"

按 `pm-wiki-maintainer` skill 的 **lint 工作流**（skill 内 `references/lint-workflow.md`）做 6 类检查：
1. Contradictions（跨页矛盾）
2. Stale claims（旧声明被新源 superseded）
3. Orphan pages（无 inbound link）
4. Missing concepts（被反复提到但无独立页）
5. Missing cross-references（应相互引用但没引用）
6. Data gaps（提议下一步该查的源）

---

## 注：这是 schema，会演化

按 Karpathy 模式："the schema is co-evolved over time as you figure out what works for your domain."

如果你（AI）发现新工作流 / 新源类型未覆盖 / 新触发场景 → **告诉用户**「本 schema 缺 X 约定，建议追加」，让用户决定。
