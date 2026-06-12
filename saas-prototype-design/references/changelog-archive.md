# Changelog 归档(v1.x 历史条目)

> v2.2 起,SKILL.md 的 Changelog 只保留最近大版本;v1.x 时代的演进记录归档于此,内容原样保留。

- **2026-05-27 · v1.9** — v1 原型沉淀（55+ 页迭代 · 多主题 + 业务组件）
  - **design-tokens.md 扩展**（+8 节）：
    - §配色方案（5 套：红 / 蓝 / 橙 / 绿 / 紫 · light/dark 正交 = 10 组合）
    - §明暗双主题完整 base 变量（含 dark 模式状态色 / shadow 数值调整）
    - §界面密度（comfy / compact · `--pad-y` / `--card-pad` / `--row-pad`）
    - §评级徽章色（A-E 5 级 · 适用 SLA / 评分 / 评级系统）
    - §能力域色扩展为 A-E + X（6 域，新增 E 域）
    - §服务健康灯色（healthy / degraded / down 3 态聚合）
    - §告警严重度色（P0-P3 4 级 · 红 / 橙 / 黄 / 灰）
    - §等宽数字字体 `--font-num` + `.tabular` class
  - **component-patterns.md 扩展**（新增 §21-§25）：
    - §21 RatingBadge（ABCDE · sm/md/lg · 含 box-shadow）
    - §22 RadarChart（5 维能力雷达 · 当前 vs 基线 · React + Recharts）
    - §23 AlarmCard（P0-P3 告警卡 · 左侧色条 + endpoint pill + 取证/处置）
    - §24 ServiceLamp（服务健康灯 · 3 态脉冲动画 · 聚合规则）
    - §25 ThemeSwitcher（4 维切换：明暗 / 配色 / 密度 / 持久化）
  - **templates 扩展**：
    - tokens.css +160 行（5 scheme × 2 mode + density + 评级/能力域/灯/告警/数字 token + 组件 CSS）
    - 新增 `theme-switcher.html`（完整可用骨架 · 含 demo 区演示 KPI / 徽章 / 灯 / 告警卡）
  - 适用：多品牌项目、评级 / SLA / 监控告警系统的原型与产品设计

- **2026-05-18 · v1.8.1** — 反模式 1 子案例「v1.0 启用 / 范围 banner」强化（第 4 次踩同坑）
  - 在 anti-patterns.md 反模式 1 加专项子案例「v0.1 仅启用 / v1.0 即将启用 / 一期范围 / 完整规范在 v1.x」
  - 列 6 类形态 + 5 行替代方案对照表 + 「为什么 PM 总想加 + 真相」分析 + grep 排查脚本
  - 全局清扫多个迭代页面共 11 处违例（多种违例类型 · 详见 anti-patterns.md 反模式 1b 全文）
  - 触发原因：用户第 4 次明确说「这类非面客的实际内容不要放在原型里面」
  - 教训：以前的「banner 子案例」只举了一个例子，没明示"v1.0 启用 / `<details>` 折叠 / 字段值带版本号"等多种变体，导致下次又踩

- **2026-05-18 · v1.8** — vendor 双端入驻流程沉淀
  - **§8 Drawer 新增 8a「双模式（写 vs 读）」**：审批/审核类页面 audit 模式 vs view 模式复用同一 drawer，按 mode 切换决策区显隐
    - 关键：mode 由调用方决定 · 基础信息永远展示 · `mode='audit'` 但状态非 pending 时 fail-safe 降级为 view
    - 反例：把审核与查看做成两个 drawer
  - **新增 §20「申请流程页（Stepper + 状态分支 UI）」**：
    - 适用：用户主动提交 → 平台审核 → 通过/驳回 类页面（入驻 / 订单 / 工单 / 报销 / 变更申请）
    - 4 状态字典：draft / submitted / approved / rejected · 每态对应 stepper + banner + 表单 readonly + footer 按钮 4 维差异
    - 关键设计：单页 + stepper + 按状态切换 UI（不做 N 个独立页面）
    - 演示用状态切换器（右上红色虚线框 + 4 选项下拉），原型评审必备 · 生产环境删除整个元素
    - 反例：4 个独立页面 / 没 stepper 只 banner / driven by item.status 自动切换 / stepper 都用绿色完成态 / 驳回态表单只读
  - 来源：双端入驻 + 审核流程项目的 drawer 双模式重构实战

