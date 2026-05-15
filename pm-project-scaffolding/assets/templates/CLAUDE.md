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

---

*本项目使用 `pm-project-scaffolding` skill 在 {{DATE}} 初始化生成。*
