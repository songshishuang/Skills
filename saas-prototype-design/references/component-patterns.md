# 组件模式

## 1. 侧栏（sidebar）

### 结构

```
sidebar
├── sidebar-brand        ← logo + 品牌名 + 环境徽章（沙箱 / 灰度 / 生产）
├── sidebar-nav
│   ├── sidebar-group    ← 一级分组（5-7 个）
│   │   ├── group-label  ← 分组名（如「评测工作」）
│   │   └── sidebar-item ← 二级菜单（icon + 文字 + 可选 badge）
│   └── ...
└── sidebar-footer       ← 版本 + 返回总览 + 角色提示
```

### 分组原则

- **按工作流分组，不按能力域** —— 比如「评测工作 / 评测集 / 评级与对比」不是「A 域 / B 域」
- **不带 A/B/C/D chip 在 sidebar 内**（chip 是规划视角，不是用户视角）
- **每组 ≤ 4 项**（多了认知负担）
- **总分组 5-7 个**（多了滚动）

### 灰显（v0.1 不可用菜单）

```html
<span class="sidebar-item sidebar-item-disabled"
      data-action="toast" data-arg="该功能将在 v1.0 启用"
      data-toast-type="info"
      style="opacity:.45;cursor:not-allowed">
  <span class="sidebar-item-icon">🏅</span><span>评级证书</span>
</span>
```

注意：用 `<span>` 不是 `<a>`（防止误跳转）。

## 2. 顶栏（topbar）

```
topbar
├── topbar-search        ← 全局 ⌘K 搜索（含图标 + kbd hint）
└── topbar-actions
    ├── 🔔 通知（红点提示）→ drawer-open
    ├── ❓ 帮助
    ├── ⚙️ 设置 → toast 或 modal
    └── 头像（首字母圆形）
```

## 3. 页面 header

```html
<div class="page-header">
  <div>
    <div class="breadcrumb">A / B / <span>当前页</span></div>
    <h1 class="page-header-title">页面标题</h1>
    <div class="page-header-desc">一句话功能描述</div>
  </div>
  <div class="page-header-actions">
    <button class="btn btn-secondary btn-sm">次操作</button>
    <button class="btn btn-primary btn-sm">主操作（红）</button>
  </div>
</div>
```

## 4. KPI 大卡

**两种规格**，根据场景选择：

### 4a. 仪表盘规格（首页 dashboard）

OpenRouter 风格，KPI 是页面主角，大字 + 增量 + 图标。

```html
<section style="display:grid; grid-template-columns: repeat(4, 1fr); gap: 16px;">
  <div class="kpi-card" style="padding: 24px;">
    <div class="flex items-center justify-between mb-2">
      <span class="kpi-label">在管供应商</span>
      <span>🏢</span>
    </div>
    <div class="kpi-value tabular" style="font-size: 28px;">42</div>
    <div class="kpi-delta up">▲ 3 本月新入驻</div>
  </div>
  ...
</section>
```

### 4b. 紧凑型规格（列表页 / 管理页）

KPI 是辅助信息，让位给主表格。**padding 12/16 · value 22px · 副标 inline 紧贴右侧**：

```html
<section style="display:grid; grid-template-columns: repeat(4, 1fr); gap: 12px;">
  <div class="kpi-card" style="padding: 12px 16px;">
    <div class="kpi-label">总用例数</div>
    <div class="kpi-row" style="display:flex; align-items:baseline; gap:8px;">
      <span class="kpi-value tabular" style="font-size: 22px; line-height: 1.2;">540</span>
      <span class="kpi-sub" style="font-size:12px; color:var(--color-text-tertiary);">金融场景 · 风控/理财/信用/还款</span>
    </div>
  </div>
  ...
</section>
```

效果：高度从 ~120px 压到 ~64px。

### 实战经验

1. KPI 大字必须用 `.tabular`（等宽数字），避免不同卡片数字粗细不一。
2. **副标必须解释数字的构成**（金融/风控/理财/信用、准入 14·定期 5·临时 2），不能写"示例数据 / v0.1 / 占位"。详见 [`anti-patterns.md` §22](anti-patterns.md)。
3. 列表页用 4b 紧凑型，首页 dashboard 才用 4a 仪表盘型。详见反模式 24。

## 5. 条件查询区（filter-form · 重要）

按图例风格：3 列 grid · label 70px 右对齐 · 底部展开/重置/搜索 右对齐。

