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

## 19. 混合表单 + JSON 配置（API 接入类页面必备）

> 适用：API 接入、Webhook 配置、SSO 接入、第三方支付对接、消息推送渠道、数据源连接等 **"配置异构外部服务"** 的页面。

### 核心分层原则

把"配置一个外部服务"拆成 **两层字段**：

| 层 | 字段特征 | 形式 | 例子 |
|---|---|---|---|
| **强类型必填字段** | 所有同类资源都有 · 可校验格式 · 业务必须 | 表单 `<input>` / `<select>` | base_url / api_key / auth_type |
| **协议/能力差异化字段** | 因协议、能力、推理模式不同而不同的可选字段 | JSON `<textarea>` 编辑器 | anthropic_version / project_id / reasoning_modes mapping |

**为什么不全用表单？** —— 字段集会因协议爆炸（OpenAI / Anthropic / Gemini / 自定义 4 协议 × 5 认证方式 × N 个能力组合 = 几十种字段组合），用 UI 表达会变成无法维护的"条件渲染表单"。

**为什么不全用 JSON？** —— 必填字段（如 base_url）失去强类型校验，运营容易拼错，且 UI 不直观。

### 3 个关键交互

#### 19.1 上下游联动展示（前置选择 → 自动展示元信息）

用户先选「A」→ 立刻展示「A 的相关信息卡」（蓝色 info-card），避免运营再去别处查。

```html
<!-- 选模型系列 → 联动模型下拉 -->
<select id="form-family"><option>请选择...</option>...</select>
<select id="form-model"></select>

<!-- 联动信息卡：模型选定后展示「协议 / 推理模式 / 能力」 -->
<div id="model-info-card" class="model-info-card" style="display:none"></div>
```

```css
.model-info-card {
  padding: 12px 14px; background: var(--color-bg-page);
  border-radius: var(--radius-md);
  border-left: 3px solid var(--color-info);
  margin-top: 8px; font-size: 12px;
}
.model-info-card .row { display: flex; gap: 6px; margin-bottom: 4px; }
.model-info-card .k { color: var(--color-text-secondary); min-width: 80px; }
.model-info-card .v { color: var(--color-text-primary); }
```

```js
fSel.addEventListener('change', () => { refreshChildOpts(); refreshChildInfo(); });
```

#### 19.2 按选择"生成默认 JSON 模板"按钮

JSON 编辑器旁加一个 「🪄 按协议生成默认模板」按钮，点击后根据当前选择**填入合适的 JSON 骨架**，运营再按需调整。

```html
<div class="flex items-center justify-between mb-1">
  <label class="label" style="margin:0;">高级参数（connection_config）</label>
  <button type="button" class="btn btn-ghost btn-sm" onclick="generateConfigTemplate()" style="font-size:11px;">
    🪄 按协议生成默认模板
  </button>
</div>
<textarea class="json-editor" id="form-config" spellcheck="false"></textarea>
```

```js
function generateTplFor(m) {
  const tpl = {};
  // 协议专属字段
  if (m.protocol === 'Anthropic Messages') tpl.anthropic_version = '2023-06-01';
  if (m.protocol === 'Google Gemini') { tpl.project_id = '...'; tpl.location = '...'; }
  // 模式映射
  if (m.modes.length > 1) {
    tpl.reasoning_modes = {};
    m.modes.forEach(mode => {
      if (m.protocol === 'Anthropic Messages') {
        const budget = { N1: 256, N2: 2048, N3: 8192 }[mode];
        if (budget) tpl.reasoning_modes[mode] = { thinking: { budget_tokens: budget } };
      } else {
        tpl.reasoning_modes[mode] = { enable_thinking: true };
      }
    });
  }
  // 能力开关
  if (m.capabilities.includes('JSON')) tpl.response_format_default = { type: 'text' };
  if (m.capabilities.includes('工具')) tpl.tool_use = { parallel: true };
  // 通用限速
  tpl.limits = { qps: 1000, concurrent: 32 };
  return tpl;
}
```

#### 19.3 JSON 编辑器样式（等宽字体 + 行高 + spellcheck off）

