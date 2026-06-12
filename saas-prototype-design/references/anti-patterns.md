# 反模式与真实返工案例

每条都来自 实战项目 30+ 轮迭代的真实返工。**避坑就是节省时间**。

---

## 反模式 1：PM 规划性内容混入原型 UI（拆 4 子条 · v2.0）

> **共同根因**：原型是给业务方 / 客户的最终交付物，**PM 视角的规划性表达**（版本号 / 范围说明 / 实施细节 / 自我介绍）让用户困惑。
> **共同检测**：全局排查脚本统一在 [`scripts/check-residual.sh`](../scripts/check-residual.sh) 维护，每次提交前必跑。

### 反模式 1a · PM 规划性术语混入

❌ `<span>L2 行业集 · v0.1 主战场</span>` / `<div>L1 标准集 · v0.x 启用 · 本期仅入库浏览</div>` / `<div>④-⑧ 高阶节点（远期）</div>`

**问题**：「主战场 / 本期 / v0.x / 远期 / MVP / 高阶节点」等 PM 视角术语让客户困惑 —— 这些是 PRD / roadmap 才有的词。

✅ 修正：`<span>L2 行业场景集</span>` / `<div>L1 标准集 · 仅入库浏览，暂不参与评测</div>` —— 直接陈述事实，不带版本视角。

---

### 反模式 1b · 版本号 banner（最高频踩坑 · 至 v1.8 已踩 4 次）

❌ 任何形如以下文案**全部禁止进入 UI**：

- 醒目横幅 `<div class="v01-banner">v0.1 评测范围说明：本期上线 L2 + 性能集 ...</div>`
- 醒目横幅「🔒 一期范围：仅启用 G1（4 项）。G2-G5 在 v1.0 启用」
- 折叠区 `<details>📋 完整 P5.7 还有 4 组 21 项 · v1.0 启用</details>`
- KPI 副标 / 卡片注脚「v0.1 仅做 D1 基础能力 + D2 工程性能」
- 表格行底「D3-D7 v1.0 启用」/ 字段值「v0.1 不评测多模态能力」
- toast「该功能将在 v1.0 启用」

**问题**：PM 担心评审人问"为什么没有 X"，想用 banner 提前解释 —— **评审人能从功能存在性判断范围**，banner 反而显得"心虚" + 暴露半成品。版本范围说明的正确位置是 PRD / release notes / roadmap，**不是产品 UI**。

| ❌ 错误 | ✅ 替代 |
|---|---|
| 范围 banner | **删除整个 banner** |
| `<details>` 折叠展示完整规范 | **删除**，需要给评审看完整规范 → 放规划文档里链接 |
| 字段值「v0.1 不评测多模态」 | 改「暂不支持」/ 空 / `—` |
| KPI 副标「v0.1 仅展示 D1+D2」 | 改中性叙述「D1 基础能力 + D2 工程性能 · 自动跑分」 |
| toast「v1.0 启用」 | 改「该功能即将上线」（去版本号） |

---

### 反模式 1c · 新旧字段对照 / 现有系统术语映射

❌ 研发期为打通现有系统，在 UI 里加蓝色框「📘 与现有系统术语对齐：chatcompletions = chat 无 stream / functioncall = tool_use / opensisdk = openai 协议 ...」

**问题**：这是给开发看的迁移辅助，不是给用户看的功能说明。客户看到「术语对齐」会以为系统不稳定。

✅ 修正：**对照表挪到迁移文档**（如 `docs/migration/field-mapping.md`），UI 上只显示**新字段名 + 简短中文释义**（如 `<label>模型类型</label>`，不要 "📘 与现有系统术语对齐" 蓝框）。

---

### 反模式 1d · page-header-desc 副标题塞 PM 自我介绍

❌ `<div class="page-header-desc">全平台模型主体维护 · 1 个模型 ↔ N 个 Endpoint · 用于评测、上架、定价、监控的统一模型字典</div>`

❌ 列表分组顶部塞解说「<span class="text-xs">3 个示例 · 右上角开关控制启用状态 · 点击卡片查看详情</span>」

**问题**：这是 PM / 产品架构师对自己理解的描述，不是面向使用者的功能说明。**用户打开页面已经从菜单进来，不需要被告知"这是什么页面"**。卡片视觉本身已经表达了交互（不需要"点击卡片查看详情"）。

✅ 修正：
```html
<h1>模型管理</h1>     <!-- 直接 OK，不需要副标 -->

<!-- 列表分组顶部不要解说文字 -->
<div class="layer-group-header">
  <span class="layer-chip">L2</span> 行业场景集
</div>
```

