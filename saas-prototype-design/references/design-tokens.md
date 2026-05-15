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