```css
.json-editor {
  width: 100%; min-height: 180px; padding: 10px;
  font-family: 'JetBrains Mono', 'SF Mono', Menlo, monospace;
  font-size: 12px; line-height: 1.5;
  border: 1px solid var(--color-border); border-radius: var(--radius-md);
  background: #FAFBFC; color: #1E293B;
  resize: vertical;
}
.json-editor:focus { outline: none; border-color: var(--color-accent); }
```

```html
<!-- spellcheck=false 关掉浏览器拼写检查（JSON 内有大量自定义 key 误报） -->
<textarea class="json-editor" spellcheck="false">...</textarea>

<!-- 详情 drawer 中只读展示：用 <pre> 代替 <textarea> -->
<pre class="json-editor" style="margin: 0;">${JSON.stringify(config, null, 2)}</pre>
```

### 落库形态建议

存储为关系型主表 + 一个 JSONB 字段（PostgreSQL）或 JSON column（MySQL 5.7+）：

```sql
CREATE TABLE endpoints (
  endpoint_id     VARCHAR(64) PRIMARY KEY,
  model_id        VARCHAR(64) NOT NULL REFERENCES models,
  vendor_code     VARCHAR(64) NOT NULL REFERENCES vendors,
  base_url        VARCHAR(512) NOT NULL,
  auth_type       VARCHAR(32) NOT NULL,
  api_key_kms_id  VARCHAR(128),
  status          VARCHAR(32) NOT NULL,
  connection_config JSONB,         -- ← 灵活配置
  created_at      TIMESTAMPTZ,
  updated_at      TIMESTAMPTZ
);
```

JSONB 字段建议**仅做整体替换 + 关键路径索引**，不做字段级 UPDATE。

### 反例

- ❌ **全 UI 条件渲染**：协议选 Anthropic → JS 把 8 个不同字段塞进来 → 协议改 OpenAI → 又换一套 → 字段太多时表单成"巨型条件树"，维护成本爆炸
- ❌ **全 JSON 编辑器**：base_url / api_key 也让运营手写 JSON，新手不知道哪些是必填，拼错 key 名后台才报错
- ❌ **JSON 模板硬编码在 HTML**：把 5 种协议的默认模板写成 5 个 `<textarea>` 隐藏切换 → 维护时改一处忘改其它 4 处
- ❌ **JSON 编辑器没 spellcheck=false**：浏览器把 `qps` / `mtls` 全标红波浪线，运营误以为是错误
- ❌ **联动信息卡显示太迟**：选完模型才在底部出现，运营看不见 → 应紧贴选择控件下方


---

## 20. 申请流程页（Stepper + 状态分支 UI）

> 适用：「**用户主动提交 → 平台审核 → 通过 / 驳回**」类页面 —— 供应商入驻 / 订单 / 工单 / 报销 / 资质申请 / 变更工单 / 开户申请等。

### 核心原则：单页表单 + 顶部 stepper + 按状态切换 UI（不要做 N 个独立页面）

**为什么不做 N 个独立页面**：申请的"内容"在所有状态下都是同一份（用户填的字段），只是**展示形态**（可编辑 vs 只读）和**附加信息**（审核中提示 vs 通过提示 vs 驳回原因）不同。做 N 页 → 字段重复维护、修改时容易漂移。

### 4 状态字典（推荐）

| 状态 | stepper | 提示横幅颜色 | 表单 | 底部按钮 |
|---|---|---|---|---|
| **draft 草稿** | ① active | — 无横幅 | 可编辑 | 返回 + **提交申请** |
| **submitted 已提交** | ✓ ② active | 🟡 警告色「⏳ 审核中」+ 申请号 + 预期审核时长 | 只读灰显 | 返回 + **撤回申请** |
| **approved 审核通过** | ✓ ✓ ③ active（success 色）| 🟢 成功色「✓ 审核通过」+ 审核人 + 备注 | 只读灰显 | 返回 + **→ 进入下一阶段** |
| **rejected 已驳回** | ✓ ✓ ✗ ③ fail（danger 色）| 🔴 危险色「✕ 已驳回」+ 驳回原因 | **可编辑**（让用户改完重交）| 返回 + **修改并重新提交** |

### HTML 模板

