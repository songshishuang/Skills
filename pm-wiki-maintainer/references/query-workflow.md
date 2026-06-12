# Query 工作流：从 Wiki 检索 + 回填

> Karpathy 原文："Good answers can be filed back into the wiki as new pages. This way your explorations compound in the knowledge base just like ingested sources do."

## 触发场景

用户问关于项目历史 / 决策 / 概念的问题，且涉及**跨多源综合**：
- 「**V0.5 我们的 X 是什么**」
- 「**找所有跟 Y 相关的讨论**」
- 「**这个项目的核心概念是什么**」「**为新人生成入门索引**」
- 被 `prd-writer` 的 Stage 0 调用（写新 PRD 时检索 wiki）

**不触发**的场景：
- 用户问通用知识（如"什么是 RAG"）→ 直接回答
- 用户只读单个具体文件 → 直接 Read 那个文件，不走 wiki query

## 4 步流程

### 1️⃣ 先读 index.md

```
Read {wiki_root}/index.md
```

> `{wiki_root}` 探测：`docs/wiki/` → `docs/pm/wiki/` 取首个存在者（规则同 SKILL.md「wiki 根探测」与 prd-writer Stage 0）。

**Karpathy 关键洞察**：
> "When answering a query, the LLM reads the index first to find relevant pages, then drills into them. This works surprisingly well at moderate scale (~100 sources, ~hundreds of pages)."

- index 是**内容导向 catalog**，含每页 1-line summary
- LLM 通过 index 的语义描述判断哪几页相关
- 不需要 embedding / vector search 等额外基建

### 2️⃣ Drill 进相关页

按 query 主题，从 index 筛选 3-7 个候选页 → Read 它们的详细内容。

**优先级排序**：
1. `topics/{X}.md` — 跨源综合视图，命中率最高
2. `decisions/{X}.md` — 决策综合视图（如 query 关于"为什么选 A"）
3. `concepts/{X}.md` — 统一定义（如 query 关于"X 是什么"）
4. `entities/{category}/{name}.md` — 具象对象信息
5. `glossary.md` — 术语解释（默认必读）

### 3️⃣ 综合回答 + 加 citation

格式：
```
<主体回答内容>

依据：
- `docs/wiki/topics/X.md:L15-L23`（核心结论）
- `docs/wiki/decisions/Y.md:L42`（决策记录）
- `docs/wiki/concepts/Z.md`（概念定义）
```

**反模式**：
- ❌ 答案里大段 copy wiki 原文 → 应该综合 + 给链接
- ❌ 不加 citation → 用户无法 verify
- ❌ 不区分"wiki 明确写"和"我推断" → 明确推断时标 *（推断 / 未在 wiki 中明确）*

### 4️⃣ 回填规则（Karpathy 模式关键）

**触发回填的 3 种 query 结果**：

| 类型 | 例子 | 回填路径 |
|---|---|---|
| **跨页比较 / 综合** | 「我们 vs OpenRouter vs Portkey」 | 新建 `topics/竞品矩阵.md` |
| **新发现的关联** | "灰度策略和评测集设计原来是耦合的" | 在两个相关页加 cross-reference + 可能新建 topic |
| **用户拍板的判断** | "这个概念的定义最终我们决定 X" | 更新 `concepts/{X}.md` 含 `decided: 2026-MM-DD` |

**回填动作必须**：
1. 先**问用户**：「本次 query 产出 X 看起来有复用价值，建议回填进 wiki 成 `<路径>` —— 同意？」
2. 用户拍板后才写
3. 写完追加 `log.md` 用 `query` action：
   ```
   ## [2026-05-19] query | "V0.5 的灰度策略是什么"
   - 综合 topics/支付灰度策略.md + decisions/feature-flag-platform.md
   - 回填：在 concepts/gradual-rollout.md 加 V0.7 实际数据段
   ```

## 集成场景：被 prd-writer Stage 0 调用

`prd-writer` 写新 PRD 前会 invoke 本工作流（详见 `prd-writer/SKILL.md` Stage 0）：

```
prd-writer 启动
  ↓
Stage 0: Read docs/wiki/index.md
  ↓
按 PRD 主题判断 → drill 进 topic/concept/decision/entity/glossary
  ↓
把 wiki 内容作为 Stage 1 信息收集的先验上下文
  ↓
PRD 写完后 → 建议「ingest 本期 PRD 进 wiki」
```

**集成关键约定**：
- 写 PRD 时**只读 wiki 不写 wiki**（写 wiki 是 pm-wiki-maintainer ingest 的职责，避免双写冲突）
- 如发现 wiki 与新 PRD 冲突（概念定义变了 / 决策变了）→ **surface 给用户**，不默默改 wiki
- 写完 PRD 后**主动建议** ingest 新 PRD 回 wiki（闭环）

## 反模式

- ❌ **查 wiki 不读 index 直接搜全部** —— 浪费 token，违反 Karpathy 模式
- ❌ **查到答案不回填 wiki** —— "explorations compound" 失效，下次同样问题还要再查
- ❌ **回填默默写** —— 必须先问用户，回填动作要可控
- ❌ **回填没记 log** —— log.md 是演进史，不记就丢
- ❌ **prd-writer Stage 0 跳过 wiki** —— 项目历史脱节
- ❌ **prd-writer Stage 0 边读边改 wiki** —— 职责不清，ingest 是 pm-wiki-maintainer 的事

## Tier 升级路径

当前为 Tier 1（手动 Read · 适用 ≤ 100 页 wiki）。规模扩大时升级：

| Tier | 触发条件 | 做法 |
|---|---|---|
| 1（当前） | wiki ≤ 100 页 | Read index.md + drill |
| 2 | wiki 100-300 页 | 加 `wiki-query.sh` 脚本（grep + frontmatter 排序）|
| 3 | wiki > 300 页 / 跨项目 | 上 [qmd](https://github.com/tobi/qmd) MCP（BM25 + vector + LLM rerank）|

Karpathy 自己用 Tier 1 跑到 ~100 sources / 数百页都没问题，不要过早工程化。