```html
<form class="filter-form">
  <div class="filter-grid">
    <div class="filter-row">
      <label class="filter-label">客户信息</label>
      <div class="filter-control"><input class="input" placeholder="..."></div>
    </div>
    <div class="filter-row">
      <label class="filter-label">客户 ID</label>
      <div class="filter-control"><input class="input"></div>
    </div>
    <div class="filter-row">
      <label class="filter-label">所属员工</label>
      <div class="filter-control"><select class="select"><option>请选择</option></select></div>
    </div>
    <!-- 行 2 -->
    <div class="filter-row filter-row-wide">
      <label class="filter-label">添加时间</label>
      <div class="filter-daterange">
        <input class="input" placeholder="开始日期">
        <span class="dr-sep">~</span>
        <input class="input" placeholder="结束日期">
      </div>
    </div>
    <!-- 折叠区 -->
    <div class="filter-extra">...</div>
  </div>
  <div class="filter-actions">
    <button type="button" class="filter-expand-btn"
            onclick="this.closest('.filter-form').classList.toggle('expanded')">
      展开 <span class="chev">▾</span>
    </button>
    <button type="button" class="btn btn-secondary btn-sm">重置</button>
    <button type="button" class="btn btn-primary btn-sm"
            data-action="toast" data-arg="筛选已应用 · 匹配 N 条">搜索</button>
  </div>
</form>
```

## 6. 列表工具栏（list-toolbar）

```html
<div class="list-toolbar">
  <div class="list-toolbar-left">
    <button class="btn btn-secondary btn-sm">批量打标签</button>
    <button class="btn btn-secondary btn-sm">批量取消</button>
  </div>
  <div class="list-toolbar-right">
    <button class="btn btn-secondary btn-sm">⬇️ 导出</button>
    <button class="btn btn-primary btn-sm">+ 新建</button>
  </div>
</div>
```

## 7. 表格

```html
<table class="tbl tbl-compact">
  <thead>
    <tr>
      <th><input type="checkbox"></th>
      <th>列 1</th><th>列 2</th><th>状态</th><th>操作</th>
    </tr>
  </thead>
  <tbody>
    <tr onclick="showDrawer('detail-drawer')">
      <td><input type="checkbox"></td>
      <td>...</td>
      <td><span class="badge online">● 已上架</span></td>
      <td>
        <a href="#" data-action="drawer-open" data-arg="detail">详情</a>
      </td>
    </tr>
  </tbody>
</table>
```

**实战经验**：
- 行 click 打开 drawer 详情比新页面跳转更好（不丢上下文）
- 操作列保持 `<a>` 文字链接（不要按钮）减少视觉噪音
- 数字列用 `.tabular`

## 8. Drawer（详情面板）

```html
<div class="drawer-mask" data-drawer-mask="detail" data-action="drawer-close" data-arg="detail"></div>
<div class="drawer" id="detail">
  <div class="drawer-header">
    <h3>详情标题</h3>
    <button data-action="drawer-close" data-arg="detail">×</button>
  </div>
  <div class="drawer-body">
    <!-- tab 切换 -->
    <div class="tabs" data-tab-group>
      <div class="tab active" data-action="tab-switch" data-tab-target="basic">基本信息</div>
      <div class="tab" data-action="tab-switch" data-tab-target="history">历史</div>
    </div>
    <div data-tab-content="basic">...</div>
    <div data-tab-content="history" style="display:none">...</div>
  </div>
</div>
```

### 8a. Drawer 双模式（写 vs 读 · 复用同一 drawer）

**场景**：审批/审核类页面，「审核（可决策）」和「查看历史结果」用同一份基础数据 +「决策区」差异。**不要做两个 drawer**——通过 mode 参数控制差异区显隐。

```html
<div class="drawer" id="audit-drawer">
  <div class="drawer-header"> ... </div>
  <div class="drawer-body">
    <!-- 共享：基础信息 section（永远显示） -->
    <div class="drawer-section">📋 基础信息</div>

    <!-- 仅 audit 模式 -->
    <div class="drawer-section" id="decisionSection">
      ⚖️ 审核决策（通过 / 驳回 + 备注 + 提交按钮）
    </div>

    <!-- 仅 view 模式 -->
    <div class="drawer-section" id="resultSection" style="display:none">
      📝 审核结果（结论 + 时间 + 责任人 + 备注/驳回原因）
    </div>
  </div>
</div>
```

