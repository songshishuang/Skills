---
name: pm-project-scaffolding
description: 初始化标准 PM 项目目录脚手架。当用户提到「初始化新 PM 项目」「pm 脚手架」「pm-init」「新建产品项目」「create PM scaffold」「产品项目模板」「项目目录骨架」时使用。生成包含 docs / prototypes / skills / training / app / archive / Logs 等覆盖 PM 完整生命周期 8 阶段（研究 / 规划 / 设计 / 开发 / 发布 / 培训 / 运营 / 归档）的标准目录结构。支持 ai-saas / generic-saas / mobile-app / internal-tool 四种产品类型，可选启用 prototypes / skills 模块。基于某 AI 运营平台 项目的实战目录治理沉淀。
---

# PM Project Scaffolding · 产品项目脚手架

## 这个 Skill 是做什么的

把一个空目录或新建仓库，**3 分钟内**初始化为符合产品经理工作流的标准项目结构——12 项顶层条目覆盖 PM 项目完整生命周期，每个目录配占位 README 说明用途和沉淀准则。

## 触发场景

用户表达以下意图时启用此 skill：

- 「初始化一个新的 PM 项目」
- 「帮我创建产品项目目录结构」
- 「用标准脚手架建项目」
- 「pm-init {project-name}」
- 「新项目要怎么组织目录」
- 「产品项目模板」

## 执行步骤

### 第 1 步：收集 5 个核心参数

向用户提问（**不要假设**，依次问清）：

1. **`project_name`**：项目目录名（英文小写连字符，例：`my-product` / `awesome-saas`）
2. **`project_tagline`**：一句话定位（用于 README.md，例：「企微域一体化 AI 运营平台」）
3. **`project_type`**：四选一
   - `ai-saas`——AI/Agent 产品（含 `prototypes/` + `skills/`）
   - `generic-saas`——通用 SaaS（含 `prototypes/`，不含 `skills/`）
   - `mobile-app`——移动应用（含 `prototypes/`，不含 `skills/`）
   - `internal-tool`——内部工具（不含 `prototypes/` 不含 `skills/`）
4. **`roles`**：业务角色数组（仅 `project_type` 含 `prototypes/` 时问）
   - 例：`operator,agent,admin`（SCRM 三角色）/ `customer,merchant`（双边市场）/ `user`（单端）
5. **`enable_firebase`**：是否生成 `firebase.json` 占位（`yes` / `no`）

### 第 2 步：确认参数

把收集的参数用表格回显给用户，**等用户明确说「执行」「确认」「OK」**再下一步。

### 第 3 步：调用脚本生成骨架

```bash
bash skills/pm-project-scaffolding/scripts/init.sh \
  --name "{project_name}" \
  --tagline "{project_tagline}" \
  --type "{project_type}" \
  --roles "{roles}" \
  --firebase "{enable_firebase}" \
  --target "{absolute_target_path}"
```

`--target` 是目标父目录的绝对路径。脚本会在该路径下创建 `{project_name}/` 子目录。

### 第 4 步：报告生成结果

执行完后给用户：
- 生成的目录树（`find {target}/{name} -maxdepth 3 -type d`）
- 关键文件位置（README.md / CHANGELOG.md / CLAUDE.md / docs/roadmap.md）
- 接下来用户该做的 3 件事：
  1. 填充 README.md 项目描述
  2. 在 `docs/prd/` 写第一份 PRD
  3. 用 `git init && git add -A && git commit -m "init: PM scaffolding"` 建仓

### 第 5 步（可选）：智能定制

如果用户提到具体场景（例：「这是个企业 SaaS，主要面向 HR 角色」），AI 应该**额外**生成或改写：

- README.md 的项目定位段（基于 tagline + 用户描述）
- docs/roadmap.md 的初始里程碑（基于产品类型推断 Q1/Q2 应该做什么）
- docs/decisions/ADR-001-初始技术选型.md（如果用户提到选型问题）
- training/internal/sales-kit.md 的核心价值段（基于产品类型）

**不要**自动定制 PRD 完整内容——那需要用户深度参与。

## 输出预期

成功执行后用户会得到：

```
{project_name}/
├── README.md  CHANGELOG.md  CLAUDE.md
├── (firebase.json — 可选)
├── docs/{prd,decisions,product-planning,market-research,user-research,data-analysis,releases}/
│   └── roadmap.md
├── prototypes/{各角色}/  + assets/  + index.html  （仅 ai-saas/generic-saas/mobile-app）
├── skills/{plan}/        （仅 ai-saas）
├── training/{customer,internal}/
├── app/  archive/  Logs/
```

约 30 个文件、25 个目录，全部带占位 README 说明用途与沉淀准则。

## 关键约束

- **不要直接修改用户工作目录的现有项目**——只在用户明确指定的 target 路径下新建
- **不要在 target 已存在同名目录时覆盖**——脚本会检测并报错退出
- **触发 skill 后必须先问参数**——不允许 AI 自己脑补 project_name 之类的关键信息
- **生成后建议用户立即 `git init`**——脚手架不预置 git，用户决定要不要版本控制

## 相关参考资料

详见 `references/` 目录：

- [`directory-conventions.md`](./references/directory-conventions.md) — 12 个顶层条目各自的用途、子结构、沉淀准则
- [`naming-rules.md`](./references/naming-rules.md) — 文件命名规范（ADR / Release Notes / 日志 / Persona 等）
- [`lifecycle-mapping.md`](./references/lifecycle-mapping.md) — 8 阶段生命周期 → 目录映射 + 何时新建什么目录

## 设计哲学

这套脚手架基于 6 大设计原则：

1. **PM 入口明确**——`docs/` 作为顶层入口
2. **演进路径线性**——docs → prototypes → skills → app
3. **对外可分发**——`skills/{name}/` 是干净的可交付包
4. **活跃 vs 归档物理隔离**——`archive/` 不污染日常视野
5. **决策可回溯**——`docs/decisions/` 用 ADR 沉淀「为什么」
6. **全生命周期覆盖**——8 个阶段都有专属目录

如果用户问「为什么这么设计」，引用 `references/directory-conventions.md` 中的对应章节回答。

## 来源

蒸馏自 2026-Q2 某 AI 运营平台项目的目录治理实战——91 文件 git mv 大重构 + PM 视角 9 维度结构 + 三轮迭代（轻量版 / 中量版 / 上线 + 培训补充）。

## 🌐 跨平台支持

本 skill 是纯目录脚手架知识，**跨平台完全通用**。各平台安装路径：

| 平台 | 安装路径 |
|---|---|
| Claude Code / Desktop | `~/.claude/skills/pm-project-scaffolding/` |
| Cursor | `<project>/.cursor-plugin/skills-songshishuang/pm-project-scaffolding/` |
| Codex CLI / App | `~/.codex/plugins/songshishuang-skills/skills/pm-project-scaffolding/` |
| Gemini CLI / Antigravity | `gemini extensions install github.com/songshishuang/Skills` |
| GitHub Copilot CLI | `gh copilot marketplace add songshishuang/Skills` |

一键安装脚本与详细说明见仓库根 [INSTALL-MULTI-PLATFORM.md](https://github.com/songshishuang/Skills/blob/main/INSTALL-MULTI-PLATFORM.md)。

## Changelog

- **2026-05-09** 初始版本（蒸馏自某 AI 运营平台 91 文件 git mv 大重构）
- **2026-05-15** 新增跨平台支持段
