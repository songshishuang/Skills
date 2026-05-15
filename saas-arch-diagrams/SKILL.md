---
name: saas-arch-diagrams
description: 设计企业 SaaS 类产品的两类核心架构图：「产品架构图」（产品在更大生态中的定位 · 4 层视图）和「功能架构图」（4 层纵向 × 能力域横向 chip · 3 级嵌套）。当用户提到「画产品架构图」「功能架构图」「product architecture diagram」「functional architecture」「画一张架构图」「按 4 层结构梳理功能」「区分多端功能」时使用。蒸馏自 JMaaS（京东 MaaS 供应链管理平台）项目的迭代实战，覆盖 SaaS 多端产品的常见结构问题（端 / 服务混用、能力域平铺、版本视角混淆、空白区过多、合并模块违反逻辑等）。
---

# SaaS 架构图设计

## 这个 Skill 解决什么

企业 SaaS 类产品在做产品评审 / 范围判定 / 迭代规划时，需要两类截然不同的架构图：

1. **产品架构图（Product Architecture）** —— 产品在更大生态中的定位、面向谁、提供什么能力域、与外部依赖的边界
2. **功能架构图（Functional Architecture）** —— 平台具体功能的完整清单，按层 + 能力域 + 子能力 3 级嵌套

这个 skill 提供两类图的**结构模板、CSS 设计 token、内容组织原则、常见陷阱清单**，让你避开 6 轮以上的反复返工。

## 触发场景

- 「画产品架构图」「画功能架构图」「按 4 层结构画下功能」
- 「我需要让别人看清楚我们做什么、面向谁」
- 「这个图能不能区分一下哪些功能是哪个端」
- 「按能力域分类一下」「按子能力做嵌套」
- 「product architecture diagram」「functional architecture for SaaS」

## 两类图的根本区别

| 维度 | 产品架构图 | 功能架构图 |
|---|---|---|
| 回答问题 | 我们做什么、面向谁、与下游的边界 | 平台具体有哪些功能模块 |
| 视角 | 自上而下看生态 | 自内而外看实现 |
| 主轴 | 用户 → 应用 → 能力 → 底座 | 端 → 服务 → 数据 → 底座 |
| 颗粒度 | 能力域级（A/B/C/D） | 模块级（每个功能一卡） |
| 适用场景 | 给老板 / 跨团队 / 外部讲产品定位 | 内部研发 / PM 做范围判定与迭代规划 |
| 是否分版本 | **不分** | **不分**（全局功能视图） |

## 不可违反的原则

读图者最容易抓出来的 6 个"硬伤"，做之前先内化：

1. **不要分版本** —— 架构图是全局视角，"v0.1 / 远期 / 未来" 这类标记一律不要出现。版本规划放 roadmap / PRD。
2. **不要省略合并** —— `④-⑧ 高阶节点` 合并为一卡是为了视觉省事，违反"内容逻辑"。8 个节点就要画 8 张卡。
3. **端的定义要纯粹** —— "端"是用户使用的客户端，**只能是**：运营端 / 供应商端 / 客户端 / 管理端 / 第三方平台。**绝不能**包含「后端」「业务服务」「数据」这种技术语言。
4. **服务和页面不能混** —— 评测任务列表（页面）和评测流水线 controller（服务）属于不同层次，硬放一起会让人看不清。
5. **能力域不能平铺** —— 域内功能必须再分子能力，3-7 个并排卡片堆在一起没有层次。
6. **不要为了对齐而留空白** —— grid 等宽分配 4 列时，某列卡片少就空一片。要按内容动态分配 col-span。

## 产品架构图：4 层视图

### 结构

```
═══ L1 用户与场景 ═══  谁在用 / 在什么场景下用
═══ L2 应用层端 ═══     端的 UI 入口
═══ L3 能力域 ═══       4-5 个 capability domain（A/B/C/D/E）
═══ L4 平台底座 ═══     执行 / 观测 / 通信 / 数据治理 等共用基础
                       ⇩
═══ 外部依赖 / 下游 ═══  下游消费方（如本平台是 MaaS 子系统则下游是 API 网关）

横切关注点（纵向条带，跨所有层）：治理与合规 · 安全 · 可观测
```

### 关键判断题

写第一张产品架构图前先回答清楚：

- **我们的产品是更大生态里的子系统吗**？是 → 顶部 Hero 写"作为 X 的 Y 子系统"，底部画外部依赖箭头
- **谁是直接用户**？分内部端（admin 多角色）和外部端（vendor / customer / partner）
- **有没有不在本平台范围但要协同的能力**？标 `m-out`（dotted 置灰 + line-through），不画进能力域内
- **是否有横切关注点**？治理 / 安全 / 计量 等跨所有能力域，用纵向 sidebar 条带

## 功能架构图：4 层纵向 × 能力域横向