```js
function openDrawer(itemId, mode) {
  const item = INDEX[itemId];
  // 1. 永远填基础信息
  fillBasicFields(item);
  // 2. 按 mode 切换差异区
  const isAudit = mode === 'audit' && item.status === 'pending';
  document.getElementById('decisionSection').style.display = isAudit ? '' : 'none';
  document.getElementById('resultSection').style.display = isAudit ? 'none' : '';
  if (!isAudit) fillResultFields(item);
  showDrawer('audit-drawer');
}

// 入口分流（列表行按钮）
//   [审核] → openDrawer(id, 'audit')
//   [详情] → openDrawer(id, 'view')
```

### 实战经验

- **mode 由调用方决定，而非由 item.status 决定**——同一条 pending 数据，运营可以「审核」也可以「先看下」
- **基础信息永远展示**——只切换差异 section 显隐，避免「同一条数据两个版本」的认知割裂
- **fail-safe**：当 `mode='audit'` 但 `item.status !== 'pending'`（已被别人审过），自动降级为 view 模式（防止重复审批）
- 反例：把审核与查看做成两个 drawer，导致基础字段重复维护，且 tab 切换/按钮联动逻辑分裂

## 9. Modal（模态）

```html
<div class="modal-mask" id="my-modal">
  <div class="modal" onclick="event.stopPropagation()">
    <div class="modal-header">
      <h3>标题</h3>
      <button data-action="modal-close" data-arg="my-modal">×</button>
    </div>
    <div class="modal-body">...</div>
    <div class="modal-footer">
      <button class="btn btn-secondary btn-sm" data-action="modal-close" data-arg="my-modal">取消</button>
      <button class="btn btn-primary btn-sm" data-action="confirm"
              data-confirm-msg="..." data-confirm-toast="...">提交</button>
    </div>
  </div>
</div>
```

## 10. Wizard（多步向导）

```html
<div class="stepper">
  <div class="stepper-item active" data-step="1">
    <div class="stepper-num">1</div>
    <div><div class="stepper-title">模板选择</div><div class="stepper-sub">basic/RAGAS/...</div></div>
  </div>
  <div class="stepper-line"></div>
  <div class="stepper-item" data-step="2">...</div>
</div>

<div class="step-panel active" data-panel="1">...</div>
<div class="step-panel" data-panel="2">...</div>
```

**实战经验**：
- **2-3 步**最舒服（4+ 步会让人放弃）
- 每步都要有 `← 上一步 / 下一步 →` 按钮
- 提交按钮文案要明确：「**提交入库**（审批后生效）」而非「下一步」
- stepper 点击可跳转（不要锁步）

## 11. Toast / Confirm

```js
toast('消息', 'success'|'warn'|'danger'|'info');  // 自动消失 2.5s
```

```html
<button data-action="confirm"
        data-confirm-msg="确认删除？"
        data-confirm-toast="已删除">删除</button>
```

## 12. 上传交互（3 态完整）

**初始态** → 拖拽虚线框 + 「📁 选择文件」按钮 + 副标「支持 CSV / JSONL · ≤10MB · ≤5000 行」

**上传中** → 实线框 + 文件名 + 解析进度条 0→100%（800ms 动画）

**已上传** → emerald 边框 + 文件名 + 大小 + 「重新选择」「预览前 5 行」按钮 + 「✓ 解析成功」

JS：
```js
btn.addEventListener('click', () => {
  zone.classList.add('uploading');
  let p = 0;
  const tk = setInterval(() => {
    p += 12;
    bar.style.width = p + '%';
    if (p >= 100) {
      clearInterval(tk);
      zone.classList.replace('uploading', 'uploaded');
    }
  }, 80);
});
```

## 13. CSV 模板下载联动

模板选择卡片切换时，顶部下载按钮 href + 文字同步切换：

```html
<a id="tpl-download" href="assets/templates/basic.csv" download>
  📥 下载 CSV 模板 <span id="tpl-download-name">(basic)</span>
</a>
```

```js
templateCard.addEventListener('click', () => {
  const tpl = card.dataset.tpl;
  document.getElementById('tpl-download').href = `assets/templates/${tpl}.csv`;
  document.getElementById('tpl-download-name').textContent = `(${tpl})`;
});
```

## 14. 状态徽章圆点（重要 · 全局统一）

```html
<span class="badge online">● 已上架</span>
<span class="badge evaluating">● 评测中</span>
<span class="badge pending-approval">● 待审批</span>
```

禁止：纯色实心 / 大色块 / 高饱和色填充。

## 15. 数字 / 价格 / 时长 格式