极端情况留 1 句解释，否则只留标题。

### 反模式 1e · 评审/研发向注解混入产品 UI（v2.1 · MaaS 监测踩 3 次）

❌ 策略卡底部塞规则口径声明：「**状态判定（监测列表同口径）**：严重 = VETO 命中 / D4<85 / 域漂移≤−15 / 失败率≥5% …」

❌ 配置项旁塞成本估算注解：「≈ 75 次 case 运行 / 天 · ~60K tokens / 天 / endpoint」

❌ 数据机制/血缘说明：「QPS / 成功率 / TTFT / 吞吐全量采集 · 零 token 成本」「监测列表详情**同源只读**」「写入 **monitor_schedule_config 单一真相源**（契约 §5.1）」

❌ 设计权衡说明：「窗口越小越实时、存储与计算成本越高」

❌ **PageHeader desc 写成页面使用说明书**（第 3 次 · 2026-06-12）：「已上线 endpoint 的实时监测 · 页签 = 筛选条件（VETO 命中 / 失败率>1% 近15m / 漂移>10分）· 命中实时派生、恢复即消失 · 全局态势请看监控看板 · 点「详情」下钻三评测域」——把页签机制、派生口径、跨页导览、交互指引串成一句副标题。「已上线 endpoint 的实时监测」这种**范围注解**同属此类（回答的是"本页数据范围怎么圈的"，不是用户任务所需）。

**问题**：这些是给**评审人 / 后端研发**看的注解（判定规则口径、token 成本测算、数据同步机制、字段真相源），不是产品会展示给运营用户的文案。本质与 1a 同根——把"我为什么这么设计"写进了 UI，但形态更隐蔽：它们看起来像"专业的产品说明"，实际用户既看不懂也不需要（运营不关心契约编号和真相源，只关心策略值本身）。

**识别口径**：一段 UI 文案若回答的是「**这个数怎么算的 / 数据从哪同步 / 这样设计花多少成本**」→ 评审注解，删；若回答「**这个页怎么用 / 页签是什么机制 / 点哪去哪看什么 / 本页范围怎么圈**」→ 页面说明书，也是评审注解，删（真实产品的交互靠自明性——页签 label、按钮文案、空态、tooltip——不靠页头印说明书）；若回答「**这个字段填什么 / 当前状态是什么**」→ 产品文案，留。

✅ 修正：
- 规则口径 / 成本测算 / 数据血缘 / 页签机制与导览说明 → **降级为代码注释**（不渲染，给维护者）或写进 PRD §4.2 / story 卡片（给评审与研发），UI 只留策略值本身（「核心 2 case 每 6 小时 · 全量 17 case 每 24 小时」）
- **PageHeader 的 desc 槽存在 ≠ 必须填**：填也只能填用户视角的一句话价值描述，写不出来就留空——不要拿机制说明凑
- 真实状态信息可留（「上线即在线 · 不可关闭」是产品语义，不是注解）
- 删注解后顺手清关联死代码（本案例：probeCostEstimate 函数 + policyCellFoot 样式随 foot 行一起删）

**为什么会反复踩**：注解是实现/评审过程中"顺手写给自己看"的，第一次清理容易只删最像 PM 术语的（「契约 §5.1」），留下"看起来专业"的（成本估算、口径声明）；第 3 次的形态更隐蔽——它**伪装成页面副标题**，位置"合法"（desc 槽本来就在），内容却是说明书。**清理时按识别口径全页扫（含每个 PageHeader 的 desc），不要逐条凭感觉**。

---

## 反模式 2：能力域 chip 在用户界面出现

### ❌ 错误

```
sidebar
├── A 供应商  ← chip
├── B 评测   ← chip
├── C 商务   ← chip
└── D 风险   ← chip
```

### 问题

A/B/C/D 是规划阶段的能力域编号（架构图视角），用户菜单看的是工作流。

### ✅ 修正

```
sidebar（按工作流分组）
├── 评测工作
├── 评测集管理
├── 供应商管理
├── 风险与监控
└── 商务对账
```

---

<!-- 反模式 3 已迁出 → saas-arch-diagrams/references/anti-patterns.md 反模式 5（v2.x 边界拆分 · 2026-06-01） -->

## 反模式 4：col-span 等宽分配留空白

### ❌ 错误

```
D 域 6 子组，每个 col-span-3：
| D1(1卡) | D2(3卡) | D3(2卡) | D4(2卡) | D5(1卡) | D6(1卡) |
        ↓ 每行 col 加起来 = 18 ≠ 12
```

