# Lint 工作流：Wiki 健康度体检

> Karpathy 原文："Periodically, ask the LLM to health-check the wiki. Look for: contradictions between pages, stale claims that newer sources have superseded, orphan pages with no inbound links..."

## 触发场景

用户说：
- 「**整理项目沉淀**」「lint wiki」「wiki 体检」
- 「**找过期决策**」「找矛盾」「找 orphan 页面」
- 「**wiki 哪里薄弱**」「下一步该读什么源」「补什么概念」

## 6 类检查（必跑）

### 1️⃣ Contradictions（跨页矛盾）

扫所有 wiki 页，找**同一事实/数值在不同页面声明不一致**：

| 类型 | 示例 |
|---|---|
| 概念定义矛盾 | `concepts/ai-fallback.md` 写阈值 0.6，`decisions/llm-model.md` 写 0.7 |
| 状态矛盾 | `entities/customers/A.md` 写"已上线"，`topics/V0.7.md` 写"灰度中" |
| 时间线矛盾 | 两页都标 created 但触达事件时间冲突 |

**处理**：
- ⚠️ 标记两页的冲突位置
- **问用户**：哪个为准？是不是新数据已 supersede 旧数据？
- 用户拍板后，修订过时一方 + 在 log 记录

### 2️⃣ Stale Claims（过时声明）

找**被新源 supersede 但页面未更新**的内容：

| 信号 | 检查 |
|---|---|
| frontmatter `sources` 含老 PRD/ADR | 看是否有更新版 PRD/ADR 已 ingest，但此页 sources 未更新 |
| 决策综合页含 ADR-N 标"✅ 生效" | 看是否有 ADR-N+M 已 supersede 它，但本页未标过时 |
| 状态字段 `status: active` | 看页面是否 ≥ 3 个月没更新（看 frontmatter updated） |

**处理**：
- 在过时段加 `⚠️ [过时 / 已被 X supersede]` 标记
- 不删除内容（保留历史演进）
- 触发回填建议：如有新 ADR 但未 ingest，**建议用户先 ingest 它**

### 3️⃣ Orphan Pages（无入链）

找**没有任何其他 wiki 页引用**的页面：

```bash
# 实施方式（AI 用 Read + grep 完成）：
# 1. 列出所有页面文件名（slug）
# 2. 用 grep 在所有其他页面查找该 slug 的引用
# 3. 无引用 = orphan
```

**处理**：
- 不一定要删 —— 可能是新建未链接，或独立 reference 资料
- 建议：
  - 是否应加 cross-reference？（其他页面是否真应该引用它？）
  - 是否应标 `[废弃]`？（已无关联表示该内容已不再有效）

### 4️⃣ Missing Concepts（缺概念）

找**被反复提到但无独立 concept 页**的术语 / 概念：

```bash
# 实施方式：
# 1. 跨所有 wiki 页扫高频实体名词（>= 3 次出现）
# 2. 看是否有对应 concepts/{name}.md
# 3. 没有 = missing concept
```

**处理**：
- 建议建 `concepts/{name}.md`
- 等用户拍板（按 ingest-workflow 反模式："建页门槛是未来 ≥ 2 个源会引用"）

### 5️⃣ Missing Cross-References（缺交叉引用）

找**理应相互引用但没引用**的页面对：

| 信号 | 检查 |
|---|---|
| 两页 sources 重合 | 同一 raw source 触达的页面应在 related 字段互相引用 |
| 同主题的 concept / topic / decision | 如 `concepts/灰度切流.md` 和 `topics/支付灰度策略.md` 应互相引用 |
| 实体的所属类别页 | 如 `entities/competitors/openrouter.md` 应被 `topics/竞品矩阵.md` 引用（如有该 topic） |

**处理**：
- 提议在双方页面的 `related:` frontmatter 加 cross-ref
- 用户拍板后写入

### 6️⃣ Data Gaps（信息盲区，提议下一步该查的源）

**Karpathy 关键洞察**："The LLM is good at suggesting new questions to investigate and new sources to look for."

扫描已有 wiki，找信息缺口：

