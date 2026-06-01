# Wiki Index

> 本 wiki 由 `pm-wiki-maintainer` skill（按 Karpathy LLM Wiki 模式）维护。
> 最后更新：{{DATE}}
> 总页数：0

## 📖 如何使用本 wiki（按角色分流）

### 🤖 给 AI agent（prd-writer Stage 0 / 自动化消费）

**直读本 index 顶部 + 下方 4 类清单**（concepts / entities / decisions / topics），按需 drill：

1. **prd-writer Stage 0** → 读本 index 的 4 类清单 → 按 PRD 主题关键词 drill `decisions/` + `topics/` + 必读 `glossary.md` 保持术语一致
2. **saas-arch-diagrams 画完图后建议 ingest** → 读 `decisions/` 看是否有架构相关历史决策
3. **pm-wiki-maintainer 自检** → 读 `log.md` 看最近 ingest 节奏

### 👤 给人类（PM 自查 / 新人 onboarding）

- **找概念定义** → 看 [概念](#概念-concepts) 段
- **找历史决策** → 看 [决策](#决策-decisions) 段
- **找跨文档主题** → 看 [主题](#主题-topics) 段
- **找客户 / 竞品 / 产品线信息** → 看 [实体](#实体-entities) 段
- **找名词解释** → 看 [glossary.md](./glossary.md)
- **看演进历史** → 看 [log.md](./log.md)

**新人入门路径**：先读本 index → 推荐 drill 进 1-2 个 `topics/` 综合页（覆盖最广）+ `glossary.md` → 再按需 deep dive 细节。

---

## 概念 (concepts/)

> 产品、技术、方法论的"统一定义"，跨多个源的核心概念。

_（暂无 · 用 pm-wiki-maintainer ingest 一份 PRD 或研究报告会自动新建）_

<!-- 示例：
- [AI 兜底策略](./concepts/ai-fallback.md) — 主模型挂时的自动切换 + 预置话术
- [灰度切流](./concepts/gradual-rollout.md) — 按用户/渠道/设备三维分流
-->

## 实体 (entities/)

> 项目相关的"具象对象"：客户、竞品、产品线、模型、角色等。

### 客户 (entities/customers/)
_（暂无）_

### 竞品 (entities/competitors/)
_（暂无）_

### 产品线 (entities/products/)
_（暂无）_

### 角色 (entities/roles/)
_（暂无）_

## 决策 (decisions/)

> **LLM 综合视图**（不是原始 ADR · 原始版在 `docs/decisions/`）。
> 按主题分组，跨 ADR 关联，标过时状态。

_（暂无 · ADR 进入项目后 ingest 会自动建对应主题综合页）_

<!-- 示例：
- [LLM 模型选择演进](./decisions/llm-model.md) — 跨 ADR-001/007/012
- [灰度平台选型](./decisions/feature-flag-platform.md) — ADR-009
-->

## 主题 (topics/)

> 跨多源的"主题汇总页"，把分散在多个 PRD/研究/决策里的相关段统合成一页。

_（暂无 · query 出现频次 ≥ 3 次的主题会被建议固化为 topic 页）_

<!-- 示例：
- [支付灰度策略](./topics/支付灰度策略.md) — 跨 V0.5/V0.7 PRD + ADR-009
- [客服 AI 自托管](./topics/客服-AI-自托管.md) — 跨 V0.5 PRD + 3 次用户访谈
-->

## 名词表

- [glossary.md](./glossary.md) — 行业术语 / 内部代号 / 缩写

---

## 演进

完整 ingest / query / lint 历史见 [log.md](./log.md)。