### 问题

固定 col-span-3 时，1 卡子组下方有大片空白，3 卡子组又被挤窄。

### ✅ 修正

```
按内容动态分配 col-span，使每行加起来 = 12：
行 1: D1(col-3) + D2(col-9 inner-3) = 12
行 2: D3(col-3) + D4(col-3) + D5(col-3) + D6(col-3) = 12
```

---

## 反模式 5：合并多个模块为「X-Y 节点」

### ❌ 错误

```
B2 节点执行
├── ① 连通性
├── ② 性能评测
├── ③ 能力评测
└── ④-⑧ 高阶节点（5 合 1）  ← ❌ 省略
```

### 问题

为了视觉省事合并 5 个独立功能为 1 卡片，违反内容逻辑。读图者无法获取真实模块数。

### ✅ 修正

8 节点必须独立 8 卡：① / ② / ③ / ④ / ⑤ / ⑥ / ⑦ / ⑧。

---

## 反模式 6：Agent 复制覆盖丢失迭代

### 真实案例

实战项目中 Agent C 任务是「复制 v1 文件到 v0.1 + 改 brand」，结果直接覆盖了之前 3 轮迭代精修的 `v0.1/eval-sets.html`（启用 toggle / 描述 / 版本历史 / 模型基线 3 sub-tab 等都丢了）。

### 问题

Agent 收到「复制 v1 到 v0.1」指令时不知道 v0.1 文件已经迭代过，直接 cp 覆盖。

### ✅ 修正（3 道防线）

1. **大改前自动备份**：`bash scripts/snapshot.sh <file>` → `prototypes/.history/file.{YYYYMMDD-HHMM}.html`
2. **Agent prompt 强制要求**「先读原文件，列保留 / 修改 / 删除清单后再改」
3. **HTML 头部加 prototype-meta 注释**记录关键功能 checklist，Agent 必须保留

详见 [`history-protection.md`](history-protection.md)。

---

## 反模式 7：删功能时文案残留

### 真实案例

#### 案例 A：删功能后按钮文案孤立

「Step 3 Metric 配置」删了，但 Step 2 的「下一步：Metric 配置」按钮文案没改，且页面顶部「v0.1 · 4 步向导」描述也没同步。

#### 案例 B：Tab 标签括号数字 vs 内部节点数错位（endpoint-management 真实返工）

```html
<!-- Tab 标签写「状态机历史（4）」 -->
<div class="tab" data-tab-target="ep360-state">状态机历史（4）</div>

<!-- 但内部 timeline 实际渲染了 5 个节点 -->
<div class="timeline">
  <div class="timeline-node">① endpoint 创建 ...</div>
  <div class="timeline-node">② 自动发起准入评测 ...</div>
  <div class="timeline-node">③ 体检报告生成完毕 ...</div>
  <div class="timeline-node online">④ 运营终审通过 ...</div>
  <div class="timeline-node warn">⑤ 资源升档 · 触发二次复评 ...</div>
</div>
```

后来加了一个「资源升档」节点，但 tab 括号里的 4 没改成 5。**类似的高频陷阱**：「关联评测（5）」「资源变更（3）」这种 `(N)` 都极易和实际内容脱节。

### ✅ 修正

每次删除模块 / 增加节点后必查的「文案残留 grep」清单：

```bash
# 检查删除后的孤立引用
grep -rn "Step 3 Metric\|Metric 配置\|3 步向导\|4 步向导" *.html

# 检查 tab 括号数字 vs 实际节点（Tab 标签 (N) 校验）
grep -rnE '（[0-9]+）|（[0-9]+ ' *.html
# 然后对每个 (N) 手动数实际节点数

# 检查 KPI / tab count 数字
grep -rn 'tab-count\|kpi-value tabular' *.html

# 检查 mock 数据残留
grep -rn 'data-set=\|data-panel=\|data-step=' *.html
```

### 校验法

凡是「Tab 标签 (N)」「KPI 副标 X+Y+Z=主值」「页面顶部 N 步向导」这种**有量词的文案**，每次内容增删必须重数一次。最好把数字写成动态注释 `<!-- 节点数: 5 -->`，让 grep 能对照。

---

## 反模式 8：Tab 切换内容只默认 tab 有

### 真实案例

审核类页面顶部有「待审 / 已通过 / 已驳回 / 补材料」4 tab，但只「待审」tab 有内容，其他点切换后空白。

### ✅ 修正

**每个 tab 都要有真实 mock 内容**（至少 3-5 行），切换 tab 时切换 `data-tab-content`。