### 顶层结构

```
L1 端层 · User Endpoints          ← 用户界面
  ├── 端 A（如 运营端）
  │   ├── 能力域 1 子组
  │   │   ├── 子能力 1.1 → 卡片
  │   │   └── 子能力 1.2 → 卡片
  │   └── 能力域 2 子组
  │       └── ...
  ├── 端 B（如 供应商端）
  └── 端 C（如 第三方平台 · 置灰）

L2 业务服务层 · Business Services  ← 页面背后的能力
  ├── 能力域 A 服务
  │   ├── A1 子能力 → 服务卡片
  │   └── A2 子能力 → 服务卡片
  ├── 能力域 B 服务
  └── ...

L3 数据资产层 · Data Assets       ← 跨服务共用的数据
  ├── 主体数据（vendor / model / endpoint 表）
  ├── 业务数据（评测集 / 基线 / 账单）
  └── 监控 + 审计

L4 平台底座 · Platform Foundation ← 跨域基础设施
  ├── 执行引擎
  ├── 观测计量
  ├── 通信触达
  └── 数据治理
```

### 3 级嵌套规则

每张图都是这 3 级，缺一不可：

| 级别 | 用途 | 视觉容器 |
|---|---|---|
| L1 顶层 = 层（端 / 服务 / 数据 / 底座） | 大背景渐变 + 边框 | `.lyr-N` |
| L2 中层 = 能力域（A / B / C / D） | 浅色背景 + 实线边框 | `.subgroup-box` |
| L3 子层 = 子能力（A1 / A2 / B1 ...） | 虚线轻量框 / chip 头 | `.sub2-box` 或 `.sub3-block` |
| 卡片 = 单个功能模块 | 白底 + 左 3px 域色 accent + 软阴影 | `.module-card` |

### Col-span 填满规则（紧凑布局核心算法）

12 列网格内，每个子组（sub2 或 sub3）按卡片数动态分配 col-span，加起来必须 = 12，不能留空白。

```
1 卡片  → col-span-2 / 3 / 4 / 6 / 12（根据该行总卡数算）
2 卡片  → col-span-4 inner-2 / col-span-6 inner-2 / col-span-12 inner-2
3 卡片  → col-span-3 inner-1 / col-span-6 inner-3 / col-span-12 inner-3
4 卡片  → col-span-4 inner-2 / col-span-8 inner-4 / col-span-12 inner-4
8 卡片  → col-span-12 inner-4（占整行 · 2 行高）
N 卡片（N>8） → col-span-12 inner-4 多行
```

**强制规则**：每行 col-span 加起来必须 = 12，不能少。某行卡片差太多导致行高不齐时，宁可让小子组单独成行（col-span-12 inner-N）也不要让一行内 col 高度差超过 2 倍。

具体配置见 [`references/col-span-cookbook.md`](references/col-span-cookbook.md)。

## CSS 设计 token

完整模板见 [`templates/styles.css`](templates/styles.css)，核心 token：

```css
/* 4 层背景色（淡色 + 同色边框） */
.lyr-1 { background: linear-gradient(180deg, rgba(99,102,241,.08) 0%, rgba(99,102,241,.02) 100%); border: 1px solid rgba(99,102,241,.18); }  /* L1 indigo - 端层 */
.lyr-2 { background: linear-gradient(180deg, rgba(245,158,11,.07) 0%, rgba(245,158,11,.02) 100%); border: 1px solid rgba(245,158,11,.18); }  /* L2 amber - 服务层 */
.lyr-3 { background: linear-gradient(180deg, rgba(139,92,246,.07) 0%, rgba(139,92,246,.02) 100%); border: 1px solid rgba(139,92,246,.18); }  /* L3 violet - 数据层 */
.lyr-4 { background: linear-gradient(180deg, rgba(100,116,139,.08) 0%, rgba(100,116,139,.02) 100%); border: 1px solid rgba(100,116,139,.18); }  /* L4 slate - 底座 */

/* 能力域 chip（5 种 + X 共用） */
.dc-A { background: #f5e6ff; color: #6b21a8; }  /* 紫 */
.dc-B { background: #fef3c7; color: #92400e; }  /* 琥珀 */
.dc-C { background: #dbeafe; color: #075985; }  /* 蓝 */
.dc-D { background: #ffe4e6; color: #9f1239; }  /* 玫红 */
.dc-X { background: #f1f5f9; color: #475569; }  /* 灰 - 平台共用 */

/* 卡片 + 左 accent */
.module-card { background: #fff; border: 1px solid rgba(15,23,42,.06); border-left: 3px solid #cbd5e1; border-radius: 5px; padding: 6px 9px; box-shadow: 0 1px 2px rgba(15,23,42,.04); }
.dom-A { border-left-color: #a855f7 !important; }
.dom-B { border-left-color: #f59e0b !important; }
.dom-C { border-left-color: #0ea5e9 !important; }
.dom-D { border-left-color: #f43f5e !important; }

/* 不在本平台范围（dotted 置灰） */
.m-out { background: #f5f5f4 !important; border-style: dotted !important; opacity: .7; }
.m-out .ct { text-decoration: line-through; color: #78716c; }
```

