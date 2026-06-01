# 设计 Token 完整规范

## 来源

蒸馏自竞品调研（OpenRouter / Together AI / Replicate / Artificial Analysis）+ 某 SaaS 平台 项目 30+ 轮迭代。完整 CSS 变量见 [`../templates/tokens.css`](../templates/tokens.css)。

## 色彩

### 主品牌色

```css
--color-primary: #E1251B;          /* 品牌红 · 主 CTA */
--color-primary-hover: #C31B12;
--color-primary-bg: #FEF2F1;       /* 弱底（chip / selected） */
```

### 通用语义色（4 态）

```css
--color-success: #10B981;  --color-success-bg: #ECFDF5;
--color-warn:    #F59E0B;  --color-warn-bg:    #FFFBEB;
--color-danger:  #EF4444;  --color-danger-bg:  #FEF2F2;
--color-info:    #3B82F6;  --color-info-bg:    #EFF6FF;
```

### 状态机色（业务专用 5 态 endpoint）

| token | 用途 |
|---|---|
| `--status-pending-eval`（灰 #9CA3AF）| 待评测 |
| `--status-evaluating`（蓝 #3B82F6）| 评测中 |
| `--status-pending-approval`（橙 #F59E0B）| 待审批 |
| `--status-online`（绿 #10B981）| 已上架 |
| `--status-rejected`（红 #EF4444）| 已驳回 |

每个状态都有对应 `*-bg` 弱色背景（10% opacity）。

### 灰阶 7 级

```css
--color-text-primary:   #111827;
--color-text-secondary: #6B7280;
--color-text-tertiary:  #9CA3AF;
--color-bg:             #FFFFFF;
--color-bg-page:        #F9FAFB;
--color-bg-elevated:    #F9FAFB;
--color-border:         #E5E7EB;
--color-border-strong:  #D1D5DB;
```

### 能力域 chip（用于跨域标识 · 5 色）

```css
--domain-A: #A855F7;   /* 紫 · A 域 */
--domain-B: #F59E0B;   /* 琥珀 · B 域 */
--domain-C: #0EA5E9;   /* 蓝 · C 域 */
--domain-D: #F43F5E;   /* 玫红 · D 域 */
--domain-X: #64748B;   /* 灰 · 平台共用 */
```

## 字体

```css
--font-sans: 'PingFang SC', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
--font-mono: 'JetBrains Mono', 'SF Mono', Menlo, monospace;
```

**数字必须用 `tabular-nums`** （等宽对齐表格价格 / token 数 / 时长）：

```css
.tabular { font-variant-numeric: tabular-nums; }
```

## 字号梯度 8 级

| Token | Size / Line | 用途 |
|---|---|---|
| `--text-xs` | 12 / 16 | 辅助标签 / footnote / breadcrumb |
| `--text-sm` | 13 / 20 | 表格内容 / 卡片次字段 |
| `--text-base` | 14 / 22 | 正文 / 卡片主字段 |
| `--text-lg` | 16 / 24 | 卡片标题 / section header |
| `--text-xl` | 18 / 28 | 页面 section 标题 |
| `--text-2xl` | 22 / 32 | 页面 H1 |
| `--text-3xl` | 28 / 36 | dashboard 大数字（KPI 数字） |
| `--text-4xl` | 36 / 44 | 首页 Hero 大数字 |

## 圆角

```css
--radius-sm:   4px;   /* chip / badge / 小按钮 */
--radius-md:   6px;   /* 输入框 / 标准按钮 */
--radius-lg:   8px;   /* 卡片 / 模态框 */
--radius-xl:  12px;   /* dashboard 大卡 */
--radius-pill: 999px; /* 圆形徽章 */
```

## 阴影

```css
--shadow-sm: 0 1px 2px rgba(0,0,0,.04);
--shadow-md: 0 4px 6px rgba(0,0,0,.05);
--shadow-lg: 0 10px 20px rgba(0,0,0,.08);
--shadow-card-hover: 0 6px 14px -4px rgba(15,23,42,.10);
```