---

## 反模式 9：Tailwind CDN + tokens.css 混搭

### ❌ 错误

```html
<head>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="../v1/assets/tokens.css">
</head>
```

### 问题

Tailwind 的 `bg-white border` 和 tokens.css 的 `.card` 同时存在，类名冲突 + 包体积翻倍 + 颜色对不上。

### ✅ 修正

**二选一**。统一用 tokens.css + chrome.css，禁止再引入 Tailwind CDN。布局类（如 flex / grid）用 inline style 或自定义 utility class。

---

## 反模式 10：「评测集分类」和「评测集管理工具」混在一起

### ❌ 错误

```
B3 评测集（8 模块）
├── 评测集管理 console      ← 工具
├── L1 标准集               ← 数据
├── L2 行业集               ← 数据
├── 性能集                  ← 数据
├── 评测集导入向导          ← 工具
├── 字段映射 + Metric        ← 工具
├── 基础校验 + 试跑          ← 工具
└── 版本管理                ← 工具
```

### ✅ 修正

```
B3 评测集 · 数据资产（按层级）
├── L1 标准 / L2 行业 / L3 黄金 / L4 探针 / L5 对抗 / 性能 / 自定义

B4 评测集 · 管理工具
├── 管理 console / 导入 / 上传 / 字段映射 / 校验 / 版本
```

数据资产 vs 管理工具是两个维度，必须分开。

---

<!-- 反模式 11 已迁出 → saas-arch-diagrams/references/anti-patterns.md 反模式 2（v2.x 边界拆分 · 2026-06-01） -->

<!-- 反模式 12 已迁出 → saas-arch-diagrams/references/anti-patterns.md 反模式 3（v2.x 边界拆分 · 2026-06-01） -->

<!-- 反模式 13 已迁出 → saas-arch-diagrams/references/anti-patterns.md 反模式 4（v2.x 边界拆分 · 2026-06-01） -->

<!-- 反模式 14 已迁出 → saas-arch-diagrams/references/anti-patterns.md 反模式 5（v2.x 边界拆分 · 2026-06-01） -->

<!-- 反模式 15 已迁出 → saas-arch-diagrams/references/anti-patterns.md 反模式 8（v2.x 边界拆分 · 2026-06-01） -->

<!-- 反模式 16 已迁出 → saas-arch-diagrams/references/anti-patterns.md 反模式 10（v2.x 边界拆分 · 2026-06-01） -->

## 反模式 17：filter-bar 用 select 一行 flex 横排

### ❌ 错误

```html
<div style="display:flex; gap:8px;">
  <select>模型族</select>
  <select>供应商</select>
  <select>时间</select>
  <input placeholder="搜索">
</div>
```

### 问题

- 没有 label，用户不知道每个下拉是什么
- 横排不易扫读
- 没有「重置 / 搜索」明确动作

### ✅ 修正

用 `.filter-form` 3 列 grid + label-input 横向 + 底部展开/重置/搜索按钮组。详见 [`component-patterns.md` §5](component-patterns.md)。

---

## 反模式 18：占位 button 没 action

### ❌ 错误

```html
<button class="btn btn-secondary">导出 CSV</button>
<a href="#">查看详情</a>
```

### 问题

点击无反应（"假死"按钮）。

### ✅ 修正

```html
<button class="btn btn-secondary" data-action="toast" data-arg="清单已导出">导出 CSV</button>
<a data-action="drawer-open" data-arg="detail">查看详情</a>
```

所有按钮 / 链接都要有 action（toast / modal / drawer / 跳转）。

---

## 反模式 19：sidebar 完全照搬 v1 全 24 项

### ❌ 错误

v0.1 把 v1 的完整 sidebar 24 项全照搬 + 13 项灰显「v1.0 启用」。

### 问题

灰显项太多反而像「半成品」。

### ✅ 修正

v0.1 sidebar 只列本期实际有的功能（5 分组 11 项），不灰显未实现功能。架构图 / roadmap 才看完整路线。

---

## 反模式 20：CSV 模板下载链接不联动

### ❌ 错误

页面顶部「📥 下载 CSV 模板」按钮 href 写死 `basic.csv`，但用户选了 RAGAS 模板时下载的还是 basic。

### ✅ 修正

JS 监听模板卡片切换，同步更新下载按钮 href + 名称：

```js
templateCard.onclick = () => {
  const tpl = card.dataset.tpl;
  document.getElementById('tpl-download').href = `assets/templates/${tpl}.csv`;
  document.getElementById('tpl-download-name').textContent = `(${tpl})`;
};
```