```html
<!-- 顶部 3 步 stepper -->
<div class="stepper-bar">
  <div class="stp-step" id="stp-1"><span class="stp-num"><span>1</span></span><span class="stp-label">提交申请</span></div>
  <div class="stp-line" id="stp-line-1"></div>
  <div class="stp-step" id="stp-2"><span class="stp-num"><span>2</span></span><span class="stp-label">审核中</span></div>
  <div class="stp-line" id="stp-line-2"></div>
  <div class="stp-step" id="stp-3"><span class="stp-num"><span>3</span></span><span class="stp-label">审核完成</span></div>
</div>

<!-- 状态提示横幅（按状态动态填充） -->
<div id="status-banner"></div>

<!-- 申请表单 -->
<div class="form-card">...</div>

<!-- 演示用：右上角状态切换器（仅原型环境用） -->
<select id="state-switcher" onchange="switchState(this.value)">
  <option value="draft">① 草稿（可编辑）</option>
  <option value="submitted">② 已提交 · 审核中</option>
  <option value="approved">③ 审核通过</option>
  <option value="rejected">④ 已驳回</option>
</select>
```

### CSS 模板（stepper 4 态）

```css
.stp-step.active .stp-num { background: var(--color-primary); color: white; box-shadow: 0 0 0 4px var(--color-primary-bg); }
.stp-step.done .stp-num { background: var(--color-success); color: white; }
.stp-step.done .stp-num::before { content: "✓"; }
.stp-step.done .stp-num span { display: none; }
.stp-step.fail .stp-num { background: var(--color-danger); color: white; }
.stp-step.fail .stp-num::before { content: "✕"; }
.stp-step.fail .stp-num span { display: none; }
.stp-line.done { background: var(--color-success); }
.stp-line.fail { background: var(--color-danger); }
```

### JS 模板（switchState 集中切换）

```js
const STATES = {
  draft:     { stepper: { '1':'active' },                          banner: null,                            readonly: false, footerBtn: 'submit' },
  submitted: { stepper: { '1':'done', '2':'active' },              banner: { type:'warn', head:'⏳ 审核中' }, readonly: true,  footerBtn: 'withdraw' },
  approved:  { stepper: { '1':'done', '2':'done', '3':'active' },  banner: { type:'success', head:'✓ 通过' }, readonly: true,  footerBtn: 'next' },
  rejected:  { stepper: { '1':'done', '2':'done', '3':'fail' },    banner: { type:'danger', head:'✕ 已驳回' }, readonly: false, footerBtn: 'resubmit' }
};

function switchState(s) {
  const cfg = STATES[s];
  // 1. stepper 高亮
  applyStepperState(cfg.stepper);
  // 2. 横幅
  renderBanner(cfg.banner);
  // 3. 表单 readonly
  setFormReadonly(cfg.readonly);
  // 4. footer 按钮切换
  renderFooterBtn(cfg.footerBtn);
}
```

### 演示用状态切换器（原型必备）

原型阶段（评审 / Demo / 客户验收）需要让评审人**一眼看完 4 个状态**，不可能真的跑后端流程。右上角加一个红色虚线框 + 下拉 `<select>`：

```html
<span class="demo-switcher">
  演示状态：
  <select onchange="switchState(this.value)">
    <option value="draft">① 草稿</option>
    <option value="submitted">② 已提交</option>
    <option value="approved">③ 通过</option>
    <option value="rejected">④ 驳回</option>
  </select>
</span>

<style>
.demo-switcher {
  padding: 5px 10px;
  background: #FEF2F1; border: 1px dashed var(--color-primary);
  border-radius: var(--radius-md);
  font-size: 11px; color: var(--color-primary);
}
</style>
```

颜色与正常 UI 形成视觉对比（红色虚线 + 提示文字「演示状态」），评审人一眼看到「这是原型态切换器，不是真实交互」。生产环境删除整个 `.demo-switcher` 元素即可。

### 反例

- ❌ **4 个独立页面**（register-draft.html / register-pending.html / register-approved.html / register-rejected.html）：字段在 4 个地方维护，改一个忘改 3 个
- ❌ **没有 stepper · 只用 banner 提示状态**：用户不知道流程总共几步、当前在哪步、还差多少
- ❌ **driven by item.status 自动切换 · 没有人工演示入口**：原型评审时只能看到当前 mock 状态，看不到其它 3 个状态的样子
- ❌ **stepper 都用绿色完成态**：驳回时第 3 步应该用 fail 红 ✕，不能也用 ✓ 绿（误导用户「驳回也算流程正常完成」）
- ❌ **驳回态表单仍只读**：用户必须重新创建一次申请才能改，体验极差。驳回应保留原表单可编辑，加「修改并重新提交」按钮

