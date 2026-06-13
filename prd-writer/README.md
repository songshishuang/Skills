# prd-writer

> **别的工具帮你"写文档"，这个 skill 让 PRD 能直接喂给 AI 编码 agent。**

PM 写完 PRD，研发的 AI 编码 agent 却频频跑偏——一份 PRD 要同时喂研发、QA、BI、运营 6 个消费者，上下文互相污染；AI 产品特有的埋点 / 评测 / 灰度又总被漏掉。prd-writer 把作者 V0.5 实战 PRD 结构（蒸馏自 SCRM / 某 AI 运营平台）固化为 **7 节标准 + 自动派生的 story 卡片**，让 AI 编码 agent 每次只读一张卡、上下文最小化。

## 为什么装它

| 能力 | 说明 |
|---|---|
| **7 节标准结构** | Summary / Problem & Goals / Scope / Design / Rollout & Risks / Quality / Appendix——借鉴 Amazon Working Backwards、Shape Up、Linear spec，业务核心 Design 章权重提至 1/7 |
| **AI 产品 6 大缺口全覆盖** | 业务目标 / 用户故事 / 数据埋点 / 评测指标 / 灰度上线 / 验收清单——LLM·RAG·Agent 模块单列特化 |
| **自动派生 stories/** | 全本 PRD → `00-overview.md` + 按 story 拆的 `ST-XXXX` 卡片，AI 编码 agent 每次只读单卡 |
| **3 个角色切片** | `for-qa` / `for-bi` / `for-ops` 只读派生——解决"一份 PRD 撑 6 个消费者互相污染" |
| **原型反推** ⭐ | 从 HTML 原型 / Figma / 截图反推 PRD（与 saas-prototype-design 协作闭环） |

**独有生态位**（经 32 个同类对标核查）：全生态**唯一**同时做了「AI 产品特化 PRD」与「编码切片（stories 卡片）」两件事的 skill。

## 30 秒上手

```bash
git clone https://github.com/songshishuang/Skills /tmp/Skills && \
  cp -R /tmp/Skills/prd-writer ~/.claude/skills/
```

对 Claude 说（更多触发词见 SKILL.md frontmatter）：

> 写一份 V0.9 的 PRD：[贴需求 / 会议纪要 / Figma 链接]

或从已有原型反推：

> 用 prd-writer 从这套 HTML 原型反推一份 PRD

其他平台（Codex / Cursor / Gemini / Copilot）安装见仓库根 [INSTALL-MULTI-PLATFORM.md](../INSTALL-MULTI-PLATFORM.md)。

## 工作流（Stage 0 → 4，6 阶段）

| 阶段 | 干什么 | 给你什么 |
|---|---|---|
| **Stage 0** | 读项目 wiki（pm-wiki-maintainer 维护，如有） | 历史决策作先验，不重新发明轮子 |
| **Stage 0.5** ⭐ | 从高保真原型反推（元素 → 章节映射表） | 原型里的字段 / 状态 / 角色自动落进 PRD |
| **Stage 1** | 6 个核心问题问全才动笔 | 不在信息不全时瞎写 |
| **Stage 2** | 按 7 节结构生成全本 PRD | 唯一真相源 |
| **Stage 3** | 派生 stories/ + 3 角色切片 | 研发 / QA / BI / 运营 各取所需、互不污染 |
| **Stage 4** | 自检与交付 | 可直接进研发的成品 |

## 产出物

- **全本 PRD**（7 节，唯一真相源）
- **stories/ 目录**：`00-overview.md` + `ST-XXXX` story 卡片（AI 编码 agent 直接消费）
- **3 个角色切片**：`for-qa` / `for-bi` / `for-ops`（只读派生）

## 文件地图

```
SKILL.md                 # 入口：7 节结构 + 6 阶段工作流 + 核心原则
templates/               # prd-template（7 节骨架）/ story 卡 / 3 角色切片 / 埋点表 / 填充范例
references/              # ai-product-checklist / slice-generation / tracking-events-spec
tests/                   # test-prompts + baseline-record（可复跑测试资产）
```

## 不适用

- 一次性技术调研 / 内部 RFC → `doc-coauthoring`
- 单个功能 spec（< 1 屏）→ 直接写 markdown，不必 7 节
- 工程文档 / API 文档 → 对应技术模板
- 从 PRD 反推原型 → `saas-prototype-design`