---

## 反模式 21：Wizard 步数频繁变化（5 → 4 → 3 → 2）

### 真实案例

`admission-eval-upload.html` 经历：
- 初版 5 步（来源 / 拉取 / 字段 / Metric / 入库）
- 删 Metric → 4 步
- 删试跑 → 3 步
- 用户最终：合并 Step1 类型+上传+元信息 → 2 步

每次变更都要重排 stepper、按钮 data-step-target、JS goto-step 逻辑。

### ✅ 修正（前置思考）

设计 wizard **前先确定终态步数**：
- 2-3 步是最舒服的（4+ 步用户会放弃）
- 每步是一个**独立心智块**（上传是 1 个心智，字段映射是 1 个心智，校验+提交是 1 个心智）
- 不要为「校验」「试跑」单独开步骤（合并到提交前）

---

---

## 反模式 22：KPI 副标用占位文案而非真实数据构成

### ❌ 错误

```html
<div class="kpi-card">
  <div class="kpi-label">总用例数</div>
  <div class="kpi-value">540</div>
  <div class="kpi-sub">1 个示例集合 · 540 用例 · L2 行业场景集（v0.1）</div>
</div>

<div class="kpi-card">
  <div class="kpi-label">被引用</div>
  <div class="kpi-value">21</div>
  <div class="kpi-sub">示例数据</div>
</div>
```

### 问题

副标重复 KPI 已显示的数字（"540 用例" × 2），或写"示例数据 / v0.1 / 占位"等无信息文案。读者无法验证数字怎么来的。

### ✅ 修正

副标必须**解释这个数字的构成**——拆维度 / 拆来源 / 拆时间窗：

```html
<div class="kpi-sub">金融场景 · 风控 / 理财 / 信用 / 还款</div>
<div class="kpi-sub">准入 14 · 定期 5 · 临时 2</div>
<div class="kpi-sub">近 30 天 · 同比 +12%</div>
```

校验法：副标的拆分加起来应该 = KPI 主数字（14 + 5 + 2 = 21 ✓）。

---

## 反模式 23：单层列表页加面包屑

### ❌ 错误

```html
<div class="page-header">
  <div class="breadcrumb">运营 / 评测集管理</div>
  <h1>评测集管理</h1>
</div>
```

### 问题

sidebar 已经高亮当前菜单，列表页是 sidebar 直达的一级页面，面包屑「运营 / 评测集管理」纯属冗余 + 信息密度浪费。

### ✅ 修正

**面包屑只在层级 ≥ 2 时使用**——比如「评测集管理 / 金融问答 / v1.3」详情页才需要。一级 list 页直接 h1，不加面包屑：

```html
<div class="page-header">
  <h1>评测集管理</h1>
  <div class="page-header-desc">维护标准集 / 行业集 / 性能集 / 自定义集</div>
</div>
```

---

## 反模式 24：KPI 卡 padding 太松占第 3 行

### ❌ 错误

```css
.kpi-card { padding: 24px; }
.kpi-value { font-size: 28px; }
.kpi-sub { display: block; margin-top: 8px; }  /* 副标另起一行 */
```

效果：4 卡 KPI 占满第 1 屏，下面的 filter-form 和列表都要滚动才能看见。

### 问题

dashboard 巨型卡片（OpenRouter 风格）适合首页 KPI 概览页；**列表页**的顶部 KPI 是辅助信息，应该让位给主体表格。

### ✅ 修正（紧凑型 KPI 规格）

```css
.kpi-card { padding: 12px 16px; }
.kpi-value { font-size: 22px; line-height: 1.2; }
.kpi-row { display: flex; align-items: baseline; gap: 8px; }
.kpi-sub { font-size: 12px; color: var(--color-text-tertiary); }  /* inline 紧贴右侧 */
```

```html
<div class="kpi-card">
  <div class="kpi-label">总用例数</div>
  <div class="kpi-row">
    <span class="kpi-value tabular">540</span>
    <span class="kpi-sub">金融场景 · 风控/理财/信用/还款</span>
  </div>
</div>
```

效果：高度从 ~120px 压到 ~64px，给主表格腾出 60+ px 首屏空间。

---

## 反模式 25：列表卡片字段与上游收集字段不对齐

### ❌ 错误

```html
<!-- 评测集卡片显示「Metric: LLM-Judge」 -->
<div class="set-card-stats">
  <div>用例数 540</div>
  <div>Metric LLM-Judge</div>   <!-- ❌ -->
  <div>引用 21</div>
</div>
```

