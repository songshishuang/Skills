# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repo layout (PM-oriented)

```
docs/                  # 产品视角的所有文档（PM 入口）
  prd/                   PRD 系列
  roadmap.md             滚动路线图（6 个月视野）
  decisions/             ADR 决策记录
  product-planning/      产品架构 / 规划图
  market-research/       市场研究（competitors / industry-reports / trends）
  user-research/         用户研究（访谈 / 问卷 / 画像）
  data-analysis/         产品效果数据分析
  releases/              上线公告（面向客户）
  wiki/                  ⭐ LLM Wiki · 项目知识沉淀（pm-wiki-maintainer 维护）
    index.md / log.md / glossary.md / CLAUDE.md
    concepts/ entities/ decisions/ topics/

prototypes/            # 高保真原型（按业务角色分子目录）

skills/                # 可对外整体分发的 Skill 库（仅 AI 产品）
  plan/                  各 Skill 设计计划（不分发）

training/              # 培训手册
  customer/              客户培训：onboarding / 操作手册 / FAQ
  internal/              内部培训：销售 / 客服 / 新员工

app/                   # 真实代码（占位 / 实际开发）
archive/               # 已废弃 / 历史归档
Logs/                  # 协作日志

顶层文件                README.md / CHANGELOG.md / CLAUDE.md（本文档）
```

## Project type

**{{PROJECT_TYPE}}** — {{PROJECT_TAGLINE}}

⚠️ TODO：补充项目技术栈说明（无构建链 / Node + React / Python + Django / ...）

## Git workflow

⚠️ TODO：根据团队约定补充——是否启用 Stop hook 自动 commit / 分支命名规则 / PR 流程等

## Key UI patterns

⚠️ TODO：项目特有的 UI 模式和约定

## Common pitfalls

⚠️ TODO：项目特有的"踩坑指南"——常见错误、不要做的事

## 📚 LLM Wiki · 项目知识沉淀

本项目集成 [`pm-wiki-maintainer`](https://github.com/songshishuang/Skills) skill（基于 [Karpathy LLM Wiki 模式](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)）。

### AI Agent 约定

- **写新 PRD** → `prd-writer` skill 的 Stage 0 自动读 `docs/wiki/index.md` 作为先验上下文
- **查项目历史** → 走 `pm-wiki-maintainer` Query workflow（先 index 后 drill）
- **写完重要文档** → 建议触发 `pm-wiki-maintainer` ingest 回填进 wiki

### 三层架构

| 层 | 谁拥有 | 在本项目 |
|---|---|---|
| Raw Sources（只读） | 你 | `docs/{prd,decisions,product-planning,user-research,market-research}/` 等 |
| Wiki（LLM 维护） | LLM | `docs/wiki/` ← 走 pm-wiki-maintainer 管，不手工大改 |
| Schema（共演化） | 你 + LLM | 本文件 + `docs/wiki/CLAUDE.md` |

### 不要做的事（wiki 相关）

- ❌ PRD 里复制 wiki 内容（wiki 是 synthesis，PRD 引用 link 即可）
- ❌ 直接 edit `docs/wiki/`（走 pm-wiki-maintainer 的 ingest/lint workflow）
- ❌ 跳过 prd-writer Stage 0（导致与项目历史脱节）

---

*本项目使用 `pm-project-scaffolding` skill 在 {{DATE}} 初始化生成。*
