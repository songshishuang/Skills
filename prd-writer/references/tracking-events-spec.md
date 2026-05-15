# 埋点规范（AI 客服产品）

> 沿用宋世双 V0.5 PRD 的三段结构（埋点说明 → 埋点看板 → 埋点上报设置）+ AI 产品特化字段。PRD 第七章产出可直接交付 BI。

---

## 一、章节结构（PRD 第七章模板）

```
七、数据埋点
  1、埋点说明              ← 描述目的与价值
  2、埋点看板              ← 行为看板 + 数据看板
  3、埋点上报设置          ← 事件清单（核心交付物）
```

---

## 二、事件清单表头（V0.5 标准 8 列）

| 列名 | 类型 | 说明 | 示例 |
|---|---|---|---|
| 事件名称 | 中文 | 给文档读者看 | AI 推荐采纳 |
| 事件描述 | 中文 | 一句话说明业务含义 | 客服直接点「发送」按钮（未编辑） |
| 上报时机 | 中文 | 精确到 UI/服务端动作 | 点击「发送」按钮 |
| 事件 ID | 英文 snake_case | 给代码用 | `ai_reply_send` |
| 扩展字段 | 字段列表 | 业务字段（不含公共字段） | trace_id / no_edit=true |
| 页面路径 | 中文导航路径 | "/" 表示嵌套 | 客服工作台-私聊窗口 |
| 页面名称 | 中文 | 页面或模块名 | 工作台-Copilot |
| 备注 | 自由 | 截图 / 特殊说明 / 关联事件 | 自动入 BadCase 池 |

### 事件 ID 命名约定

格式：`{module}_{object}_{action}`

- **module**：所属模块（kb / skill / ai_reply / ai_takeover / workbench）
- **object**：操作对象（config / message / recommendation）
- **action**：动作（show / click / save / send / reject / enable / trigger）

示例：
- `ai_reply_show` — AI 推荐回复展示给客服
- `ai_reply_send` — 客服直接发送 AI 推荐
- `kb_config_save` — 知识库配置保存
- `ai_takeover_enable` — 开启 AI 托管
- `ai_fallback_trigger` — 触发兜底

---

## 三、公共字段（每个事件必带，不重复列入扩展字段）

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| event_id | string | ✅ | UUID（埋点条目唯一 ID） |
| timestamp | int64 | ✅ | 毫秒时间戳 |
| user_id | string | ✅ | 操作者 ID（客服 ID / 用户 ID） |
| user_role | string | ✅ | cs / agent / customer / admin |
| project_id | string | ✅ | 所属项目 |
| session_id | string | ⚠️ | 会话场景必填 |
| client | string | ✅ | web / wxwork / mobile / android / ios |
| env | string | ✅ | prod / pre / dev |
| ab_group | string | ⚠️ | A/B 分流标识 |

---

## 四、AI 场景特定字段

任何与 LLM 调用相关的事件，扩展字段需包含：

| 字段 | 类型 | 说明 |
|---|---|---|
| trace_id | string | 全链路追踪 ID，可反查 prompt / output |
| model | string | 模型标识，含版本号（gpt-4o-mini-2024-07-18） |
| skill_id | string | 调用的技能 |
| skill_version | string | 技能版本号 |
| prompt_version | string | 系统提示词版本 |
| latency_ms | int | 端到端时延 |
| token_in | int | 输入 token 数 |
| token_out | int | 输出 token 数 |
| cost_estimate | float | 估算成本（人民币元） |
| confidence | float | 0~1，模型置信度 |
| tool_calls | array | 调用的工具列表 |
| kb_hits | int | 命中的 KB 条数 |
| fallback_triggered | bool | 是否触发兜底 |

---

## 五、AI 客服核心事件清单（V0.5 实际使用版）

> 直接拷贝到 PRD「3、埋点上报设置」表格中，按本期需求增删。