但是「上传自定义评测集」向导**根本没有 Metric 字段**——Metric 是「模板类型」（basic / RAGAS / LLM-Judge / 沙箱）决定的。

### 问题

1. 用户在卡片上看到的字段，跑回上传向导找不到 → 不知道这字段从哪填、怎么改
2. 上传向导改字段名后，卡片不会自动跟随，长期产生 schema drift
3. 详情页打开看不到一致的「填什么 → 存什么 → 显示什么」链路

### ✅ 修正

**列表卡片字段必须是上游收集字段的子集**，名字也要一致：

```html
<!-- 上传向导收集：name / code / category / template / desc / tags / version-note + 字段映射 -->
<!-- 卡片严格按收集字段展示： -->
<div class="set-card-head">
  <span class="layer-chip layer-L2">L2 行业</span>      <!-- category -->
  <span class="tpl-chip tpl-judge">⚖ LLM-Judge</span>  <!-- template -->
  <span class="tabular">v1.4</span>                     <!-- version -->
</div>
<div class="set-card-title">金融问答 540</div>           <!-- name -->
<div class="set-card-code mono">finance-qa-540</div>     <!-- code -->
<div class="set-card-desc">${desc}</div>                 <!-- desc -->
<div class="set-card-stats">
  <div>用例数 540</div>                                  <!-- cases (CSV 行数) -->
  <div>字段 4</div>                                      <!-- 字段映射数 -->
  <div>引用 21</div>                                     <!-- 派生：被评测引用次数 -->
</div>
<div class="set-card-footer">
  ${tags.map(t => `<span class="badge">${t}</span>`)}    <!-- tags -->
  <span>${creator} · ${updated}</span>                   <!-- 派生：审计字段 -->
</div>
```

### 校验法

设计列表卡片前先回到上游表单截图，列出收集字段清单，**卡片字段必须 ⊆ 收集字段 ∪ 系统派生字段（审计 / 引用数 / 状态）**。如果有第三种字段，就是 schema drift。

### 适用范围

凡是「上游表单收集 → 下游列表展示」的链路都适用：
- 评测集卡片 ↔ 上传向导
- 订单卡片 ↔ 下单表单
- 任务卡片 ↔ 新建任务向导
- 用户卡片 ↔ 注册 / 邀请表单

---

## 反模式 26：filter-form 筛选项不对应真实存在的字段

### ❌ 错误

```html
<!-- 评测集 filter-form 加了「Metric」下拉 -->
<div class="filter-row">
  <label class="filter-label">Metric</label>
  <select>
    <option>全部</option>
    <option>LLM-Judge</option>
    <option>RAGAS</option>
    <option>沙箱</option>
    <option>精确匹配</option>
  </select>
</div>
```

但是数据模型里**根本没有独立的 Metric 列**——Metric 是「模板类型」（template = basic / RAGAS / LLM-Judge / sandbox）派生出来的展示字段。筛选时数据库压根没法按 Metric 查询。

### 问题

1. **数据库无字段可查**：用户筛了一个"Metric=RAGAS"，后端不知道按哪个列过滤
2. **派生字段含义模糊**：用户分不清"Metric"和"模板类型"是不是一个东西
3. **筛选结果不可信**：万一前端 mock 数据强行支持了，真实数据接入后会全空
4. **维护成本**：派生字段定义可能变，筛选选项要跟着改

### ✅ 修正（设计 filter-form 前 3 步检查）

```
1. 这个字段是不是数据模型上的实际列？
   → 是 → 可以筛
   → 否（派生/计算字段） → 不能筛，最多只展示
2. 数据库这个列有索引或低基数枚举吗？
   → 是 → 适合筛
   → 否（全文 / 长 JSON / 大数 distinct value） → 用搜索框，不用下拉
3. 用户场景里这个字段会被用来收窄结果吗？
   → 是 → 入 filter-form
   → 否（只是好奇 / 偶尔看） → 进列表列或详情即可
```

**修正示例**（评测集真实可筛字段）：

| 字段 | 数据模型列 | 是否可筛 |
|---|---|---|
| 集合名 | `name`（全文搜） | ✅ 输入框 |
| 业务场景 | `category`（低基数 enum） | ✅ 下拉 |
| 状态 | `enabled`（boolean） | ✅ 下拉 |
| 创建人 | `creator_id`（高基数） | ✅ 输入框 + 搜索 |
| 更新时间 | `updated_at`（索引） | ✅ 日期范围 |
| ~~Metric~~ | ❌ 派生自 template | ❌ 移除 |
| ~~引用次数~~ | ❌ 派生自 join | ❌ 移除 |