---

## 21. RatingBadge（评级徽章 ABCDE 5 级 🆕 v1.9）

> 适用：供应商评级 / 模型评分 / SLA 评级 等"5 级评分系统"。

### 设计原则

- ABCDE 5 级，**用主色实心 + 白字**（评级是定级而非状态，与状态徽章圆点+弱底原则不冲突）
- 3 尺寸：`sm 24px`（表格内 inline）/ `md 40px`（卡片角标）/ `lg 64px`（详情页 hero / 证书页）
- lg 尺寸带 box-shadow（提升仪式感，证书签发的视觉重量）
- 配色 token 见 [`design-tokens.md` §评级徽章色](design-tokens.md)

### HTML 模板

```html
<!-- sm 表格内联 -->
<span class="rating-badge rating-A sm">A</span>

<!-- md 卡片角标（默认） -->
<span class="rating-badge rating-B">B</span>

<!-- lg 证书 / 详情 hero -->
<span class="rating-badge rating-C lg">C</span>
```

### CSS 模板

```css
.rating-badge {
  display: inline-flex; align-items: center; justify-content: center;
  width: 40px; height: 40px; border-radius: var(--radius-lg);
  color: #fff; font-family: var(--font-num);
  font-weight: 800; font-size: 22px; line-height: 1;
  letter-spacing: 0.02em; flex-shrink: 0;
}
.rating-badge.sm { width: 24px; height: 24px; font-size: 14px; }
.rating-badge.lg { width: 64px; height: 64px; font-size: 36px; }
.rating-badge.lg.rating-A { box-shadow: 0 4px 12px var(--rating-A-bg); }
.rating-badge.lg.rating-B { box-shadow: 0 4px 12px var(--rating-B-bg); }
.rating-badge.lg.rating-C { box-shadow: 0 4px 12px var(--rating-C-bg); }
.rating-badge.lg.rating-D { box-shadow: 0 4px 12px var(--rating-D-bg); }
.rating-badge.lg.rating-E { box-shadow: 0 4px 12px var(--rating-E-bg); }

.rating-A { background: var(--rating-A); }
.rating-B { background: var(--rating-B); }
.rating-C { background: var(--rating-C); }
.rating-D { background: var(--rating-D); }
.rating-E { background: var(--rating-E); }
```

### React 实现参考

完整 React 版本（props: `grade` / `size` / `className`）见 v1 项目 `assets/components-business-a.jsx#RatingBadge`。

### 反例

- ❌ 用状态徽章圆点 + 弱底（A 级看起来像"已上架"绿）→ 评级 ≠ 状态，应主色实心
- ❌ A/B/C/D/E 都用同一色加 1-5 个圆点 → 视觉负担高，识别需数圆点
- ❌ 表格里用 lg 尺寸 → 占用过大，应在 sm

---

## 22. RadarChart（多维能力雷达 / 对标图 🆕 v1.9）

> 适用：供应商评分对比 / 模型 5 维评估 / 维度趋势对标。

### 设计原则

- **5-6 维**（多于 7 维认知负担过高）
- **双 series 对比**：当前值（实色） vs 基线（虚线灰）
- **满分归一化到 0-100**，固定满分轴（不要根据数据自动缩放）
- 与柱状图组合使用（雷达看形态，柱状看具体数值）

### 标准 5 维（评估系统常用）

```js
const RADAR_5_DIMS = [
  { dim: '能力', value: 85, baseline: 80 },
  { dim: '性能', value: 82, baseline: 78 },
  { dim: '稳定', value: 88, baseline: 82 },
  { dim: '合规', value: 90, baseline: 85 },
  { dim: '经济', value: 78, baseline: 80 },
];
```

### React + Recharts 实现

