# Skills

作者自创的 Claude Skills 仓库。**面向 AI 产品经理的工作流加速器**，蒸馏自某 AI 运营平台、某 SaaS 平台、SCRM 等实战项目。

## 📦 Skills 清单

| Skill | 用途 | 蒸馏自 |
|---|---|---|
| **`prd-writer`** | 基于 V0.5 PRD 简洁结构生成 AI 产品需求文档；含业务目标 / 用户故事 / 数据埋点 / 评测指标 / 灰度策略 / 验收清单 / 风险依赖；配套派生 stories/ 目录（AI 编码用 story 卡片）+ 3 个角色切片 | SCRM / 某 AI 运营平台 PRD 实战 |
| **`prd-reviewer`** | 评审 story 卡片 / 全本 PRD 的 AI 可执行性——三关检查（spec 自测 / 干跑验证 / 歧义扫描），判断"这个 story 能不能直接交研发"；与 prd-writer stories/ 产出衔接（draft → ai-passed → ready） | 某 SaaS 平台 story 评审实战 |
| **`release-note-builder`** | 把一次产品上线整理成「发版说明 / 上线公告」HTML（四段式：标题 · 上线时间 · 版本内容扫读清单 · 逐功能介绍 + 真实页面截图）；固化「真实环境截图 → 默认脱敏 → 套模板 → 本地预览 → 一键发布在线文档」流水线 | 某 SaaS 平台发版实践 |
| **`pm-project-scaffolding`** | 初始化标准 PM 项目目录脚手架；覆盖 PM 完整生命周期 8 阶段（研究 / 规划 / 设计 / 开发 / 发布 / 培训 / 运营 / 归档）；支持 ai-saas / generic-saas / mobile-app / internal-tool 四种产品类型 | 某 AI 运营平台 项目实战目录治理 |
| **`saas-arch-diagrams`** | 设计企业 SaaS 类产品的两类核心架构图：「产品架构图」（产品在生态中的定位 · 4 层视图）+「功能架构图」（4 层纵向 × 能力域横向 chip · 3 级嵌套） | 某 SaaS 平台（某 MaaS 模型供应链管理平台）迭代实战 |
| **`saas-prototype-design`** | 企业 SaaS 高保真原型完整方法论：v1 设计语言（品牌红 + tokens.css + chrome 框架）+ 组件模式 + 3 级嵌套结构 + 状态机徽章 + 历史版本保护机制 | 某 SaaS 平台 项目 30+ 轮迭代 + 33+ 页原型实战 |
| **`conversation-logging-and-insight-extraction`** | 捕获用户对话过程，强制业务价值总结与提炼，以高规范 Markdown 格式沉淀到日志库 | Claude Desktop / Claude Code 长会话归档实践 |
| **`pm-wiki-maintainer`** ⭐ | 维护 PM 项目的 LLM Wiki（基于 Karpathy LLM Wiki 模式）—— 增量构建持久化知识库（不是临时 RAG），三类操作 ingest / query / lint，方案 ii decisions 独立综合视图 | [Karpathy LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) + 真实项目 ingest 实战 |

## 🌐 跨平台支持

本仓库的 skill 设计**与模型无关**，可在 8+ 个 AI 代码助手平台使用：

| 平台 | 自动化级别 | 触发方式 |
|---|---|---|
| **Claude Code / Desktop**（推荐） | 🟢 全自动 | 原生 |
| **Cursor** | 🟡 半自动 | marketplace 或本地 plugin |
| **Codex CLI / App** | 🟡 半自动 | OpenAI plugin marketplace |
| **Gemini CLI / Antigravity** | 🟡 半自动 | `gemini extensions install` |
| **GitHub Copilot CLI** | 🟡 半自动 | `gh copilot marketplace` |
| **OpenCode** | 🟡 半自动 | `.opencode/plugins/` |
| **ChatGPT / 本地模型** | 🔴 仅建议 | 复制 SKILL.md 到 instructions |

详细安装指南：[**INSTALL-MULTI-PLATFORM.md**](./INSTALL-MULTI-PLATFORM.md)

一键安装脚本（需先克隆本仓库）：

```bash
git clone https://github.com/songshishuang/Skills.git
cd Skills

./scripts/install-platform.sh                 # 交互式选平台
./scripts/install-platform.sh claude-code     # 装到 Claude Code
./scripts/install-platform.sh cursor --project /path/to/your/project
./scripts/install-platform.sh codex
./scripts/install-platform.sh gemini          # 含 Antigravity
```

> 仓库当前为 **private**——若未来转 public，可补 `curl | bash` 形式的零克隆一键安装。

---

## 🛠️ 安装方式（Claude Code / Desktop）

### 方式 A：克隆全部 skill 到全局
```bash
cd ~/.claude/skills
git clone https://github.com/songshishuang/Skills.git temp-skills
mv temp-skills/{prd-writer,pm-project-scaffolding,saas-arch-diagrams,saas-prototype-design,conversation-logging-and-insight-extraction,pm-wiki-maintainer} .
rm -rf temp-skills
```

### 方式 B：单独使用某个 skill
```bash
cd ~/.claude/skills
git clone --depth=1 --filter=blob:none --sparse https://github.com/songshishuang/Skills.git tmp
cd tmp && git sparse-checkout set prd-writer && mv prd-writer ../ && cd .. && rm -rf tmp
```

### 方式 C：在项目内引用（保持项目自包含）
```bash
cd <你的项目>/skills/
git clone --depth=1 https://github.com/songshishuang/Skills.git -b main temp
cp -r temp/saas-arch-diagrams ./
rm -rf temp
```

## 📐 Skill 标准目录结构

每个 skill 遵循 [Anthropic Skill 规范](https://docs.claude.com)：

```
skill-name/
├── SKILL.md          (必需) — YAML frontmatter + Markdown 正文
├── scripts/          (可选) — 可执行脚本，处理确定性 / 重复性任务
├── references/       (可选) — 按需加载的参考文档
├── templates/        (可选) — 输出模板（HTML / Markdown / 表格等）
└── assets/           (可选) — 资源文件（图标、字体、示例图等）
```

## 🔄 同步策略

本仓库是 `~/.claude/skills/` 下对应 skill 目录的**镜像**：
- 主开发位置：`~/.claude/skills/<skill-name>/`
- 此仓库：可对外分发的纯净版

更新流程（开发者本机）：
```bash
cd ~/Documents/claude/Skills
rsync -a --delete --exclude='.DS_Store' --exclude='__pycache__' \
  ~/.claude/skills/<skill-name>/ ./<skill-name>/
git add . && git commit -m "sync: update <skill-name>" && git push
```

## 📅 维护

- **作者**：作者 ([@songshishuang](https://github.com/songshishuang))
- **首次发布**：2026-05-15
- **更新频率**：随各实战项目迭代不定期更新

## 📄 许可

MIT（除非各 skill 目录内单独标注其他许可）