### 校验法

写 filter-form 前，画出**数据模型表结构**（列名 / 类型 / 是否索引），filter 字段必须 ⊆ 表的列。**派生字段不进 filter**。

---

## 反模式 27：segmented tab 与 filter 中 status 字段双入口

### ❌ 错误

```html
<!-- 列表页顶部已有状态分段 tab（6 态） -->
<div class="card">
  <button class="seg-tab active">全部 <span class="cnt">142</span></button>
  <button class="seg-tab">待评测 <span class="cnt">8</span></button>
  <button class="seg-tab">评测中 <span class="cnt">14</span></button>
  <button class="seg-tab">待审批 <span class="cnt">21</span></button>
  <button class="seg-tab">已上架 <span class="cnt">98</span></button>
  <button class="seg-tab">已驳回 <span class="cnt">9</span></button>
</div>

<!-- 同一页 filter-form 又放了一个 status 下拉 -->
<form class="filter-form">
  ...
  <div class="filter-row">
    <label class="filter-label">状态</label>
    <select>
      <option>全部</option>
      <option>pending_eval 待评测</option>
      <option>evaluating 评测中</option>
      <option>pending_approval 待审批</option>
      <option>online 已上架</option>
      <option>rejected 已驳回</option>
    </select>
  </div>
  ...
</form>
```

真实案例：endpoint-management.html v1.0 同时提供了 seg-tab 状态分段 和 filter 中的 status 下拉。

### 问题

1. **语义重复**：两个控件做同一件事（按 status 收窄列表），用户不知道用哪个
2. **交互冲突**：点 seg-tab「评测中」之后，filter 里的 status 应该显示「评测中」还是「全部」？哪个 source of truth？
3. **认知负担**：用户每次都要扫两遍才能确定当前筛选状态
4. **状态同步代码复杂**：要写额外 JS 让两个控件互相联动，反而引入 bug

### ✅ 修正（二选一原则）

| 业务场景 | 推荐入口 | 移除入口 |
|---|---|---|
| 状态是核心维度，列表主要按状态切换看（如 endpoint / 订单 / 工单） | **seg-tab 主入口**（带 count） | filter 中 status 字段移除 |
| 状态只是辅助筛选，与其他多维条件平级组合（如商品库 / 文章库） | **filter 中保留 status** | 不放 seg-tab |

### 校验法

设计一个状态驱动的列表页，先问：「这页用户最常按什么维度切换？」
- 答案是「按 status」→ seg-tab 是主入口，filter 不再放 status
- 答案是「按多维组合（含 status 的多个条件）」→ filter 主入口，不放 seg-tab

**绝对避免**：两个都放。

### 适用范围

凡是「带状态机的资源列表」都适用：endpoint / 工单 / 订单 / 任务 / 评测 run / 审批流。

---

## 反模式 28：modal 容器粗放 stopPropagation 导致内部按钮失效

### ❌ 错误

```html
<div class="modal-mask" id="my-modal" data-action="modal-close" data-arg="my-modal">
  <div class="modal" onclick="event.stopPropagation()">   <!-- 粗放阻止冒泡 -->
    <button data-action="modal-close" data-arg="my-modal">关闭</button>
    <!-- 用户点击「关闭」按钮 → click 冒泡到 modal → stopPropagation 触发 -->
    <!-- → 事件停止，不到 document → chrome.js 全局 listener 收不到 -->
    <!-- → hideModal 永远不执行 → 关闭按钮"看起来不工作" -->
  </div>
</div>
```

### 问题

chrome.js 通过 `document.addEventListener('click', ...)` 在**冒泡阶段**处理所有 `data-action`。当 modal 容器一刀切 `event.stopPropagation()`（原意是"阻止点击 modal 内空白也关闭模态"），副作用是 **modal 内任何 `data-action` 按钮的 click 事件都到不了 document**，包括「关闭」按钮自己。

bug 会在所有用 `<div class="modal" onclick="event.stopPropagation()">` 模式的页面**全部复现**。曾经在 6 个页面（index / endpoint-management / eval-sets / model-management / vendor-audit / vendor-info）的 8 个 modal 同时触发。

### ✅ 修正（最终正确写法 · 二次踩坑后）

**第一次直觉的"精细化"写法是错的**：

```html
<!-- ❌ 仍然有 bug -->
<div class="modal" onclick="if(!event.target.closest('[data-action]'))event.stopPropagation()">
```

