---
story_id: ST-0403
type: lite
title: 告警时间显示修正
status: draft
source: ../PRD-v0.4.md#4.2.4
spec_test: pending
---

# ST-0403 告警时间显示修正(lite)

## 改什么

告警历史列表(ST-0402)的「触发时间」列当前显示 UTC 时间,改为北京时间(UTC+8)。详情 drawer 内的触发时间同步修正。时间格式统一为 `YYYY-MM-DD HH:mm:ss`。

## AC

- [ ] AC1: 列表「触发时间」列显示北京时间,与数据库 UTC 原值相差 +8 小时
- [ ] AC2: 详情 drawer 触发时间与列表同一条记录显示一致
- [ ] AC3: 时间格式为 `YYYY-MM-DD HH:mm:ss`(不带时区后缀)