## 标准实施流程

### Step 1 · 先做产品架构图（1-2 轮）

1. 写一句话定位：本产品是「X 平台的 Y 子系统」（如不是子系统则跳过）
2. 列出 4-5 个能力域（A/B/C/D/E），每个域 1 句话能讲清楚
3. 列出用户与场景（内部 / 外部，区分角色）
4. 标识不在本平台范围但要协同的能力（→ MaaS 平台、→ 外部 API 等）
5. 用 [`templates/product-arch-template.html`](templates/product-arch-template.html) 起手

### Step 2 · 再做功能架构图（3-5 轮）

1. **第一轮：列功能清单** —— 把所有功能列出来，标 (端，能力域，子能力)
2. **第二轮：按 4 层分类** —— 把功能放到 L1-L4 对应层
3. **第三轮：嵌套到 3 级** —— L1 内每个端按能力域分子组，每域按子能力再分一级
4. **第四轮：col-span 填满** —— 算每行 col 总和 = 12，调整子组宽度
5. **第五轮：检查 6 个硬伤** —— 见前文「不可违反的原则」逐条对照
6. 用 [`templates/functional-arch-template.html`](templates/functional-arch-template.html) 起手

### Step 3 · 评审 checklist（每次改完都过一遍）

参考 [`references/review-checklist.md`](references/review-checklist.md)，关键 12 条：

- [ ] 没有任何"远期" / "v0.x" / "未来" 等版本字样
- [ ] 没有把多个功能合并成"X-Y 节点"这种省略写法
- [ ] 端只包含"运营端 / 供应商端 / 第三方平台"，没有"后端"
- [ ] 页面和服务在不同层（L1 vs L2），没有混在一个子组
- [ ] 每个能力域内部按子能力分子组（不是平铺一堆卡）
- [ ] 每行 col-span 加起来 = 12，无右侧空白
- [ ] 每个卡片有能力域 chip 标识（A/B/C/D/X）
- [ ] 每个卡片左 accent 按域着色
- [ ] 不在本平台范围的能力用 dotted 置灰
- [ ] 横切关注点（治理 / 安全）独立标识，不混入能力域
- [ ] 描述用业务语言，避免「后端服务」「中间件」「微服务」等技术语
- [ ] 图例完整：能力域 chip + 状态色（m-out）

## 常见陷阱与对照案例

每条都附最初错误和修正方式，见 [`references/anti-patterns.md`](references/anti-patterns.md)：

1. **"评测集体系 22 模块" vs "评测集数据 + 评测集管理工具 拆开"** —— 数据资产和管理 UI 不是一个维度
2. **"报告产出 4 模块包含基线"** —— 行业基线是数据资产，不是报告产出
3. **"层 6a 对象 + 层 6b 底座"** —— 用 a/b 表示子层混乱，要么拆成独立层 7、要么不拆
4. **"评级算法 + 综合评分 + 行业基线 + 审批面板 全塞 ③ WHAT 段"** —— 评级是 D 风险域 / 审批是 L1 端层 / 基线是 L3 数据层
5. **"运营端 + 评测工程师 + 供应商 + 后端 + MaaS 5 个端"** —— 评测工程师是运营端内角色，后端不是端
6. **C4 路由 col-span-3 留 col-9 空白** —— 应该 col-span-12 inner-2，或并入其他子组同行

## 推荐工具栈

- Tailwind CSS CDN（快速 prototyping）
- 自定义 CSS variable token（域色 / 层色 / 状态色）
- Python 脚本生成 HTML（卡片多、布局规整，手写易错）
- Firebase Hosting / GitHub Pages（直接 deploy）

## 来源

蒸馏自 [JMaaS 项目](https://github.com/songshishuang/JMaas)（京东 MaaS 模型供应链管理平台）的 6 轮迭代实战：

- 第 1 轮：单层平铺 → 用户反馈"配色全是灰色，没有层次"
- 第 2 轮：加 v0.1 角标 → 用户反馈"全局视图不分版本"
- 第 3 轮：合并 ④-⑧ → 用户反馈"省略的功能定义"
- 第 4 轮：层 6a/6b → 用户反馈"a/b 区分混乱"
- 第 5 轮：用"后端"作为端 → 用户反馈"端和使用对象混用"
- 第 6 轮：col 等宽留空白 → 用户反馈"大量空白，紧凑并有层次"

每条都对应一个原则，固化在本 skill 中以避免后人走同样弯路。