## 间距栅格

12 列 grid · 最大宽度 1440px。

```css
--space-1:  4px;
--space-2:  8px;
--space-3:  12px;
--space-4:  16px;
--space-5:  20px;
--space-6:  24px;
--space-8:  32px;
--space-10: 40px;
--space-12: 48px;
```

## Chrome 尺寸

```css
--sidebar-width:       224px;
--sidebar-collapsed:    64px;
--topbar-height:        56px;
--row-h-compact:        36px;
--row-h-default:        40px;
--row-h-comfortable:    48px;
```

## 价格 / 数字 / 单位规范

- **价格主单位**：`¥/M tokens`（与 OpenRouter / Together 行业标准对齐）
- **价格副单位**：tooltip 折算 `元/千 tokens`（兼容历史）
- **Token 数缩写**：`12.3K / 4.5M / 1.2B`
- **延迟显示**：TTFT `380 ms` / 总响应 `2.1 s` / P50 P95 用 chip 标记
- **吞吐**：`145 tokens/s`（Median TPS）+ mini bar 横向对比

## 状态徽章风格（重要）

**禁止用纯色实心 badge**（表格列充满高饱和色会炫晕）。所有状态徽章统一用 `● 圆点 + 文字 + 弱色背景` 三件套：

```html
<span class="badge online">● 已上架</span>
<span class="badge evaluating">● 评测中</span>
```

CSS：

```css
.badge {
  display: inline-flex; align-items: center; gap: 4px;
  padding: 2px 8px;
  font-size: var(--text-xs);
  border-radius: var(--radius-pill);
  font-weight: 500;
}
.badge::before { content: '●'; font-size: 8px; }
.badge.online           { color: var(--status-online);           background: var(--status-online-bg); }
.badge.evaluating       { color: var(--status-evaluating);       background: var(--status-evaluating-bg); }
.badge.pending-approval { color: var(--status-pending-approval); background: var(--status-pending-approval-bg); }
.badge.pending-eval     { color: var(--status-pending-eval);     background: var(--status-pending-eval-bg); }
.badge.rejected         { color: var(--status-rejected);         background: var(--status-rejected-bg); }
```

## 卡片密度（实战经验值）

| 场景 | 行高 | padding | 备注 |
|---|---|---|---|
| 高密度表格（运营端列表）| 40px | — | 仿 OpenRouter 表格紧凑风格 |
| 中密度表格（详情子表）| 48px | — | endpoint 横评表 |
| 卡片网格（模型 / 评测集）| — | 16px | 仿 Together 8 字段紧凑 |
| 仪表盘大卡（KPI）| — | 24px | 仿 OpenRouter dashboard |
| 列内 chip / badge | 24px | 4-8px | 圆点 + 文字 + 弱色底 |

---

## 配色方案（5 套 · 多品牌支持 🆕 v1.9）

v1 实战中支持 5 套主色方案，通过 `body.scheme-{red|blue|orange|green|purple}` 切换。每套均提供 light/dark 双主题。

