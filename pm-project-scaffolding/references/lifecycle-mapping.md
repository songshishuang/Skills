# 生命周期 → 目录映射 (Lifecycle Mapping)

PM 项目从立项到归档的 8 个阶段，每个阶段对应的目录与产出物。

AI 在执行 skill 时如果用户问「我现在在阶段 X，应该建什么文档」，引用本文件回答。

---

## 阶段总览

| 阶段 | 主要目录 | 主要产出 |
|---|---|---|
| 01 研究 | `docs/user-research/` · `docs/market-research/` | 访谈纪要 / 用户画像 / 竞品分析 / 行业报告 |
| 02 规划 | `docs/prd/` · `docs/product-planning/` · `docs/roadmap.md` · `docs/decisions/` | PRD / 产品架构图 / 路线图 / ADR |
| 03 设计 | `prototypes/` | 高保真 HTML 原型 / Mock 数据 |
| 04 开发 | `skills/` · `app/` | Skill 实现 / 真实代码 |
| 05 发布 | `docs/releases/` · `CHANGELOG.md` | 上线公告 / 变更日志 |
| 06 培训 | `training/customer/` · `training/internal/` | 客户上手指南 / 销售工具包 |
| 07 运营 | `docs/data-analysis/` · `training/internal/support-playbook.md` | 效果数据 / 客服 Playbook |
| 08 归档 | `archive/` · `Logs/` | 历史快照 / 协作日志 |

---

## 阶段 01：研究

### 何时进入
项目立项前后——还没决定要做什么、给谁做、值不值得做。

### 必备产出
- `docs/market-research/competitors/{competitor}.md` — 至少 2 个竞品的产品分析
- `docs/market-research/industry-reports/` — 至少 1 份行业报告或摘要
- `docs/user-research/interviews/` — 至少 3 场目标用户访谈纪要
- `docs/user-research/personas/persona-{primary-role}.md` — 主要目标用户画像

### 出阶段标志
- 能清晰回答「产品定位是什么」「目标用户是谁」「为什么不是 XX 项目」
- 有足够材料支撑写出 PRD-v0.1

---

## 阶段 02：规划

### 何时进入
研究阶段产出足以支撑写需求文档时。

### 必备产出
- `docs/prd/PRD-v0.1.md` — 第一份 PRD（v0.1 通常是粗版，跑通从研究到设计的工作流）
- `docs/product-planning/产品架构图.html`（或 .svg / .png）— 第一版产品架构
- `docs/roadmap.md` — 路线图初稿（6 个月视野，含 4-6 个里程碑）
- `docs/decisions/ADR-001-{first-major-decision}.md` — 第一个重大决策记录

### 出阶段标志
- PRD 通过内部评审
- 路线图获得团队 / 上级共识
- 关键技术选型已经决策并 ADR 化

---

## 阶段 03：设计

### 何时进入
PRD 评审通过、需要把抽象需求转化为可视化原型时。

### 必备产出
- `prototypes/{role}/` — 每个业务角色一个高保真原型
- `prototypes/assets/mock.js` — Mock 数据（单一数据源）
- `prototypes/index.html` — 多角色导航 hub
- `prototypes/README.md` — 三角色定位 + 关键设计原则

### 出阶段标志
- 三角色原型可点击演示完整工作流
- 至少跑过 1 轮用户测试（找 user-research 里的 persona 实测）
- 关键交互模式确定（artifact 模式 / modal 模式 / 重渲染时机...）

---

## 阶段 04：开发

### 何时进入
原型评审通过、关键设计决策稳定时。

### 必备产出（ai-saas 项目）
- `skills/{skill-name}/SKILL.md` — 至少 2 个核心 Skill（覆盖核心业务场景）
- `skills/plan/{skill-name}-plan.md` — Skill 设计计划（不对外分发）
- `app/` — 真实代码实现（按团队技术栈）

### 必备产出（generic-saas / mobile-app）
- `app/` — 真实代码实现