```html
<span class="tabular">12.3K</span>  <!-- token 数 -->
<span class="tabular">¥ 0.012</span>  <!-- 单价 -->
<span class="tabular">380 ms</span>  <!-- 延迟 -->
<span class="mono text-xs">ep_001</span>  <!-- ID -->
```

---

## 16. 资源状态机（3 态 / 4 态字典 · 重要）

资源类页面（模型 / 评测集 / 工单 / 订单 / 优惠券 / 客户 ...）建议**对外只暴露 3-4 个状态**，**面向"下游可见性 / 生命周期"维度**，不混入流程性中间态。

### 推荐 3 态字典（暂存 / 启用 / 停用）

| 状态 | 含义 | 徽章色 | 行为约束 |
|---|---|---|---|
| **暂存（draft）** | 运营内部草稿，下游客户**完全不可见** | warn 黄 ● | 可编辑 · 不进路由 · 不计入计费/SLA |
| **启用（active）** | 已生效，下游可申请/订阅/调用 | success 绿 ● | 可编辑（限非 ID 字段）· 可正常调用 |
| **停用（disabled）** | 不再接受新申请，已挂的关联资源**触发告警但不强制下架** | neutral 灰 ● | 仅可改为启用 · 不可删除（需先迁移关联） |

### 推荐 4 态字典（评测/审核流程）

`pending_eval` 待评测 → `evaluating` 评测中 → `pending_approval` 待审批 → `online` 已上架 / `rejected` 已驳回

### 一定不要混入这些"流程中间态"

- 「评测中 / 审批中 / 待补材料 / 灰度中 / 上线申请中 ...」当作主状态
- 这些是**流程状态**（属于某条审批/评测 run），不是**资源主状态**（属于资源本身）
- 把流程状态当主状态会导致：
  - 状态机指数膨胀（3 态 → 12 态）
  - 同一资源在多条流程并发时状态冲突
  - 下游客户看不懂"待补材料"应该自己干啥

### 状态切换交互

```html
<!-- 在详情 drawer 顶部 -->
<button onclick="toggleStatus()">⏸ 停用</button>  <!-- 当前 active -->
<button onclick="toggleStatus()">✓ 启用</button>  <!-- 当前 disabled -->
<!-- 暂存态没有"切换"按钮，只能通过编辑后选"启用"提交 -->
```

```js
// 状态切换必须二次确认 + 影响范围说明
function confirmToggle(m) {
  if (m.status === 'active') {
    confirm(`停用 ${m.name}？\n已挂载的 ${m.endpointCount} 个 Endpoint 将告警，下游客户不可再申请新 Endpoint`);
  } else {
    confirm(`启用 ${m.name}？启用后下游客户可申请 Endpoint`);
  }
}
```

### 反例

- 模型管理列表 v1.0 用了 5 态：「已上架 / 评测中 / 草稿 / 已下架 / 待审批」—— 混入了流程状态「评测中 / 待审批」（属于某条评测 run，不属于模型本身），导致筛选器和状态机切换逻辑紊乱。

---

## 17. 分页器（标准样式 · 必备）

列表页底部统一使用此分页器，不要写"显示 1-10 / 共 10 条 · [1]"这种简化版（信息密度不够、不支持跳转）。

```html
<div class="pager">
  <span>共 <span class="tabular">105</span> 条</span>
  <button class="pg-btn" title="上一页">‹</button>
  <button class="pg-btn active">1</button>
  <button class="pg-btn">2</button>
  <button class="pg-btn">3</button>
  <button class="pg-btn">4</button>
  <button class="pg-btn">5</button>
  <button class="pg-btn">6</button>
  <span class="pg-ellipsis">…</span>
  <button class="pg-btn">11</button>
  <button class="pg-btn" title="下一页">›</button>
  <select class="pg-select">
    <option>10 条/页</option>
    <option>20 条/页</option>
    <option>50 条/页</option>
    <option>100 条/页</option>
  </select>
  <span>前往</span>
  <input class="pg-jump" type="number" value="1">
  <span>页</span>
</div>
```

```css
.pager {
  padding: 14px 18px;
  border-top: 1px solid var(--color-border);
  display: flex;
  align-items: center;
  justify-content: flex-end;  /* 右对齐 · 不左对齐 */
  gap: 10px;
  font-size: 13px;
  flex-wrap: wrap;
}
.pg-btn {
  min-width: 32px; height: 32px; padding: 0 10px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  background: white;
  cursor: pointer;
  font-variant-numeric: tabular-nums;
}
.pg-btn:hover:not(:disabled):not(.active) { border-color: var(--color-primary); color: var(--color-primary); }
.pg-btn.active { background: var(--color-primary); color: white; border-color: var(--color-primary); font-weight: 600; }
.pg-btn:disabled { color: var(--color-text-tertiary); background: #FAFBFC; cursor: not-allowed; }
```