```css
/* 品牌红（v1 默认 · 品牌主色） */
body.scheme-red.light    { --primary: #E1251B; --primary-soft: #FEE2E0; --primary-hover: #B81E15; }
body.scheme-red.dark     { --primary: #EF4444; --primary-soft: rgba(239,68,68,.20); --primary-hover: #F87171; }

/* 蓝色（默认模板 · 通用 SaaS） */
body.scheme-blue.light   { --primary: #2563EB; --primary-soft: #dbeafe; --primary-hover: #1d4ed8; }
body.scheme-blue.dark    { --primary: #3b82f6; --primary-soft: rgba(59,130,246,.18); --primary-hover: #60a5fa; }

/* 橙红（v0.2 历史兼容） */
body.scheme-orange.light { --primary: #F26B2B; --primary-soft: #FEE5D6; --primary-hover: #D9531C; }
body.scheme-orange.dark  { --primary: #F97316; --primary-soft: rgba(249,115,22,.20); --primary-hover: #FB923C; }

/* 绿色（华为云风格） */
body.scheme-green.light  { --primary: #059669; --primary-soft: #d1fae5; --primary-hover: #047857; }
body.scheme-green.dark   { --primary: #10b981; --primary-soft: rgba(16,185,129,.18); --primary-hover: #34d399; }

/* 紫色（创意 / 内容平台） */
body.scheme-purple.light { --primary: #7c3aed; --primary-soft: #ede9fe; --primary-hover: #6d28d9; }
body.scheme-purple.dark  { --primary: #a78bfa; --primary-soft: rgba(167,139,250,.18); --primary-hover: #c4b5fd; }
```

**关键原则**：
- 5 套 scheme 与 light/dark 是**正交**两维度（5 × 2 = 10 种主题组合）
- 切换器组件见 [`component-patterns.md` §26 ThemeSwitcher](component-patterns.md)
- 项目主色选择见 SKILL.md §0 决策方法
- 命名约定：`--primary` / `--primary-soft` / `--primary-hover` 三件套，避免硬编码具体色值

## 明暗双主题（完整 base 变量 🆕 v1.9）

`body.light` / `body.dark` 切换基础变量。dark 不是简单"反色"，而是参考 GitHub / Linear 暗色调校的色阶。

```css
body.light {
  --bg:           #f4f6fb;
  --surface:      #ffffff;
  --surface-2:    #f1f5f9;   /* 轻底（卡片次层）*/
  --surface-3:    #e2e8f0;   /* 弱底（hover）*/
  --border:       #e5e9f0;
  --border-strong: #cbd5e1;
  --text:         #0f172a;
  --text-2:       #475569;   /* 次要文字 */
  --text-3:       #94a3b8;   /* 三级文字 / placeholder */
  --shadow-sm: 0 1px 2px rgba(0,0,0,.04);
  --shadow-md: 0 4px 12px rgba(15,23,42,.08);
  --shadow-lg: 0 12px 32px rgba(15,23,42,.12);
}

body.dark {
  --bg:           #0a0e1a;
  --surface:      #131826;
  --surface-2:    #1c2333;
  --surface-3:    #232c42;
  --border:       #232c42;
  --border-strong: #344056;
  --text:         #f1f5f9;
  --text-2:       #94a3b8;
  --text-3:       #64748b;
  --shadow-sm: 0 1px 2px rgba(0,0,0,.3);
  --shadow-md: 0 4px 12px rgba(0,0,0,.45);
  --shadow-lg: 0 12px 32px rgba(0,0,0,.55);
}
```

**关键原则**：
- shadow 在 dark 模式下数值显著加深（透明度 0.04 → 0.3），否则深底上看不见阴影
- text-2 / text-3 在两个主题下保持相对对比度（约 4.5:1 / 3:1）
- 状态色（success/danger/warning）在 dark 下用更亮的版本（如 `#34d399` 代替 `#10b981`），背景用 rgba alpha 而非纯色

## 界面密度（comfy / compact 🆕 v1.9）

通过 `body.density-{comfy|compact}` 切换。**新需求默认 comfy**，仅运营批量操作类页面（评测任务台 / 工单池）用 compact。

```css
body.density-comfy   { --pad-y: 14px; --card-pad: 22px; --row-pad: 14px; }
body.density-compact { --pad-y:  8px; --card-pad: 16px; --row-pad: 10px; }
body:not([class*="density-"]) { --pad-y: 14px; --card-pad: 22px; --row-pad: 14px; }
```

⚠️ **使用规则**：所有 `padding-y` / `card-padding` / `row-padding` 必须使用变量，不可硬编码数值；这样 density 切换时所有页面同步生效。