### 出阶段标志
- 核心功能可在测试环境跑通
- 集成测试覆盖率达标（团队约定）
- 准备好对外发布的部署方案

---

## 阶段 05：发布

### 何时进入
开发完成、准备 GA（General Availability）时。

### 必备产出
- `docs/releases/{YYYY-MM-DD}-v1.0-release-notes.md` — 面向客户的上线公告
- `CHANGELOG.md` — 更新 `[Unreleased]` 段并切到 `[v1.0]` 版本号
- `docs/product-planning/{发布会演讲材料}.html`（如有）— 发布会 / 答辩 / 评审材料

### 出阶段标志
- Release Notes 发送给客户 / 销售 / 客服
- 内部 CHANGELOG 同步更新
- 监控指标看板就位

---

## 阶段 06：培训

### 何时进入
发布前 1-2 周，或发布同时。

### 必备产出
- `training/customer/onboarding-guide.md` — 新客户上手指南
- `training/customer/operation-manual.md` — 操作手册（至少覆盖核心 5 个场景）
- `training/customer/faq.md` — 至少 10 个高频 FAQ
- `training/internal/sales-kit.md` — 销售工具包（30 秒电梯 + 3 个核心价值 + 5 个异议应对）
- `training/internal/support-playbook.md` — 客服 Playbook（5 类问题应对 + SLA）

### 出阶段标志
- 培训材料经过销售 / 客服 / 客户成功团队评审
- 至少 1 场内部培训完成
- 至少 1 场客户 onboarding 跑通

---

## 阶段 07：运营

### 何时进入
GA 后客户开始使用。

### 必备产出（持续）
- `docs/data-analysis/{metric-area}-report-{YYYY-Qn}.md` — 季度数据分析报告
- `training/customer/faq.md` — 持续追加客户高频问题
- `training/internal/support-playbook.md` — 持续追加新的问题应对场景
- `docs/decisions/ADR-{NNN}-{post-launch-decision}.md` — 上线后重大决策（产品方向调整 / 砍掉某个场景等）

### 持续节奏
- 每月：评审客户高频问题，决定哪些升级到 FAQ / 操作手册 / Release Notes
- 每季度：复盘 NPS / 北极星指标 / 路线图执行情况
- 每半年：评估归档目录里的内容是否真的可以删

---

## 阶段 08：归档

### 何时触发
- 项目废弃 / 砍掉
- 大版本切换（v1 → v2，老版本所有资产归档）
- 季度复盘发现某些目录 3 个月以上没人访问

### 操作
- 把待归档目录搬到 `archive/{topic}/`，加 `archive/{topic}/README.md` 说明归档原因和时间
- **不要直接删除**——保留 6 个月再评估是否真删
- 在 `CHANGELOG.md` 标注「移除 X 功能」+ 引用归档位置

---

## 跨阶段共生的目录

不属于单一阶段，而是贯穿整个生命周期的：

- `Logs/` — Claude Code 协作日志（每天都在记录）
- `README.md` — 项目门面（每个阶段都要保持准确）
- `CLAUDE.md` — AI 协作指引（目录结构变化时同步）
- `CHANGELOG.md` — 版本变更（每次发布更新）
- `docs/roadmap.md` — 滚动路线图（季度评审）

---

## AI 引导客户的对话脚本

如果用户没明说在哪个阶段，AI 可以这样引导：

> "为了帮你判断当前该建哪些文档，我先问几个问题：
> 1. 你的产品**已经有客户在用**吗？（在用 → 阶段 7；准备上线 → 阶段 5-6；还在开发 → 阶段 4）
> 2. **PRD 评审通过**了吗？（通过 → 阶段 3 设计；没通过 → 阶段 2 规划）
> 3. 已经有**用户访谈或竞品分析**吗？（有 → 阶段 2；没有 → 阶段 1 研究）
> 根据回答，我帮你判断当前阶段，并指出**接下来必须建的 3 份文档**。"

每个阶段的「必须建的 3 份文档」按上文 "必备产出" 段挑取**最关键的 3 项**。