- **2026-05-18 · v1.7.1** — 反模式 28 修正最终写法（二次踩坑）
  - 第一次"精细化"写法 `if(!event.target.closest('[data-action]'))event.stopPropagation()` **仍有 bug**：因为 `closest` 沿祖先链一路找到 modal 外的 mask（mask 自身有 data-action），导致点击 input 等控件也触发 modal-close 闪退
  - 最终正确写法：`var a=event.target.closest('[data-action]');if(!a||!this.contains(a))event.stopPropagation()` — 用 `this.contains(action)` 把祖先查询范围限定在 modal 自身以内
  - 6 个文件 10 处 modal 全部重新升级
  - 教训：任何用"祖先查询"修 bug 的写法，**都要显式限制查询的祖先范围**，不能依赖 closest 自然停止
  - 来源：endpoint-management v2.0 用户测试发现"点击新建 modal 内控件就闪退"

- **2026-05-18 · v1.7** — endpoint-management v2.0 + vendor-info v1.2 bug 沉淀
  - **component-patterns 新增 §19「混合表单 + JSON 配置」**：
    - 适用场景：API 接入 / Webhook / SSO / 第三方支付 / 数据源连接等"配置异构外部服务"页面
    - 分层原则：强类型必填走表单（base_url / api_key / auth_type）· 协议/能力差异化字段走 JSON 块（connection_config）
    - 3 个关键交互：① 上下游联动 info-card · ② 「🪄 按协议生成默认模板」按钮 · ③ JSON 编辑器样式（mono + spellcheck=false + 详情态用 `<pre>`）
    - 落库建议：JSONB column · 整体替换不做字段级 UPDATE
    - 反例：全 UI 条件渲染 / 全 JSON 编辑器 / 模板硬编码到 HTML / 没关 spellcheck / info-card 显示位置太远
  - **anti-patterns 新增反模式 28「modal 容器粗放 stopPropagation」**：
    - chrome.js document 级 listener + modal 容器 stopPropagation 的根本性冲突
    - 修复：`onclick="if(!event.target.closest('[data-action]'))event.stopPropagation()"`
    - 影响范围：所有用 chrome.js 委托 + modal 嵌套结构的页面（曾在 6 页 8 modal 同时复现）
    - 含 grep 排查脚本
  - 来源：endpoint-management v2.0（连接配置 JSON / 状态机 7 态 / 详情 3 sub-tab）+ vendor-info v1.2（修关闭按钮 bug 后批量扫描）