```jsx
<RadarChart data={data} width={320} height={320}>
  <PolarGrid stroke="var(--border)" />
  <PolarAngleAxis dataKey="dim" tick={{ fontSize: 12, fill: 'var(--text-2)' }} />
  <PolarRadiusAxis domain={[0, 100]} axisLine={false} />
  <Radar name="基线" dataKey="baseline" stroke="var(--text-3)" fill="var(--text-3)"
         fillOpacity={0.06} strokeDasharray="4 3" strokeWidth={1.5} />
  <Radar name="当前" dataKey="value" stroke="var(--primary)" fill="var(--primary)"
         fillOpacity={0.18} strokeWidth={2} />
  <Tooltip contentStyle={{
    background: 'var(--surface)', border: '1px solid var(--border)',
    borderRadius: 8, fontSize: 12, boxShadow: 'var(--shadow-md)'
  }} />
  <Legend wrapperStyle={{ fontSize: 12 }} iconSize={10} />
</RadarChart>
```

### 实战经验

- **基线 series 用虚线 + 灰** → 视觉退后，让"当前"实色更突出
- **fillOpacity 0.18 / 0.06** → 当前值半透明可见，基线极淡仅作参考
- **PolarRadiusAxis 关闭 axisLine** → 减少视觉噪声
- **小尺寸（≤ 200px）配 5 维以内**，否则 label 重叠

### 反例

- ❌ 单 series 没基线对比 → 看不出"高 / 低"，孤立数字无意义
- ❌ 维度 > 7 → 形态像满纸 spike，无法识别
- ❌ 满分轴根据数据动态缩放 → 60-90 区间会被拉到 0-100，集中右侧，识别度差
- ❌ 当前 + 基线用相同色 → 区分困难，应灰底虚 + 主色实

---

## 23. AlarmCard（告警卡 · P0-P3 4 级 🆕 v1.9）

> 适用：告警台 / 工单池 / 事件流水。

### 卡片结构（左侧色条 + 严重度 chip + endpoint pill + 操作）

```html
<div class="alarm-card alarm-P0">
  <div class="alarm-stripe"></div>     <!-- 左侧严重度色条 -->
  <div class="alarm-body">
    <div class="alarm-head">
      <span class="alarm-sev">P0</span>
      <span class="alarm-endpoint">claude-4-sonnet@anthropic</span>
      <span class="alarm-title">DriftScore 突破 70 紧急阈值</span>
    </div>
    <div class="alarm-detail">behavior 哈希一致率从 92% 降至 68% · 持续 14 分钟</div>
    <div class="alarm-meta">2026-05-24 14:32:08 · 触发人 自动巡检</div>
  </div>
  <div class="alarm-actions">
    <button class="btn btn-ghost btn-sm">取证</button>
    <button class="btn btn-outline-primary btn-sm">处置</button>
  </div>
</div>
```

### CSS 模板

```css
.alarm-card {
  position: relative;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: 12px 16px 12px 20px;
  box-shadow: var(--shadow-sm);
  display: flex; gap: 12px;
}
.alarm-stripe {
  position: absolute; left: 0; top: 8px; bottom: 8px;
  width: 4px; border-radius: 0 2px 2px 0;
}
.alarm-P0 .alarm-stripe, .alarm-P0 .alarm-sev { background: var(--danger-fg); }
.alarm-P1 .alarm-stripe, .alarm-P1 .alarm-sev { background: #f97316; }
.alarm-P2 .alarm-stripe, .alarm-P2 .alarm-sev { background: var(--warning-fg); }
.alarm-P3 .alarm-stripe, .alarm-P3 .alarm-sev { background: var(--text-3); }
.alarm-sev {
  padding: 2px 8px; border-radius: 4px;
  font-family: var(--font-mono); font-size: 11px;
  font-weight: 700; color: #fff; letter-spacing: 0.04em;
}
.alarm-endpoint {
  padding: 2px 8px; border-radius: 999px;
  background: var(--surface-2); color: var(--text-2);
  font-size: 11px; font-family: var(--font-mono);
}
.alarm-detail { font-size: 12px; color: var(--text-2); margin-top: 4px; }
.alarm-meta   { font-size: 11px; color: var(--text-3); font-family: var(--font-mono); margin-top: 4px; }
```

### 实战经验