**Anti-pattern**：直接 `padding: 14px 22px;` ❌ → 改为 `padding: var(--pad-y) var(--card-pad);` ✅

## 评级徽章色（ABCDE 5 级 🆕 v1.9）

适用于供应商评级、模型评分、SLA 评级等"5 级评分系统"。

```css
--rating-A: #10b981; --rating-A-bg: #d1fae5;   /* 绿 · 优秀 ≥ 90 */
--rating-B: #2563eb; --rating-B-bg: #dbeafe;   /* 蓝 · 良好 80-89 */
--rating-C: #f59e0b; --rating-C-bg: #fef3c7;   /* 黄 · 一般 70-79 */
--rating-D: #f97316; --rating-D-bg: #ffedd5;   /* 橙 · 差 60-69 */
--rating-E: #dc2626; --rating-E-bg: #fee2e2;   /* 红 · 不合格 < 60 */
```

**为什么不用语义色（success/warning/danger）？** 因为 A-E 是定级而非"成功/失败"语义，且 5 级需要 5 色，语义色只有 4 个不够分。完整 RatingBadge 组件见 [`component-patterns.md` §21](component-patterns.md)。

## 能力域色（扩展为 A-E + X · 6 域 🆕 v1.9）

原 5 色扩展为 6 色（新增 E 域）：

```css
--dom-A: #a855f7; --dom-A-bg: #f5e6ff;   /* 紫 · A 域 */
--dom-B: #f59e0b; --dom-B-bg: #fef3c7;   /* 琥珀 · B 域 */
--dom-C: #0ea5e9; --dom-C-bg: #dbeafe;   /* 蓝 · C 域 */
--dom-D: #f43f5e; --dom-D-bg: #ffe4e6;   /* 玫红 · D 域 */
--dom-E: #10b981; --dom-E-bg: #d1fae5;   /* 绿 · E 域 🆕 */
--dom-X: #64748b; --dom-X-bg: #f1f5f9;   /* 灰 · 平台共用 */
```

用法：能力域 chip / 标签 / 分组色块。**与评级色避免在同一页面混用**（A 域紫 vs A 级绿易混淆）。

## 服务健康灯色（3 态 🆕 v1.9）

服务监控 / 健康指示器统一 3 态（适用 service status / pipeline health / endpoint heartbeat 等）。

```css
--svc-healthy:  #10b981;   /* 绿 · 全部健康 */
--svc-degraded: #f59e0b;   /* 橙 · 部分降级 */
--svc-down:     #dc2626;   /* 红 · 故障 */
```

**聚合规则**：任一 down → 整体 down；任一 degraded（无 down）→ 整体 degraded；全部 healthy → 整体 healthy。完整 ServiceLamp 组件见 [`component-patterns.md` §24](component-patterns.md)。

## 告警严重度色（P0-P3 4 级 🆕 v1.9）

告警 / 工单 / 事件优先级 4 级统一配色。

| 级别 | 含义 | 主色 |
|---|---|---|
| **P0** | 紧急 · 立即处置 | `var(--danger-fg)` (#dc2626 · 红) |
| **P1** | 严重 · 1h 内 | `#f97316` (橙红 · 介于 P0 红与 P2 黄之间) |
| **P2** | 警告 · 24h 内 | `var(--warning-fg)` (#d97706 · 黄) |
| **P3** | 观察 · 看板留痕 | `var(--text-3)` (#94a3b8 · 灰) |

完整 AlarmCard 组件见 [`component-patterns.md` §23](component-patterns.md)。

## 表格等宽数字（与价格 / 时延对齐）

```css
.tabular { font-variant-numeric: tabular-nums; font-family: var(--font-num); }
```

`--font-num` 优先 `DM Sans` / `JetBrains Mono`（自带等宽数字），fallback `Noto Sans SC`。所有金额 / token 数 / 时延 / 评分必须用 `.tabular` class，否则不同位数对齐错位。