| # | 事件名称 | 事件描述 | 上报时机 | 事件 ID | 扩展字段 | 页面路径 | 页面名称 |
|---|---|---|---|---|---|---|---|
| E1 | 知识库保存 | 运营保存 KB 配置 | 点击「保存」 | `kb_config_save` | kb_id / chunk_count / changed_fields | 面客端-智能客服-知识库 | 知识库管理 |
| E2 | KB 单条新增 | 单条 chunk 新增成功 | 保存成功 | `kb_chunk_add` | kb_id / chunk_id / source | 面客端-智能客服-知识库 | 知识库管理 |
| E3 | 技能开关 | 运营切换技能 | 切换开关 | `skill_toggle` | skill_id / from / to | 面客端-智能客服-技能配置 | 技能配置 |
| E4 | 技能配置保存 | 运营保存技能配置 | 点击「保存」 | `skill_config_save` | skill_id / version / enabled_tools | 面客端-智能客服-技能配置 | 技能配置 |
| E5 | AI 推荐展示 | 客服收到 AI 推荐 | 模型输出完成 | `ai_reply_show` | trace_id + AI 必带字段 + kb_hits | 客服工作台-私聊窗口 | 工作台-Copilot |
| E6 | AI 推荐采纳 | 客服直接发送 | 点击「发送」（未编辑） | `ai_reply_send` | trace_id / no_edit=true | 客服工作台-私聊窗口 | 工作台-Copilot |
| E7 | AI 推荐编辑后发送 | 客服编辑后发送 | 点击「发送」（有编辑） | `ai_reply_edit_send` | trace_id / edit_distance / final_text_length | 客服工作台-私聊窗口 | 工作台-Copilot |
| E8 | AI 推荐拒纳 | 客服不采纳重写 | 关闭推荐 + 自己输入 | `ai_reply_reject` | trace_id / reject_reason / final_text | 客服工作台-私聊窗口 | 工作台-Copilot |
| E9 | AI 依据查看 | 客服点查看依据 | 点击「查看推荐依据」 | `ai_evidence_view` | trace_id / evidence_count / clicked_evidence_id | 客服工作台-私聊窗口 | 工作台-Copilot |
| E10 | AI 托管开启 | 开启 AI 托管 | 切换至开 | `ai_takeover_enable` | scope / time_segment_id | 客服工作台-顶部 / 面客端 | 工作台 / AI 托管配置 |
| E11 | AI 托管关闭 | 关闭 AI 托管 | 切换至关 | `ai_takeover_disable` | scope / reason | 客服工作台-顶部 | 工作台 |
| E12 | AI 兜底触发 | 兜底/转人工 | 兜底分支命中 | `ai_fallback_trigger` | trace_id / reason | 服务端 | — |
| E13 | 非工作时间自动回复 | AI 自动回应 | AI 完成回复发送 | `non_business_hour_reply` | time_strategy_id / response_time | 服务端 | — |
| E14 | 用户点踩 | 用户点踩消息 | 企微会话点踩 | `user_downvote` | trace_id / message_id | 企微-会话 | 用户端 |
| E15 | 转人工 | AI/用户/兜底触发转人工 | 转人工动作执行 | `transfer_to_agent` | trace_id / reason / pending_seconds | 客服工作台 / 服务端 | 工作台 |
| E16 | 商品卡片展示 | 商品卡片在会话展示 | UI 渲染 | `goods_card_show` | sku_id / source | 客服工作台-私聊窗口 | 工作台-Copilot |
| E17 | 转链授权失败 | 商品授权校验未通过 | 校验返回失败 | `goods_link_invalid` | sku_id / fail_reason | 客服工作台 | 商品池 |
| E18 | 页签排序 | 客服调整工作台页签 | 应用设置 | `workbench_tabs_reorder` | tabs_order | 客服工作台-自定义工作台 | 自定义工作台 |

---

## 六、数据看板模板

### Dashboard 1：AI 采纳率漏斗

```sql
SELECT
  date(timestamp) as dt,
  count(*) FILTER (WHERE event_id='ai_reply_show') AS shown,
  count(*) FILTER (WHERE event_id='ai_reply_send') AS adopted,
  count(*) FILTER (WHERE event_id='ai_reply_edit_send') AS edited,
  count(*) FILTER (WHERE event_id='ai_reply_reject') AS rejected,
  adopted::float / NULLIF(shown,0) AS adopt_rate,
  edited::float / NULLIF(shown,0) AS edit_rate
FROM events
WHERE event_id IN ('ai_reply_show','ai_reply_send','ai_reply_edit_send','ai_reply_reject')
GROUP BY dt;
```

### Dashboard 2：兜底分布

```sql
SELECT reason, count(*) FROM events
WHERE event_id = 'ai_fallback_trigger'
GROUP BY reason ORDER BY 2 DESC;
```

### Dashboard 3：时延分布（P50 / P90 / P99）

```sql
SELECT
  percentile_cont(0.5) WITHIN GROUP (ORDER BY (extension->>'latency_ms')::int) AS p50,
  percentile_cont(0.9) WITHIN GROUP (ORDER BY (extension->>'latency_ms')::int) AS p90,
  percentile_cont(0.99) WITHIN GROUP (ORDER BY (extension->>'latency_ms')::int) AS p99
FROM events WHERE event_id='ai_reply_show';
```

### Dashboard 4：成本

```sql
SELECT date(timestamp) AS dt,
       sum((extension->>'cost_estimate')::numeric) AS cost_rmb,
       sum((extension->>'token_in')::int + (extension->>'token_out')::int) AS tokens
FROM events WHERE event_id='ai_reply_show'
GROUP BY dt;
```

---

## 七、告警阈值

| 指标 | 阈值 | 告警渠道 | 严重度 |
|---|---|---|---|
| 错误率 > 2%（5min） | 实时 | 企微 + 短信 | P0 |
| 兜底率 > 10%（15min） | 滚动 | 企微 | P1 |
| P99 延迟 > 5s（15min） | 滚动 | 企微 | P1 |
| 采纳率 < 30%（24h） | 日 | 企微 | P2 |
| 日 token 用量 > 预算 1.5x | 实时 | 企微 + 短信 | P0 |

---

## 八、交付物（每次 PRD 配套）

1. **埋点事件表 CSV**：按本规范的 8 列结构产出，给 BI 建表
2. **SDK 接入示例**：前端 / 服务端各 1 份代码片段
3. **验证 SOP**：QA 用于上线前后核对每个事件正确上报

CSV 示例参考 `templates/tracking-table-template.csv`。