- **左侧色条**比"整卡填色"更耐看（运营盯看板 8 小时不会眼花）
- **endpoint 用 pill chip + monospace** → 长名称缩写一致性强
- **时间戳 monospace** → 排序对齐 + 精确到秒
- **取证 / 处置 两按钮**：取证是看数据，处置才是改变状态，分开降低误操作
- **严重度色 token**：P0 红 / P1 橙红 / P2 黄 / P3 灰（详见 [`design-tokens.md` §告警严重度色](design-tokens.md)）

### 反例

- ❌ 整张卡片填红色（P0 / P1 都填）→ 看板炫晕 30 秒就看不下去
- ❌ severity 用 emoji（🔴/🟠/🟡）替代 P0/P1/P2 → 不可索引、不可统计
- ❌ 一行展示所有信息（title + detail + ts 挤一行）→ 第二行 detail 才是关键信息

---

## 24. JoyAgentLamp（服务健康灯 · 3 态 🆕 v1.9）

> 适用：service status indicator / endpoint heartbeat / pipeline health 等。"JoyAgent" 是项目特定命名，可替换为 `ServiceLamp` / `HealthLamp`。

### 设计

- **3 态聚合**：任一 down → 整体 down；任一 degraded（无 down）→ degraded；全部 healthy → healthy
- **位置**：顶栏 Topbar 右侧（与通知 / 用户菜单同区）
- **形态**：10×10 圆点 + 环形 halo（healthy 慢脉冲 2.4s / degraded 快脉冲 1.2s / down 静止纯色）
- **点击展开**：drawer 列出所有底层 service / pipeline 的状态明细

### HTML + CSS

```html
<button class="health-lamp lamp-healthy" title="JoyAgent · 7 管道全部健康">
  <span class="lamp-dot"></span>
</button>
```

```css
.health-lamp { padding: 8px; background: transparent; border: none; border-radius: 6px; cursor: pointer; }
.lamp-dot {
  display: inline-block; width: 10px; height: 10px;
  border-radius: 999px;
}
.lamp-healthy .lamp-dot {
  background: var(--joyagent-healthy);
  box-shadow: 0 0 0 3px color-mix(in oklab, var(--joyagent-healthy) 25%, transparent);
  animation: lamp-pulse 2.4s ease-in-out infinite;
}
.lamp-degraded .lamp-dot {
  background: var(--joyagent-degraded);
  box-shadow: 0 0 0 3px color-mix(in oklab, var(--joyagent-degraded) 35%, transparent);
  animation: lamp-pulse 1.2s ease-in-out infinite;
}
.lamp-down .lamp-dot {
  background: var(--joyagent-down);
  box-shadow: 0 0 0 3px color-mix(in oklab, var(--joyagent-down) 35%, transparent);
}
@keyframes lamp-pulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50%      { opacity: 0.7; transform: scale(1.15); }
}
```

### 聚合函数

```js
function aggregateHealth(items) {
  if (items.some(i => i.health === 'down'))     return 'down';
  if (items.some(i => i.health === 'degraded')) return 'degraded';
  return 'healthy';
}
```

### React 实现参考

完整 React 版本（含 Drawer 展开）见 v1 项目 `assets/components-business-a.jsx#JoyAgentLamp`。

### 反例

- ❌ 用文字"服务正常"代替灯点 → 远距离/瞥一眼识别不出
- ❌ 用 traffic-light（红/黄/绿三个灯都画出来）→ 占空间且没必要
- ❌ healthy 不带脉冲 → 显得"是死的"，用户不确定监控是否还在跑
- ❌ 把"绿灯"直接放大到 60px → 抢眼，喧宾夺主；保持 10×10 + halo 即可

---

## 25. ThemeSwitcher（主题切换器 · 4 维 🆕 v1.9）

> 适用：原型评审神器 / 多品牌项目的运行时切换 / 用户偏好持久化。完整骨架见 [`../templates/theme-switcher.html`](../templates/theme-switcher.html)。

### 4 维度

1. **明暗模式** `body.light` / `body.dark`
2. **配色方案** 5 套（红 / 蓝 / 橙 / 绿 / 紫 → `body.scheme-{name}`）
3. **界面密度** `body.density-comfy` / `body.density-compact`
4. **持久化** localStorage（key: `themePref`）

### HTML 结构（顶栏右侧 dropdown）

