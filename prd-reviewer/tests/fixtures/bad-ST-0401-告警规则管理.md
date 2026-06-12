---
story_id: ST-0401
title: 告警规则管理
version: V0.4
priority: P0
status: draft
depends_on: [ST-0499]
source: PRD-v0.4.md#4.2.3
prototype: ../../prototypes/v0.4/alert-rules.html
spec_test: pending
---

# ST-0401 告警规则管理

## 背景

V0.3 监测列表只能事后人工巡检,异常发现平均滞后 2 天。本 story 提供阈值告警规则配置能力。

## 用户故事

作为「运营」,我想要「对监测指标配置阈值告警规则」,以便「异常时第一时间介入」。

## 验收标准(AC)

- [ ] AC1: Given 已有启用规则,When 指标越过阈值,Then 生成"未处理"告警记录
- [ ] AC2: 告警规则列表界面友好,加载较快
- [ ] AC3: 用户可以方便地对规则进行批量操作

## 范围

**做**:规则增删改查、启停、阈值校验、批量启停

## 功能细节

### 关键字段

| 字段 | 类型 | 约束 |
|---|---|---|
| id | BIGINT PRIMARY KEY AUTO_INCREMENT | 主键 |
| 规则名称 | VARCHAR(64) | 规则的名称 |
| 阈值 | 数值 | 告警触发阈值 |
| 状态 | 枚举 | 启用/停用 |

### 交互动作

- 「新建规则」→ 打开 drawer 表单,提交成功 toast + 列表刷新
- 列表行内「启停」开关即时生效

### 状态与异常

- 状态机:草稿 → 启用 ⇄ 停用