### 行为规范

- **页码范围**：当前页周围最多 6 个数字 + `…` + 末页
- **‹ › 按钮**在首/末页 disabled（灰显 + not-allowed）
- **数据少于一页**时分页器**仍显示**（保持视觉一致性），但页码只显示 [1] + 上一页/下一页 disabled
- **页码与下拉对齐**：当用户改 "20 条/页"，总页数实时更新

---

## 18. 批量操作（复选框 + 工具栏按钮真实联动）

§6 list-toolbar 与 §7 表格首列复选框必须**真实联动**，不能只有 UI 摆设。

### HTML

```html
<thead>
  <tr>
    <th style="width: 36px; text-align: center;">
      <input type="checkbox" id="select-all" onclick="toggleSelectAll(this)">
    </th>
    <th>模型</th>...
  </tr>
</thead>
<tbody>
  <tr onclick="openDetail('id-1')">
    <td style="text-align:center;" onclick="event.stopPropagation()">
      <input type="checkbox" class="row-check" data-id="id-1" onclick="event.stopPropagation(); updateCount()">
    </td>
    ...
  </tr>
</tbody>
```

### 关键点（高频踩坑）

1. **复选框 td 必须 `onclick="event.stopPropagation()"`** — 否则勾选会冒泡到 `<tr>` 的 onclick，意外触发"打开详情"
2. **全选 checkbox 支持 indeterminate** — 部分选中时显示"−"半勾态，全选时勾上
3. **工具栏左侧加"已选 N 项"实时计数** — 用户能直观看到当前选择数
4. **批量按钮 onclick 必须真实联动**：
   - 校验未选 → toast 提示「请先勾选」
   - 二次确认（含前 3 个对象名 + 总数预览）
   - 真实更新数据 + 同步 UI（徽章颜色 / 计数）
   - 操作后**清空选择**

### JS 模板

```js
function updateCount() {
  const checked = document.querySelectorAll('.row-check:checked');
  const all = document.querySelectorAll('.row-check');
  document.getElementById('sel-count').textContent = checked.length;
  const master = document.getElementById('select-all');
  master.checked = checked.length === all.length && checked.length > 0;
  master.indeterminate = checked.length > 0 && checked.length < all.length;
}

function batchAction(action) {
  const checked = document.querySelectorAll('.row-check:checked');
  if (!checked.length) { toast('请先勾选要操作的对象', 'warn'); return; }
  const names = Array.from(checked).map(cb => DATA[cb.dataset.id].name);
  const preview = names.length <= 3 ? names.join('、') : names.slice(0, 3).join('、') + ` 等 ${names.length} 个`;
  if (!confirm(`确认对以下 ${names.length} 项批量${action}？\n\n${preview}`)) return;
  // 更新数据 + UI
  ...
  toast(`已对 ${names.length} 项批量${action}`, 'success');
}
```

### 反例

- 批量启用/停用按钮直接 `data-action="toast" data-arg="已批量启用"` —— 没真生效，用户点了之后没有任何反馈联动
- 表格首列只有 checkbox 但不带 `data-id` —— 无法关联到数据
- 全选 checkbox 没处理 indeterminate —— 部分选中时显示全勾，误导用户


---

## 业务特化组件（§19-§25 已迁出）

以下组件因业务领域特化（API 接入 / 入驻 / 评级 / 雷达 / 告警 / 监控 / 多品牌主题），不属于通用 SaaS 必备件套，已迁到 [`business-components.md`](./business-components.md)：

| § | 组件 | 业务领域 |
|---|---|---|
| §19 | 混合表单 + JSON 配置 | API 接入 |
| §20 | 申请流程页（Stepper + 分支） | vendor 入驻 / 工单 |
| §21 | RatingBadge ABCDE | 评级 / SLA |
| §22 | RadarChart 多维雷达 | 对标 / 能力评估 |
| §23 | AlarmCard P0-P3 | 监控 / 告警台 |
| §24 | ServiceLamp 3 态 | 服务健康 / pipeline |
| §25 | ThemeSwitcher 4 维 | 多品牌 SaaS |

> v2.0 拆分原则：通用核心 §1-§18 留本文件；业务特化 §19-§25 按需引用 `business-components.md`。详见 SKILL.md「文件清单」。