```html
<div class="theme-switcher">
  <button class="theme-trigger" title="主题偏好">🎨</button>
  <div class="theme-menu" hidden>
    <div class="theme-section">明暗模式</div>
    <div class="theme-row">
      <button data-theme-mode="light" class="active">☀ 浅色</button>
      <button data-theme-mode="dark">🌙 深色</button>
    </div>
    <div class="theme-section">配色方案</div>
    <div class="theme-swatches">
      <button data-theme-scheme="red"    class="active"><span style="background:#E1251B"></span>京东红</button>
      <button data-theme-scheme="blue"><span style="background:#2563EB"></span>蓝色</button>
      <button data-theme-scheme="orange"><span style="background:#F26B2B"></span>橙红</button>
      <button data-theme-scheme="green"><span style="background:#059669"></span>绿色</button>
      <button data-theme-scheme="purple"><span style="background:#7c3aed"></span>紫色</button>
    </div>
    <div class="theme-section">界面密度</div>
    <div class="theme-row">
      <button data-theme-density="comfy" class="active">舒适</button>
      <button data-theme-density="compact">紧凑</button>
    </div>
  </div>
</div>
```

### Vanilla JS（持久化 + 即时生效）

```js
const THEME_KEY = 'themePref';
const SCHEMES = ['red', 'blue', 'orange', 'green', 'purple'];
const DENSITIES = ['comfy', 'compact'];

function loadTheme() {
  try { return JSON.parse(localStorage.getItem(THEME_KEY)); } catch { return null; }
}
function saveTheme(t) {
  try { localStorage.setItem(THEME_KEY, JSON.stringify(t)); } catch {}
}
function applyTheme(t) {
  const b = document.body;
  ['light','dark'].forEach(c => b.classList.remove(c));
  b.classList.add(t.mode);
  SCHEMES.forEach(s => b.classList.remove('scheme-' + s));
  b.classList.add('scheme-' + t.scheme);
  DENSITIES.forEach(d => b.classList.remove('density-' + d));
  b.classList.add('density-' + t.density);
}

const theme = loadTheme() || { mode: 'light', scheme: 'red', density: 'comfy' };
applyTheme(theme);

// 绑定事件（统一委托）
document.addEventListener('click', (e) => {
  const t = e.target.closest('[data-theme-mode], [data-theme-scheme], [data-theme-density]');
  if (!t) return;
  if (t.dataset.themeMode)    theme.mode    = t.dataset.themeMode;
  if (t.dataset.themeScheme)  theme.scheme  = t.dataset.themeScheme;
  if (t.dataset.themeDensity) theme.density = t.dataset.themeDensity;
  applyTheme(theme); saveTheme(theme);
  // 刷新按钮 active 状态
  document.querySelectorAll('[data-theme-mode],[data-theme-scheme],[data-theme-density]').forEach(b => b.classList.remove('active'));
  document.querySelector(`[data-theme-mode="${theme.mode}"]`).classList.add('active');
  document.querySelector(`[data-theme-scheme="${theme.scheme}"]`).classList.add('active');
  document.querySelector(`[data-theme-density="${theme.density}"]`).classList.add('active');
});
```

### 实战经验

- **持久化必需**：用户切换后刷新页面要保持，否则评审人觉得"功能假"
- **吸顶或顶栏右侧**：放底部隐藏太深；放页面中间又影响布局
- **配色方案的 swatch 大圆点**：让用户瞥一眼就分清"红/蓝/橙/绿/紫"，不必读文字
- **生产环境保留还是隐藏**：内部运营端保留（用户偏好）；客户端外发可隐藏（避免品牌混乱）
- **5 × 2 × 2 = 20 种组合** 全部能渲染才算合格，原型评审时必须挨个切一遍验证 dark + 各 scheme 都不掉色

### 反例

- ❌ 只支持 dark mode toggle 不支持 scheme → 多品牌定制需求时还要再造
- ❌ 切换器藏在"设置 → 显示偏好"里 → 评审时只能演示一种，错失 10 组合的视觉效果
- ❌ 不持久化 → 用户切换后刷新被坑，认为"切换没生效"
- ❌ scheme 用文字选择器（下拉 5 个选项）→ 视觉感弱，圆点 swatch 才有"配色"感