为什么仍 bug：`event.target.closest('[data-action]')` 会**沿祖先链一路往上找**，包括 modal 之外的 mask（mask 自身带 `data-action="modal-close"`）。所以点击 modal 内任何 input → closest 找到了 mask（不是 null）→ stopPropagation 不触发 → click 冒泡到 mask → 触发 modal-close → **modal 闪退**。

**正确写法**：必须用 `this.contains(action)` 把搜索范围**限制在 modal 自身以内**：

```html
<div class="modal" onclick="var a=event.target.closest('[data-action]');if(!a||!this.contains(a))event.stopPropagation()">
  <!-- 点击 input（无 data-action）：a = mask · modal.contains(mask) = false · stopPropagation 触发 ✓ -->
  <!-- 点击关闭按钮（modal 内 data-action）：a = button · modal.contains(button) = true · stopPropagation 不触发 → 冒泡到 document → 关闭 ✓ -->
</div>
```

`this` 在 inline onclick 里指当前元素（modal div）。`modal.contains(action)` 只对 modal 自身和后代为 true，对 mask（祖先）为 false。

### 排查脚本

新页面如果用了 modal，立即 grep 一次确认是最终写法：

```bash
# 检查残留任何旧写法
grep -lE "class=\"modal\" onclick=\"event\.stopPropagation\(\)\"|class=\"modal\" onclick=\"if\(!event\.target\.closest\('\[data-action\]'\)\)event\.stopPropagation" prototypes/v0.1/*.html

# 任何匹配都需替换为：
# var a=event.target.closest('[data-action]');if(!a||!this.contains(a))event.stopPropagation()
```

### 教训

这条反模式踩了**两次**：第一次以为 "stopPropagation 关闭按钮失效" 已修，结果二次出 "点 input 闪退"。**子节点 `closest()` 会跨过 modal 边界继续往上找**——直觉容易忽略。任何用"祖先查询"修 bug 的写法，**都要显式限制查询的祖先范围**（`this.contains` / `parentEl.contains` / 自定义 stop 节点），不能依赖 `closest` 自然停止。

### 适用

所有用 chrome.js 委托 + modal-mask 嵌套 modal 容器结构的 SaaS 后台。Drawer 不受此影响（drawer 与 mask 是兄弟节点而非父子）。

---

## 反模式 29：mock 臆造无来源的数据结构（v2.1 · MaaS 监测连踩 3 处）

❌ 臆造**平行数据结构**：探针真实输出只有「case 命中列表」，mock 却另造独立的 `modelIdentity: { declared, probed, consistent }` 身份核对产物——真实系统根本没有这个字段，用户一句「我返回的数据并没有」即穿帮

❌ 残留**已砍口径**：D6 已改「核心/全量轮」，探针运行 mock 仍是 `'15 case 抽样 160 样本' · successCount: 142`（样本级计数 = 旧抽样口径）

❌ 臆造**处置链数据**：`ticketId: 'TKT-2026-009'`、`status: 'resolved'`、`actionTaken: '已通知法务+建议下线'`——监测系统没有工单集成，处置是下游的事

**问题**：mock 不只是「演示数据」，它是**前后端数据契约的原型**。臆造的结构会被后端当成需求实现，或在评审时被供应商/研发一眼识破"这数据你们拿不到"。与原则 12（真实业务示例数据）同根但更深一层：**名字真实不够，结构与字段也必须可溯源**。

**识别口径**：对每个 mock 字段问「**真实系统的哪个组件产出它？**」（网关聚合 / 探针执行器 / 调度器 / 准入流水线）——答不上来 = 臆造，删或改造成可产出的形态。

✅ 修正模式（探针运行记录案例）：
```js
// ❌ 臆造：probeRunId / 样本计数 / token 成本 / 混淆执行失败与 case 失败的 error
{ probeRunId: 'PR-D6-xxx', requestedCaseCodes: '15 case 抽样 160 样本', successCount: 142, failedCount: 18, costTokens: 39800 }
// ✅ 可溯源（执行器真实产物 · case 口径 · 执行失败与未通过分离）：
{ runType: 'full', startedAt, finishedAt, triggeredBy: 'schedule', casesTotal: 15, casesPassed: 12, casesUnpassed: 3, execFailed: 0, execError: null }
```

**连带纪律**：① 同一事实跨区块要**对账自洽**（探针运行的「未通过 3」必须等于矩阵失败维度数 3）；② 区分「case 未通过（供应商问题）」与「执行失败（探针侧问题 · 结果不可信）」是探针类数据的固有维度，mock 要能演示两种场景。

---

## 维护

每次返工或新发现 → 在本文件加新反模式。
