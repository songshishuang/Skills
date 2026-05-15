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
