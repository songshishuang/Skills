---
story_id: ST-{XY}{NN}
title: {功能标题}
version: V{X.Y}
priority: P0|P1|P2
status: draft            # spec 状态:draft / ai-passed / ready(交付状态在研发仓 delivery-status.md)
depends_on: []           # 前置 story ID 列表
source: {相对路径}PRD 全本#{章节锚点}   # 以本文件位置为基准 · PM 仓内必须可解析(lint 强校验)
prototype: {相对路径}{页面}.html        # 仅 PM 仓内有效 · 研发仓侧用 overview 的 prototype_url
spec_test: pending       # pending / passed · passed = 分级关卡全过(标准=三关 · lite=两关)· prd-reviewer 回写
---

# ST-{XY}{NN} {功能标题}

## 背景

{≤3 句 · 只写与本 story 直接相关的动机 · 从全本 §4.2 对应页面「业务场景」提取}

## 用户故事

作为「{角色}」,我想要「{能力}」,以便「{业务价值}」。

## 验收标准(AC)

- [ ] AC1: Given {前置},When {动作},Then {可观察结果}
- [ ] AC2: ...

{每条可客观判定 · 禁用「友好 / 合理 / 较快 / 优化 / 良好 / 尽量」等不可测词}

## 范围

**做**:{本 story 交付的功能点}
**不做**:{显式边界 · 防 AI 越界发挥 · 相邻功能注明所属 story,如「通知渠道(ST-{XY}02)」}

## 功能细节

### 关键字段

| 字段 | 业务类型 | 约束 |
|---|---|---|
| {字段名} | {文本/枚举/数值/时间} | {必填性 · 长度 · 唯一性 · 业务级约束,不写 PK/FK/表结构} |

### 交互动作

{click / hover / 提交触发的反馈与跳转 · 从全本 §4.2「交互动作」提取}

### 状态与异常

{状态机流转 · 校验失败 · 二次确认 · 空态 · 引用公共规则用 R 编号(见 overview §3.2)}

## 依赖与边界

{前置 story / 外部依赖 · 没有则**删除本节**(不留 N/A)}
