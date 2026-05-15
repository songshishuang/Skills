# 目录约定 (Directory Conventions)

12 个顶层条目各自的用途、子结构、沉淀准则。AI 在执行 skill 时如果用户问「为什么要这个目录」「这个目录放什么」，引用本文件回答。

---

## 顶层文件（5 个）

### `README.md`
- **用途**：项目门面——任何人 30 秒读懂项目定位、当前阶段、关键文档入口
- **必含**：一句话定位 / 快速开始 / 目录速览 / 关键文档入口 / 部署方式
- **更新时机**：项目主要里程碑变更时
- **写作准则**：用户视角而非工程视角；信息层级清晰；表格优于长段落

### `CHANGELOG.md`
- **用途**：PM 视角的产品版本史（与 git log 的代码层面变更互补）
- **受众**：内部团队 / 开发者
- **格式**：参考 [Keep a Changelog](https://keepachangelog.com)，按版本号倒序，含 `[Unreleased]` 段记录待发布
- **分类**：新增 / 变更 / 移除 / 修复 / 文档

### `CLAUDE.md`
- **用途**：Claude Code 工作指引——告诉 AI 协作者项目架构、约定、关键路径
- **必含**：Repo layout（目录树 + 注释）/ 项目类型 / 关键架构模式 / Git 工作流
- **维护**：随项目目录调整同步更新

### `firebase.json`（可选）
- **用途**：Firebase Hosting 部署配置
- **关键字段**：`hosting.public` 指向部署源目录（通常是 `prototypes/`）
- **何时生成**：项目要做 Firebase 演示部署时

### `{Project}.code-workspace`（可选）
- **用途**：VS Code 工作区配置
- **可换**：`.idea/` 或其他 IDE 配置

---

## `docs/` —— PM 文档主入口

所有产品视角的文档都在这里。**这是 PM 入口**。

### `docs/prd/`
- **内容**：需求文档系列（PRD-v0.1, v0.2, v1.0...）
- **命名**：`PRD-v{major}.{minor}.md`
- **何时建新文件**：主版本（v1 → v2）或重大功能集变更（v1.0 → v1.1）

### `docs/roadmap.md`
- **特征**：单文件、滚动维护、6 个月视野
- **必含**：当前阶段 + 里程碑表（4-6 项）+ 下个阶段预告 + 北极星指标 + 关键依赖与风险
- **更新节奏**：季度评审

### `docs/decisions/`
- **内容**：ADR（Architecture Decision Records）—— 每个重要决策一份
- **判断标准**：「这个决策反悔会影响 ≥ 2 周工时或 ≥ 2 个角色」才写 ADR
- **命名**：`ADR-NNN-{slug}.md`（NNN 三位顺序编号，slug 英文小写连字符）
- **不可改**：已生效 ADR 不修改，决策变更时新建 ADR 标注「替代 ADR-XXX」

### `docs/product-planning/`
- **内容**：产品架构图、规划图、链路图、答辩 / 评审材料
- **形式**：长文 + 架构图（HTML / SVG / 截图）

### `docs/market-research/`
- **内容**：市场研究——外部信息为主
- **子目录**：
  - `competitors/` — 竞品分析
  - `industry-reports/` — 行业报告（艾瑞 / IDC / Gartner 等）
  - `trends/` — 行业趋势观察
- **沉淀准则**：每份外部报告超 5 页时配一份摘要笔记

### `docs/user-research/`
- **内容**：用户研究——直接来自用户的信息
- **子目录**（按需）：`personas/` / `interviews/` / `surveys/` / `usability-tests/`
- **与 data-analysis 的边界**：user-research 是定性「为什么」，data-analysis 是定量「是什么」
- **沉淀准则**：访谈纪要 24 小时内写完；录音不进 git（云盘备份）；个人信息脱敏

### `docs/data-analysis/`
- **内容**：产品效果数据分析——埋点 / 日志 / 看板分析
- **何时启用**：产品上线后

### `docs/releases/`
- **内容**：面向客户的上线公告 Release Notes（与 CHANGELOG 互补）
- **命名**：`YYYY-MM-DD-{version}-release-notes.md`
- **写作准则**：营销 + 用户教育语气，TL;DR 在前

---

## `prototypes/` —— 高保真原型（可选）

仅 `ai-saas` / `generic-saas` / `mobile-app` 项目类型才生成。

- **子目录**：按业务角色命名（例：`operator/` `agent/` `admin/`）
- **共享资源**：`assets/`（mock 数据 / 组件 / 样式）
- **导航 hub**：`index.html`
- **部署源**：常作为 Firebase Hosting 的 `public` 目录

---

## `skills/` —— Skill 库（仅 ai-saas）

仅 `ai-saas` 类型生成——AI / Agent 产品才需要。

- **`plan/`**：各 Skill 的设计计划（**不对外分发**）
- **`{name}/`**：标准 Skill 目录 = `SKILL.md` + `scripts/` + `references/` + `assets/`
- **设计哲学**：`skills/{name}/` 是干净的可交付包；设计稿分离到 `plan/` 保持包的整洁

---

## `training/` —— 培训手册

产品上线后必备。**外部 vs 内部双轨**。

### `training/customer/`
- **受众**：外部客户
- **三件套**：
  - `onboarding-guide.md` — 新客户上手指南（5 步以内）
  - `operation-manual.md` — 操作手册（按场景查阅）
  - `faq.md` — 常见问题及答案
- **写作准则**：任务驱动（怎么完成 X）而非功能驱动（X 是什么）；大量截图

### `training/internal/`
- **受众**：内部团队
- **三件套**：
  - `sales-kit.md` — 销售工具包（30 秒电梯定位 + 核心价值 + 异议应对）
  - `support-playbook.md` — 客服 Playbook（分类应对 + SLA + 升级路径）
  - `new-hire-onboarding.md` — 新员工 30 天上手计划
- **维护节奏**：sales-kit 跟随 Release Notes 更新；support-playbook 跟随 FAQ；onboarding 季度通读

---

## `app/` —— 真实代码（占位）

- **当前**：占位（只有 README）
- **何时启用**：PRD 评审通过、原型验证完成、决定进入工程实施
- **设计哲学**：AI Native 项目尤其要避免「过早工程化被沉没成本绑架」——原型阶段验证设计决策，决策稳定再启工程

---

## `archive/` —— 归档层

保留版本史但不污染日常工作视野。

- **何时搬入**：3 个月没人访问的目录 / 已被取代的设计稿 / 废弃的实验代码
- **不要轻易删除**：归档可逆，删除不可逆；6 个月后再评估是否真删
- **常见子目录**：
  - `early-mockups/` — 早期 V1/V2 demo
  - `research/` — 早期访谈 + 已废弃脚本
  - `legacy-*` — 旧部署 / 旧框架
  - `design-handoff/` — 设计工具产出的交接 bundle

---

## `Logs/` —— Claude Code 协作日志

每日对话复盘，按月归档。

- **结构**：`Logs/YYYY-MM/YYYY-MM-DD.md` + `Logs/YYYY-MM_汇总.md`
- **必含**：当日洞察 / 业务价值萃取 / Prompt 优化建议 / 算力消耗追踪
- **用途**：长期项目的协作记忆 + 个人方法论沉淀

---

## 维护新增目录的 3 条规则

如果用户想加新顶层目录：

1. 新顶层目录必须先评审——顶层条目不能超过 15 项（认知容量上限）
2. 新目录必须配 README.md——说明用途 / 子结构 / 沉淀准则
3. 新目录必须在 CLAUDE.md 的 Repo layout 段同步登记

如果新目录的内容能塞进现有目录的某个子目录，**优先塞**——不要轻易在顶层加东西。
