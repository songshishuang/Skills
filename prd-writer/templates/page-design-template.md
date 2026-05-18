# 页面功能详细设计 · 7 段标准模板

> **用途**：PRD §6.2 「核心页面功能详细设计」每个页面的标准展示模板。开发知道"做什么"、QA 知道"验什么"、运营知道"怎么用"。

## 使用说明

- 每个核心页面用本模板填一段表格
- 7 段（业务场景 / 页面布局 / 关键字段 / 交互动作 / 状态变化 / 异常处理 / 验收点）顺序固定不可换
- 每段 ≤ 30 字精炼 · 整体每页 ≤ 50 行
- 验收点用 ① ② ③ 编号，让 QA 直接勾选

---

## 模板（Markdown 表格）

```markdown
### X.Y.Z 页面名 · `xxx.html`

| 维度 | 内容 |
|---|---|
| **业务场景** | （这页解决什么业务问题 · 谁主要用 · 1-2 句话）|
| **页面布局** | （区块布局：sidebar / topbar / 主区结构 / KPI 卡 / filter / 表格 / drawer / modal）|
| **关键字段** | （数据字段清单 · 注明字段来源 = 数据模型上游收集字段 ⊆ §6.1 业务对象 · 反模式 25 校验）|
| **交互动作** | （所有 click / hover / 提交触发的反馈 + 跳转 + toast / modal / drawer · 编号列）|
| **状态变化** | （涉及状态机的页面要列状态迁移 · 如评测 run 6 态 / endpoint 7 态 · 简单页面写"无"）|
| **异常处理** | （校验 / 失败 / 二次确认 / 权限不足 等边界场景 · 编号列）|
| **验收点** | ① ② ③ ... 明确可勾选的验收条件 · 给 QA 直接用 |
```

---

## 模板（HTML 卡片版 · 给 PRD HTML 用）

```html
<div class="page-design">
  <div class="pd-head">X.Y.Z 页面名 <span class="file">· xxx.html</span></div>
  <table>
    <tr><th>业务场景</th><td>...</td></tr>
    <tr><th>页面布局</th><td>...</td></tr>
    <tr><th>关键字段</th><td>...</td></tr>
    <tr><th>交互动作</th><td>...</td></tr>
    <tr><th>状态变化</th><td>...</td></tr>
    <tr><th>异常处理</th><td>...</td></tr>
    <tr><th>验收点</th><td>① ... · ② ... · ③ ...</td></tr>
  </table>
</div>
```

配套 CSS（在 HTML 的 `<style>` 中）：

```css
.page-design { background: var(--c-bg); border: 1px solid var(--c-border); border-radius: var(--radius-md); margin: 12px 0; overflow: hidden; }
.page-design > .pd-head { padding: 10px 14px; background: var(--c-primary-bg); border-bottom: 1px solid var(--c-border); font-weight: 600; color: var(--c-primary); }
.page-design > .pd-head .file { font-family: monospace; font-size: 12px; color: var(--c-text-sec); font-weight: normal; margin-left: 6px; }
.page-design table { margin: 0; }
.page-design table th:first-child { width: 110px; background: var(--c-bg-elev); color: var(--c-text-sec); font-weight: 700; }
```

---

## 7 段填写指南

### 业务场景

- **回答 2 个问题**：这页解决什么业务问题？谁主要用？
- **格式**：1-2 句话 · 不超过 30 字
- **❌ 不要写**：「列表页」「展示数据」（太泛）
- **✅ 示例**：「评测工程师主入口 · 看任务列表 + 直达流水线监控」

### 页面布局

- **列出区块结构**：sidebar / topbar / page-header（h1 + desc）/ KPI / filter-form / list-toolbar / 表格 / drawer / modal
- **格式**：用 `+` 连接 · 标注每块的关键属性
- **✅ 示例**：「page-header（仅 h1）+ KPI 4 卡 + 6 态 seg-tab + filter-form 5 主行 + list-toolbar + 表格 9 列 + 详情 drawer 3 sub-tab」

### 关键字段

- **数据字段清单** · 必须 ⊆ §6.1 业务对象字段（反模式 25 · 字段必须来自上游收集字段）
- **格式**：字段名 · 业务含义 · 取值范围（如有）
- **❌ 不要写**：PK / FK / 类型（这些进工程文档）
- **✅ 示例**：「run_id（任务 ID · 格式 ADM-NNNNN）/ endpoint_id / 模型族+模型 / 供应商主体+VND / 状态 5 态 / 综合分 / 发起人 / 创建时间 / 完成时间」

### 交互动作

- **所有 click / hover / 提交触发的行为**
- **格式**：用 `·` 分隔多个动作 · 标 trigger → response
- **❌ 不要写**：「点击有反应」「正常点击」（太泛）
- **✅ 示例**：「seg-tab 点击客户端过滤 · 行 click 打开 drawer · evaluating 行显示「🔧 监控」直达 pipeline · 已驳回行加「重测」按钮」

### 状态变化

- **涉及状态机的页面必填** · 列状态迁移（如评测 run 6 态 / endpoint 7 态）
- **格式**：引用 §6.x 状态机段，或简短描述
- **不涉及状态机**：写"无（纯导航 / 纯展示）"

### 异常处理

- **校验 / 失败 / 二次确认 / 权限不足 等边界场景**
- **格式**：编号列出（①②③）
- **❌ 不要写**：「按需处理」（等于没写）
- **✅ 示例**：「① 行内监控按钮按状态变化（仅 evaluating 显示）· ② 供应商提交 endpoint 进入待评测，发起人显「供应商 X 提交」+ tooltip · ③ 同 endpoint 24h 内重复提交 toast 提示」

### 验收点

- **可勾选的具体条件** · 给 QA 直接用
- **格式**：① ② ③ 编号 · 每条 ≤ 30 字
- **❌ 不要写**：「功能正常」「数据正确」（不可验收）
- **✅ 示例**：
  - ① 10 行 mock 覆盖 5 态 + 7 模型族
  - ② seg-tab 6 按钮真实过滤（不切空态 tab-content）
  - ③ 行点击触发 drawer
  - ④ 「🔧 监控」按钮 evaluating 行可见
  - ⑤ 副标数据来源真实（非占位）

---

## 反模式（不要这样填）

| ❌ 反模式 | ✅ 正确做法 |
|---|---|
| 每段一句话「正常显示」「点击有反应」 | 具体到字段 / 交互细节 / 错误码 |
| 验收点写「功能正常」 | 给 ①②③ 编号 + 可勾选条件 |
| 关键字段写 SQL DDL / JSON schema | 业务字段清单 · 字段类型留工程文档 |
| 异常处理写「按需处理」 | 列具体边界（24h 重复 / 权限不足 / 必填校验 等）|
| 状态变化写「正常流转」 | 引用 §6.x 状态机段或简短列状态迁移 |
| 页面布局只写「列表 + 详情」 | 列具体区块（KPI / filter / seg-tab / drawer 等）|
| 业务场景写「列表页」 | 1-2 句话 · 谁用 · 解决什么 |