| 缺口类型 | 例 |
|---|---|
| 某 entity 信息单薄 | `entities/competitors/portkey.md` 只有 1 句话定位 → 建议补做"定价 / 功能矩阵"研究 |
| 某 topic 有承诺但无落地 | `topics/V0.2-准入评估.md` 提到"灰度策略" 但没具体数据 → 建议查最新 A/B 测试结果 |
| 某 decision 缺关键考量 | `decisions/llm-model.md` 标"选 deepseek-v3 因价格"但没具体成本对比 → 建议补做成本表 |

**处理**：
- **不主动找数据** —— 数据来源是 raw source 不是 wiki
- 输出一份「**下一步该读什么**」清单给用户

## 输出格式

Lint 完后给用户一份**结构化报告**：

```markdown
# Wiki Lint 报告 · 2026-05-19

## 概况
- 总页数：9
- 健康页数：6（67%）
- 需处理：3 处

## 1. 矛盾（1 处）⚠️
- `concepts/ai-fallback.md:L12` vs `decisions/llm-model.md:L23` — 兜底阈值 0.6 vs 0.7
  → 建议：以 ADR-012（最新决策）为准，更新 ai-fallback.md

## 2. 过时（1 处）⚠️
- `decisions/llm-model.md` 含 ADR-001 标 `✅ 生效`，但 ADR-012 已 supersede
  → 建议：改成 `⚠️ 已被 ADR-012 替代`

## 3. Orphan（1 处）
- `concepts/old-feature-X.md` 无入链
  → 建议：标 `[废弃]` 或加 cross-reference

## 4. 缺概念（2 处）
- "非工作时间托管" 被 5 处提到无独立页 → 建议建 `concepts/off-hours-fallback.md`
- "情绪雷达" 被 3 处提到无独立页 → 建议建 `concepts/emotion-radar.md`

## 5. 缺交叉引用（2 对）
- `concepts/gradual-rollout.md` ↔ `topics/支付灰度策略.md` 应互相引用
- `entities/competitors/openrouter.md` ↔ `topics/竞品矩阵.md`（待建）应互相引用

## 6. 信息盲区（3 处）
- `entities/competitors/portkey.md` 信息单薄 → 建议补"定价 / 功能矩阵"研究
- `entities/competitors/cloudflare-ai-gateway.md` 缺页 → 待补
- `decisions/llm-model.md` 缺成本对比 → 建议补做

## 7. 下一步该读的源（基于 gaps）
- Cloudflare AI Gateway 官方定价页（弥补竞品矩阵）
- 内部最新一份"模型成本月报"（弥补决策考量）
```

## 追加 log.md

完成 lint 后追加：

```markdown
## [2026-05-19] lint | 周一体检
- 总页数：9 · 健康率：67%
- 处理：1 矛盾 ✅ 1 过时 ✅ 1 orphan → 待用户拍板
- 建议建：2 concept + 2 cross-ref
- 建议补的源：Cloudflare 定价页 + 模型成本月报
- 详细报告：见对话记录
```

## 节奏建议

| 频率 | 触发时机 |
|---|---|
| 周度 | 写完一份新 PRD / 大改动后 |
| 月度 | 不动也跑一次，找过期 |
| 大版本节点 | PRD V0.X → V0.X+1 切版本时必跑 |

## 反模式

- ❌ **lint 时直接改 wiki** —— 必须先报告 + 让用户拍板再改
- ❌ **lint 只列问题不给建议** —— 每个发现都要附"建议怎么做"
- ❌ **跳过 log.md** —— lint 是 wiki 演进史的一部分
- ❌ **每次 lint 都报告"全部健康"** —— 没问题也要标"已检查 X / Y 项，无新发现"，让用户知道你真跑过

## Tier 升级（规模大时）

| Tier | 触发条件 | 做法 |
|---|---|---|
| 1（当前） | wiki ≤ 100 页 | AI Read + grep 完成 6 类检查 |
| 2 | wiki 100-300 页 | 加 `wiki-lint.sh` 脚本（自动化 orphan / cross-ref 检测 + 报告） |
| 3 | wiki > 300 页 | qmd MCP 提供 semantic similarity 找相关概念 |