- **2026-05-17 · v1.6** — model-management v1.1 / v1.2 字段中文化 + 状态机 + 分页 + 复选框联动蒸馏
  - **SKILL.md 不可违反原则 10 → 12**：
    - 新增 #11「字段名优先中文」（label/column/placeholder/message 一律中文，仅 ID/code/mono 保留英文）
    - 新增 #12「原型用真实业务示例数据」（禁 data1/Lorem/测试模型 A，禁全数字编号占位）
  - **反模式 1（PM 术语）补 2 个子案例**：
    - 子案例 X：研发期"现有系统术语对照表"不进 UI（应放迁移文档）
    - 子案例 Y：page-header-desc 副标题不堆描述性长句（用户从菜单进入已知页面）
  - **component-patterns 新增 §16 资源状态机字典**：
    - 推荐 3 态字典（暂存/启用/停用，面向下游可见性维度）
    - 推荐 4 态字典（评测/审核流程）
    - 反例：把流程中间态（评测中/待审批）当资源主状态，导致状态机指数膨胀
  - **component-patterns 新增 §17 标准分页器**：
    - 「共 N 条 · ‹ · 1-6 … 末页 · › · M 条/页 · 前往 X 页」完整组件
    - CSS class .pager / .pg-btn / .pg-select / .pg-jump 规范
    - 数据少于 1 页时仍显示（保持视觉一致性）
  - **component-patterns 新增 §18 批量操作真实联动**：
    - 复选框 td 必须 stopPropagation（不冒泡到行 onclick）
    - 全选支持 indeterminate 半勾态
    - 批量按钮 onclick 必须真校验 + 二次确认（含 ≤3 个对象名预览）+ 真实更新 UI
  - 来源：model-management v1.2（10 个真实模型示例 + 状态机三态 + 删现有系统对照 + 删描述 + 分页 + 复选框 + 字段中文）

- **2026-05-17 · v1.5** — endpoint-management v1.1 对齐 model-management 蒸馏
  - 反模式 7（删功能时文案残留）：补案例 B「Tab 标签括号数字 (N) vs 内部节点数错位」子案例
  - 新增反模式 27：segmented tab 与 filter 中 status 字段双入口（语义重复 / source of truth 冲突）
  - 来源：endpoint-management 同时存在 seg-tab 6 态分段 + filter 中 status 下拉，状态机历史 tab 标签写「(4)」实际渲染 5 个节点
  - 适用：所有带状态机的资源列表页（endpoint / 工单 / 订单 / 任务 / 评测 run / 审批流）

- **2026-05-15 · v1.4** — eval-sets v2.1 清理蒸馏
  - 反模式 1（PM 术语）：补「列表分组顶部 N 个示例 · 点击卡片查看详情」子案例
  - 新增反模式 26：filter-form 筛选项必须对应数据模型上的实际列，派生字段不进筛选
  - 来源：eval-sets filter-form 里的 Metric 项实际是 template 派生，无法真实查询

- **2026-05-15 · v1.3** — eval-sets v2.0 重设计蒸馏
  - 新增反模式 25：列表卡片字段必须 ⊆ 上游收集字段 ∪ 系统派生字段
  - 来源：eval-sets 卡片显示「Metric」但上传向导没收集 Metric（实际是模板类型决定的）
  - 适用：所有「上游表单 → 下游列表卡片」链路（订单 / 任务 / 用户 / 评测集）

- **2026-05-15 · v1.2** — 加入「强制评估时机 + 3 步评估流程」
  - 在「演进与维护」段加 6 个触发时机表 + 5 个评估问题 + 3 个反向禁忌
  - 目的：避免「等用户提醒才更新」/「积压太多一次性蒸馏」两种失败模式

- **2026-05-15 · v1.1** — eval-sets 6 条改动清单蒸馏
  - 反模式 1（PM 术语）：补「v0.1 评测范围 banner」子案例
  - 新增反模式 22：KPI 副标用占位文案而非真实数据构成
  - 新增反模式 23：单层列表页加面包屑
  - 新增反模式 24：KPI 卡 padding 太松占满首屏
  - 组件模式 §4 拆为「4a 仪表盘型 / 4b 紧凑型」两种 KPI 规格

- **2026-05-14 · v1.0** — 初版（企业 SaaS 项目 v0.1 迭代 30+ 轮后蒸馏）
  - 设计语言：品牌红 + tokens.css + chrome.css
  - 组件模式：sidebar / topbar / filter-form / list-toolbar / wizard / drawer / modal
  - 历史版本保护机制（snapshot + meta + agent-protocol）
  - 反模式案例 20+ 条

- **2026-05-15 · v1.2** — 新增跨平台支持段（codex / cursor / antigravity / gemini / copilot 路径与 Self-Evolving 触发方式）
