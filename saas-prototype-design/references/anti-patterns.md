# 反模式与真实返工案例

每条都来自 JMaaS 项目 30+ 轮迭代的真实返工。**避坑就是节省时间**。

---

## 反模式 1：PM 规划性术语混入原型

### ❌ 错误

```
<span>L2 行业集 · v0.1 主战场</span>
<span>本期评测集库默认为空</span>
<div>L1 标准集 · v0.x 启用 · 本期仅入库浏览</div>
<div>④-⑧ 高阶节点（远期）</div>

<!-- 更严重的：整页顶部 banner 解释「v0.1 评测范围」 -->
<div class="v01-banner">
  v0.1 评测范围说明：本期上线 L2 行业集 + 性能集 ...
</div>

<!-- 列表分组顶部塞解说文案（变体） -->
<div class="layer-group-header">
  <span class="layer-chip">L2</span> 行业场景集
  <span class="text-xs">3 个示例 · 右上角开关控制启用状态 · 点击卡片查看详情</span>
</div>
```

### 问题

原型是给业务方 / 开发对接的**最终交付物**。PM 视角的「主战场 / 本期 / v0.x / 远期 / MVP」让客户困惑。

**版本范围说明 banner 是高频陷阱**：PM 总想在页顶解释「这是 v0.1，只做了 XX」，但用户只关心当前能做什么，不关心版本规划。版本范围应放在 [`docs/prd/`](../../../docs/prd/) 或 release notes，不进原型。

**列表分组顶部「N 个示例 · 点击卡片查看详情」也是同类**：原型只在演示语境下需要这种解说，真实交付时数据是动态的（不是 3 个，是 N 个）、交互是用户自己探索的（不需要告诉他"点击卡片"）。卡片视觉本身已经表达了交互，多余的说明文字只会被快速过滤。

### ✅ 修正

```
<span>L2 行业场景集</span>
<span>评测集库默认为空</span>
<div>L1 标准集 · 仅入库浏览，暂不参与评测</div>
<!-- ④-⑧ 节点必须独立展开 -->
```

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

## 反模式 3：「后端」当作端

### ❌ 错误

```
端层：
- 运营端
- 供应商端
- 后端  ← ❌
- 数据层  ← ❌
- MaaS 平台
```

### 问题

「端」只能是**用户使用的客户端 UI**。后端 / 数据是技术实现，不能算端。

### ✅ 修正

```
L1 端层（用户界面）
- 运营端 admin
- 供应商端 portal
- 第三方平台（如适用）

L2 业务服务层（页面背后的能力 · 无 UI）
L3 数据资产层
L4 平台底座
```

---

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

JMaaS 项目中 Agent C 任务是「复制 v1 文件到 v0.1 + 改 brand」，结果直接覆盖了之前 3 轮迭代精修的 `v0.1/eval-sets.html`（启用 toggle / 描述 / 版本历史 / 模型基线 3 sub-tab 等都丢了）。

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

「Step 3 Metric 配置」删了，但 Step 2 的「下一步：Metric 配置」按钮文案没改，且页面顶部「v0.1 · 4 步向导」描述也没同步。

### ✅ 修正

每次删除模块后必查的「文案残留 grep」清单：

```bash
# 检查删除后的孤立引用
grep -rn "Step 3 Metric\|Metric 配置\|3 步向导\|4 步向导" *.html

# 检查 KPI / tab count 数字
grep -rn 'tab-count\|kpi-value tabular' *.html

# 检查 mock 数据残留
grep -rn 'data-set=\|data-panel=\|data-step=' *.html
```

---

## 反模式 8：Tab 切换内容只默认 tab 有

### 真实案例

vendor-audit.html 顶部有「待审 / 已通过 / 已驳回 / 补材料」4 tab，但只「待审」tab 有内容，其他点切换后空白。

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

## 反模式 11：基线塞进「报告产出」

### ❌ 错误

```
B4 报告产出
├── 体检报告 + 审批
├── 行业基线对照库   ← ❌ 这是数据资产
├── 评级证书生成
└── 赛马看板
```

### ✅ 修正

行业基线是**数据资产**（model_baseline 表），供报告引用。应独立成「B7 基线对照库」或归到「数据资产层」。

---

## 反模式 12：层 6a / 6b 这种 a/b 子层

### ❌ 错误

```
层 6a · 评测对象
层 6b · 评测底座
```

### ✅ 修正

要么拆成独立层 6 + 层 7，要么并入相邻层。a/b 混乱。

---

## 反模式 13：评级算法塞进「评估产出」

### ❌ 错误

```
③ 评估产出（评测引擎 WHAT 段）
├── 综合评分计算
├── 行业基线对照     ← 数据资产
├── 风险警示
├── 审批决策面板     ← L1 端层
└── 评级算法（ABCDE） ← D 风险治理域
```

### ✅ 修正

5 个东西分别属不同层 / 不同能力域。保留「评估产出」纯粹的 3 项（综合评分 / 风险警示 / 报告数据结构），其他用「引用其他层」小注脚标注归属。

---

## 反模式 14：把"评测工程师"列为端

### ❌ 错误

```
端层
├── 运营端
├── 评测工程师  ← ❌ 是运营端内的角色
├── 供应商端
└── MaaS 平台
```

### ✅ 修正

端只有 3 个：运营端（含评测工程师 / 运营 / 采购等多角色）/ 供应商端 / MaaS 平台。

---

## 反模式 15：版本视角混入全局架构图

### ❌ 错误

```
B2 节点执行
├── ① 连通性 [v0.1]
├── ② 性能评测 [v0.1]
├── ③ 能力评测 [v0.1]
└── ④-⑧ 高阶节点（远期）
```

### ✅ 修正

版本规划放 roadmap.md / PRD，架构图只表达"我们做哪些事"，不分版本。

---

## 反模式 16：MaaS 平台职责用同色实线（看起来像本平台功能）

### ❌ 错误

```
C4 路由（与其他 C1-C3 同色实线）
├── 评级 → 路由权重映射
└── 流量分配 / 限流 / 熔断
```

### ✅ 修正

```css
.m-out {
  background: #f5f5f4;
  border-style: dotted;
  opacity: .7;
}
.m-out .ct { text-decoration: line-through; color: #78716c; }
```

dotted 边框 + 半透明 + 文字 line-through，明确「不在本平台范围」。

---

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

## 维护

每次返工或新发现 → 在本文件加新反模式。
