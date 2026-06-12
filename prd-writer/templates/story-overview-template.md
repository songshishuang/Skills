---
version: V{X.Y}
prd_source: {以本文件位置为基准的相对路径 · 必须可解析(lint 强校验)· 层级因仓而异:PRD 与 stories/ 同在版本目录则 ../,PRD 在上两级则 ../../}
prototype_root: {同上校准的原型目录相对路径}
prototype_url: {原型部署地址 · 跨仓稳定入口 · 研发仓侧只用这个}
updated: {YYYY-MM-DD}
note: 本文件由 prd-writer 从全本 PRD 派生 · 公共约定只写这里 · story 内不重复 · 不可手工编辑 · 相对路径仅 PM 仓内有效
---

# V{X.Y} 研发交付总览

> **For AI Coding Agents.** 业务方 / QA / BI / SRE 请读全本:路径见本文件 frontmatter `prd_source`(不在此硬编码,防层级错配)

## 1. 版本目标

{3 bullets · 从全本 §1 Summary 提取交付相关项 · 不写北极星 / 市场背景}

## 2. Story 索引

| ID | 标题 | 优先级 | 依赖 | spec 状态 | 认领人(kickoff 时 PM 录入) |
|---|---|---|---|---|---|
| ST-{XY}01 | {标题} | P0 | - | draft | |

spec 状态(PM 仓权属,本索引维护):`draft` → `ai-passed`(prd-reviewer 分级关卡全过)→ `ready`(研发 48h 走查过)
交付状态(研发仓权属,记研发仓 `specs/V{X.Y}/delivery-status.md`,**不在本仓**):`pending` → `in-dev`(kickoff 签收)→ `done`(AC 全过)

## 3. 公共约定(steering · 只写一遍)

### 3.1 术语表

{本版本业务名词 · 各 ≤1 行 · 从全本 §7.1 提取本期新术语}

### 3.2 跨 story 业务规则

{R1 / R2... 编号 · 从全本 §4.1.4 业务规则清单提取 · story 内按编号引用,不重复正文}

### 3.3 角色与权限速览

{从全本 §2.2 提取角色名 + 权限两列}

### 3.4 原型使用约定

原型仅供视觉布局参考;demo 数据、内联样式**不是需求**。研发仓侧访问原型一律走 frontmatter `prototype_url`(story 内相对路径仅 PM 仓内有效)。

## 4. AI 编码喂法(研发侧标准用法)

每次上下文 = 本文件 + 单个 ST 文件 + 代码仓 CLAUDE.md,一次只做一个 story:

> 请实现 `stories/ST-{XY}01-{标题}.md`,公共约定见同目录 `00-overview.md`。
> 完成后按 AC 逐条自验,输出验收对照表。

## 5. 变更记录

| 日期 | story | 变更摘要 | 影响已签收? |
|---|---|---|---|
