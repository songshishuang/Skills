# 命名规范 (Naming Rules)

文件 / 目录 / 关键文档的命名规范。AI 在生成新文件时遵循此处约定。

---

## 通用命名约束

| 元素 | 规则 | ✅ 例 | ❌ 反例 |
|---|---|---|---|
| 顶层目录 | 英文小写，单数为主，复数仅当含多个独立单元 | `docs/` `skills/` | `Docs/` `skill/` |
| 二级目录 | 英文小写，多词用连字符 | `market-research/` `user-research/` | `MarketResearch/` `user_research/` |
| Markdown 文档 | 小写 + 连字符 + `.md` | `roadmap.md` `sales-kit.md` | `Roadmap.MD` `sales_kit.md` |
| 顶层文件 | 全大写约定文件用大写 + 下划线 | `README.md` `CHANGELOG.md` `CLAUDE.md` | `readme.md` |
| 隐藏目录 | 用 `.` 前缀，工具配置类 | `.github/` `.vscode/` | `vscode_config/` |

---

## ADR 决策记录命名

格式：`ADR-NNN-{slug}.md`

- `NNN`：三位顺序编号（001, 002, ...）
- `slug`：英文小写连字符，描述决策核心

✅ `ADR-001-why-not-langchain.md`
✅ `ADR-002-multi-tenant-isolation-strategy.md`
✅ `ADR-015-deprecate-internal-cdp-api.md`

❌ `ADR-1-no-langchain.md`（编号要 3 位）
❌ `ADR-002-多租户隔离策略.md`（slug 用英文）
❌ `decision-2026-05-12.md`（不用日期，用编号）

**编号原则**：全局顺序号，不复用、不跳号。废弃的 ADR 也保留编号，新建一份新编号的「已替代 ADR-XXX」。

---

## Release Notes 命名

格式：`YYYY-MM-DD-{version}-release-notes.md`

- `YYYY-MM-DD`：实际向客户公告的日期
- `version`：产品对外版本号（不是 git tag）

✅ `2026-05-09-v1.0-release-notes.md`
✅ `2026-08-20-v1.5-beta-release-notes.md`
✅ `2026-12-01-2027-Q1-release-notes.md`（季度合并版）

❌ `release-notes-v1.0.md`（缺日期）
❌ `2026-05-09.md`（缺版本号 + 类型）

---

## Logs 日志命名

格式：
- 单日：`Logs/YYYY-MM/YYYY-MM-DD.md`
- 月度汇总：`Logs/YYYY-MM_汇总.md`

✅ `Logs/2026-05/2026-05-12.md`
✅ `Logs/2026-05_汇总.md`

---

## Persona 用户画像命名

格式：`persona-{role-slug}.md`

`role-slug` 用业务角色 + 关键特征命名，便于团队记住。

✅ `persona-acme-operator.md`（某客户代号 acme 的运营经理——示例用代号，真实客户名不入库）
✅ `persona-front-line-cs.md`（一线客服）
✅ `persona-brand-marketing-director.md`（品牌方市场总监）

❌ `persona-user-1.md`（记不住、缺信息）
❌ `persona-A.md`（信息密度太低）

---

## Skill 文件命名（仅 ai-saas 项目）

标准 Skill 目录结构：

```
skills/{skill-name-slug}/
├── SKILL.md                 主入口（YAML frontmatter + 引导）
├── scripts/                 可执行脚本（.sh / .py）
├── references/              知识库（多份 .md）
└── assets/                  资源（模板 / 截图 / 样例数据）
```

- `skill-name-slug`：英文小写连字符（例：`auto-tagging` `churn-analysis` `pm-project-scaffolding`）
- `SKILL.md` 必须**全大写**——Anthropic 标准约定
- `scripts/` 内脚本用 kebab-case：`init.sh` `validate-input.py`

---

## 截图与图片命名

格式：`screenshot-{topic}-{step}-{description}.png`

✅ `screenshot-onboarding-step-3-skill-config.png`
✅ `screenshot-faq-data-isolation-diagram.png`

❌ `image001.png`
❌ `截图_2026-05-12_15-30.png`

**存放位置**：`assets/{topic}/` 子目录，避免主文档同级膨胀。

---

## 视频脚本命名

格式：`video-{topic}-{duration}-script.md`

✅ `video-onboarding-3min-script.md`
✅ `video-skill-creation-5min-script.md`

**视频文件本身不进 git**（`.gitignore` 加 `*.mp4` / `*.mov`），原始视频放云盘。视频脚本进 git。

---

## 分支命名（如果用 git）

| 类型 | 格式 | 例 |
|---|---|---|
| 功能 | `feat/{slug}` | `feat/skill-versioning` |
| 修复 | `fix/{slug}` | `fix/admin-rail-render-bug` |
| 重构 | `refactor/{slug}` | `refactor/dir-pm-view` |
| 文档 | `docs/{slug}` | `docs/add-training-system` |
| 实验 | `exp/{slug}` | `exp/wasm-sandbox` |

---

## 反模式（不要这样做）

❌ **中文路径**：`docs/产品文档/` —— 跨平台问题，URL 编码混乱
（**例外**：终端面向中文用户的 .md / .html 文件名可以用中文，例 `项目目录结构说明.html`，但目录路径保持英文）

❌ **空格路径**：`my project/` —— shell 转义麻烦

❌ **大小写混用**：`README.md` 和 `readme.md` 在 macOS 默认不区分，但 Linux 区分

❌ **日期 + 版本混用**：`v1.0_2026-05-09.md` —— 二选一，按场景选

❌ **不要在文件名里放变更说明**：`README-final-v2-真的不改了.md` ——版本控制是 git 的事

---

## 当 AI 不确定怎么命名时

按这个优先级：

1. 看本项目里现有的同类文件怎么命名 → 沿用风格
2. 看本 references 文件有没有约定 → 按约定
3. 看其它已成熟项目的同类文件 → 借鉴
4. 都没有 → **问用户**，不要自己拍板
