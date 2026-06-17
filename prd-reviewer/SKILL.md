---
name: prd-reviewer
description: Use when PM 需要评审/审核需求产出物的 AI 可执行性 —— 包括 story MD 卡片(stories/ 目录)、全本 PRD,或判断"这个 story 能不能给研发了"。触发词:「评审 story」「审 story」「story review」「跑三关」「spec 自测」「干跑验证」「检查 stories 目录」「审核 PRD」「PRD 评审」「需求评审」「AI 评审需求文档」「这份需求研发能直接用吗」「standby 评审」。也适用于研发反馈"需求有歧义/AI 编码跑偏"后回查 spec 质量。不要用于：评业务方向对错（只评 AI 可执行性）、评代码实现、评原型视觉风格（用 saas-prototype-design）。
---

# PRD Reviewer · 三关评审

## Overview

让 AI 当评审员,系统性审核 PM 产出的需求文档(story MD / 全本 PRD)的 **AI 可执行性**。

**核心原则:歧义不是靠"读起来通顺"发现的,是靠"被迫执行"暴露的。**

不能"把 MD 丢给 AI 说帮我看看"——那样每次评审标准漂移、意见不可执行。本 skill 固化**三道递进关卡**,每关固定 prompt、固定输出格式、明确通过标准:

```
第一关 规则审查 lint      ~2 分钟/story   审「格式与可测性」(standard 7 项 / lite 5 项)
第二关 对抗评审 猜测点     ~5 分钟/story   审「歧义与自包含」 ← 精髓
第三关 干跑验证 spec test  ~15 分钟/story  审「端到端可执行」(lite 免)
blocker 清零才进下一关;分级关卡全过 → spec_test: passed,spec 状态 ai-passed
(转 ready 还需研发 48h 走查;两套门禁不混用;正面样例必须能过自己的门禁,负样例以 bad- 前缀标识)
```

行业依据:Anthropic 内部对 spec 的质量标准——"写完 spec 送给 Claude Code,看它能不能建出来"。第二关与第三关就是这条标准的低成本版与全真版。

**本 skill 是三关评审 prompt 的唯一真相源**;方案背景见 MaaS 仓 `docs/pm/specs/2026-06-11-story-spec-workflow.md`。

## 何时使用

- stories/ 目录派生完成后、交研发前(`prd-writer` Stage 4 之后的标准下一步)
- 单个 story 改完重审
- 全本 PRD 写完后按 DoD 体检(模式 B)
- 研发反馈"AI 编码跑偏 / 需求有歧义",回查 spec 质量定位歧义点

## 何时不用

- ❌ 业务方向评审(做不做、优先级)→ 那是业务评审会的事,评审对象是全本 HTML,人评不是 AI 评
- ❌ 评审研发写的代码 → 用 code-review
- ❌ 原型视觉走查 → 人看原型,不是本 skill 范围

## 评审对象与分级

| 对象 | 跑哪几关 | 说明 |
|---|---|---|
| 标准 story(`ST-XXXX-*.md`) | 三关全跑 | P0 story 第三关必跑 |
| lite story(`type: lite`) | 只跑一、二关 | 小改动干跑性价比低 |
| 变更重派生的 story | 重跑一、二关 | 第三关视改动幅度 |
| 全本 PRD(模式 B) | 按 prd-writer DoD 做 lint | 检查全部 🔴 核心必填项 + **🔴 决策闭环自检门**(目标↔设计↔验收可追溯 / 内部无矛盾 / 展示指标口径完整) + 永远不写项,输出同格式报告 |

`spec_test: passed` 的语义 = **该 story 类型分级要求的全部关卡通过**(标准 = 三关,lite = 两关)——不存在"lite 永远 pending"的死锁。

## 工作流

### 第一关:规则审查(lint)

机械检查,把 ready 门禁翻译为逐项可判定规则。**对每个 story 用以下 prompt**(可派 subagent 并行跑多个 story):

```text
你是 story spec 的 lint 评审员。先读 frontmatter type 选择门禁(standard / lite
两套不混用),逐项检查,只依据检查项判定,不发表检查项之外的意见。

【standard lint · 7 项】(无 type 或 type ≠ lite)
1. frontmatter 完整:story_id / title / priority / status / source / prototype /
   spec_test 齐全
2. 每条 AC 符合 Given-When-Then 结构,且可客观判定——出现「友好/合理/较快/
   优化/良好/尽量」等不可测词 = blocker
3. 「范围-不做」一节存在且有实质内容(只写"其他暂不支持" = warning)
4. 无技术实现细节:出现 API path / 表结构 / PK·FK / 具体组件库代码 = blocker
   (字段的业务级约束不算)
5. 正文 ≤100 行;与 00-overview.md 公共约定重复的内容 = warning
6. depends_on 引用的 story 在索引中存在,且无循环依赖
7. source / prototype 为相对路径且**在 PM 仓内可解析(目标文件真实存在)**;
   未内嵌 HTML/截图大段内容

【lite lint · 5 项】(type: lite)
L1. frontmatter:story_id / type / title / status / source / spec_test 齐全
    (无需 priority / prototype / depends_on)
L2. 每条 AC 是可客观判定的单断言(允许省略 Given/When,结果必须可观察;
    不可测词 = blocker);AC ≤3 条
L3. 「改什么」≤3 句且指明位置
L4. 正文 ≤30 行
L5. source 相对路径在 PM 仓内可解析

输出格式(严格遵守):
| # | 检查项 | 结论 pass/warning/blocker | 位置(行号或节名) | 问题 | 修改建议 |
末行输出总结论:READY 或 NOT-READY(存在 blocker 即 NOT-READY)
```

### 第二关:对抗评审(猜测点挖掘)⭐

让 AI 扮演**只能看文档、不许提问的研发**,逼它列出所有"必须靠猜"的决策点——每个猜测点就是 spec 的一个缺陷:

```text
你是即将按这份 story 实现功能的研发 agent。规则:
- 你只能阅读 00-overview.md 和本 story 文件,不允许向任何人提问
- 不要写代码

任务:列出实现过程中你必须自行猜测/假设的全部决策点。逐个排查这些维度:
字段默认值与必填性 / 列表排序与分页规则 / 权限与角色差异 / 空态与首次进入 /
并发与重复提交 / 数据量边界 / 操作失败后的状态回退 / 与依赖 story 的数据衔接 /
原型中出现但 story 未提的元素。

每个猜测点输出:
| 决策点 | story 缺失的信息 | 我会怎么猜 | 猜错的后果(高/中/低) |

最后判定:高风险猜测 ≥1 个,或猜测点总数 >5 → 输出 SPEC-AMBIGUOUS;
否则输出 SPEC-CLEAR,并附剩余低风险猜测清单(交 PM 确认是否留白授权)。
```

**PM 对猜测清单只做两件事**:该写进 story 的补进去;确实不重要的,在 story 里显式写"由实现自行决定"——**把隐性留白变成显性授权**,堵死 AI 越界发挥的源头。

### 第三关:干跑验证(spec test)

**隔离硬规则(必须,防污染真实仓)**:
- 必须在**一次性 worktree + throwaway 分支**执行,绝不在开发工作区跑;路径与分支名带 story + 时间戳,防多 story / 多轮评审冲突:
  `git worktree add -b dryrun/{story_id}-{YYYYMMDD-HHMM} /tmp/prd-review-dryrun-{story_id}-{YYYYMMDD-HHMM} && cd /tmp/prd-review-dryrun-{story_id}-{YYYYMMDD-HHMM}`
- 产出**只保留评审报告与截图**(归档 `stories/_review/`),代码默认销毁:
  `git worktree remove --force /tmp/prd-review-dryrun-{story_id}-{YYYYMMDD-HHMM} && git branch -D dryrun/{story_id}-{YYYYMMDD-HHMM}`
- 干跑代码**禁止**进入任何交付分支、禁止被后续实现"参考复用"——它是评审手段,不是首版实现

用研发侧标准 prompt 真实现一遍:

```text
请实现 stories/ST-XXXX-{标题}.md,公共约定见 00-overview.md。
完成后逐条对照 AC 自验,按下方格式输出验收对照表,并截图关键页面。
```

**第三关输出格式**(照此填,末行必出总判定):

| AC# | 验收标准 | 实现位置 | 自验结果 (pass/fail) | 偏差说明 |
|---|---|---|---|---|
| AC1 | {复制 story AC} | {文件:行/页面} | pass / fail | {fail 时写实现与 spec 哪里对不上} |

末行总判定:**干跑结论:PASS**(全 AC pass) / **SPEC-DRIFT**(列出跑偏的 AC → 这些是 spec 歧义点,改 spec 重跑,不修代码)

**判定纪律**:
- PM **看验收对照表和页面效果,不看代码**——评审对象是 spec,不是这次生成的代码
- 实现明显跑偏处 = spec 歧义点 → **改 spec 重跑**;不修 AI 代码、不口头纠正
- 干跑产物用完即弃(worktree 丢弃),不进研发交付

### 评审完成后

1. 分级关卡全过 → story frontmatter 回写 `spec_test: passed`,overview 索引改 `ai-passed`
2. 输出**版本级评审汇总报告**(见下),落盘 `stories/_review/YYYY-MM-DD-review.md`(干跑截图同目录),作为研发 48h 异步走查的附件——研发从"从零找茬"变为"确认 AI 结论"
3. 研发走查 5 问全过 → PM 把索引改 `ready`(`ai-passed → ready` 的唯一通道);交付状态(in-dev/done)在研发仓 `delivery-status.md`,本 skill 不管辖

**研发走查 5 问**(建议版——`ready` 门的判据必须在体系内可见;团队可按实际流程替换,但替换后要回写本节保持可见):
1. AC 在当前技术栈下**可实现且可验证**?(无隐藏的技术不可行点)
2. 依赖与数据衔接路径清楚?(上游 story / 接口 / 数据就绪方式无悬空)
3. 「范围-不做」与研发理解一致?(无"我以为要做/以为不做"的错位)
4. 拆分粒度可独立交付?(无隐藏巨石,工作量与 story 体量匹配)
5. AI 评审报告中的留白授权点研发可接受?(「由实现自行决定」的点真的能自行决定)

## 处置规则

| 规则 | 内容 |
|---|---|
| 通过线 | blocker 清零进下一关;分级关卡全过 → `ai-passed`;研发走查过 → `ready` |
| 误报处理 | AI 评审意见 PM 有否决权;误报标注后**沉淀回本 skill 检查项**(评审标准版本化防漂移) |
| 收敛上限 | 单 story 评审-修改 >3 轮仍 NOT-READY → 问题在需求没想清,回业务层,不要继续改措辞 |
| 并行加速 | 多 story 的一、二关可派 subagent 并行;第三关串行(看产物要专注) |

## 评审汇总报告格式

```markdown
# V{X.Y} stories 评审报告 · {YYYY-MM-DD}

| story | 第一关 | 第二关 | 第三关 | 结论 | 遗留 |
|---|---|---|---|---|---|
| ST-0401 | READY | SPEC-CLEAR(2 低风险留白已授权) | AC 4/4 | ✅ ai-passed | 待研发走查转 ready |
| ST-0402 | NOT-READY(AC3 不可测) | - | - | ⛔ draft | 修 AC3 后重跑 |
| ST-0405(lite) | READY(lite 5 项) | SPEC-CLEAR | 免 | ✅ ai-passed | 待研发走查转 ready |

## 留白授权清单(第二关低风险猜测 · PM 已确认"由实现自行决定")
| story | 决策点 | PM 授权措辞 |
|---|---|---|
| ST-0401 | 列表默认排序字段 | 由实现自行决定(创建时间倒序即可) |

## 误报记录(本轮 AI 评审误报 · 已沉淀回 skill)
| 关 | 误报内容 | PM 判定 | 沉淀去向 |
|---|---|---|---|
| 第一关 | {AI 报的 blocker} | 误报(理由) | 已加进 lint 检查项例外 / 无需沉淀 |
```

## 反模式

| 反模式 | 为什么不行 | 怎么做 |
|---|---|---|
| 把 MD 丢给 AI"帮我看看" | 标准漂移 · 意见不可执行 | 用三关固定 prompt |
| 跳过第二关直接干跑 | 干跑贵;明显歧义应在第二关便宜地暴露 | 按顺序过关 |
| 第三关去修 AI 生成的代码 | 评审对象是 spec 不是代码;修代码掩盖歧义 | 改 spec 重跑 |
| 评审意见口头传达研发 | 口头补充不算数,story 文件是唯一执行依据 | 改进 story 文件再重派生 |
| 拿干跑产物当交付物 | 干跑是评审手段,代码未经研发工程化 | worktree 用完即弃 |
| 对 lite story 跑三关 | 文案修正干跑是浪费 | lite 只跑一、二关 |
| 评审-修改循环 4+ 轮还在改措辞 | 问题在需求本身 | 回业务层重新想清楚 |
| 评审者的**正面**样例/模板过不了自己的门禁 | self-consistency 崩塌,门禁失去公信力 | 模板/正样例改动后先拿它跑对应 lint;负样例必须 `bad-` 前缀 + 配 expected 文件 |
| 干跑在开发工作区直接跑 | 污染真实仓,dry-run 代码混入后续实现 | 一次性 worktree + throwaway 分支,用完销毁 |

## Red Flags — STOP and 检查

- story 标了 `ai-passed`/`ready` 但 `spec_test` 还是 `pending` → 没跑关就放行
- 对 lite story 用了 standard 7 项门禁(或反之)→ 门禁错配,重跑
- 第二关输出 0 个猜测点 → prompt 没被认真执行,重跑(任何 story 都有留白)
- 第三关 AI 实现和原型差异巨大但 AC 全过 → AC 覆盖不足,补 AC
- 同一检查项连续 3 个 story 误报 → 检查项本身有问题,修订本 skill

## 常见 rationalization(agent 自查)

| 借口 | 反驳 |
|---|---|
| "story 很简单,直接给研发吧" | 简单 story 三关 ~20 分钟;研发拿歧义 spec 跑偏一轮按天算 |
| "第二关猜测点太多,先放行回头补" | 猜测点 = AI 编码时的自由发挥点,放行 = 放飞 |
| "干跑代码看着能用,顺手交付" | 干跑是评审产物;未经研发工程化的代码进主干是债 |
| "评审标准我记得,不用按 prompt" | 凭记忆评 = 标准漂移;prompt 固定才能误报沉淀、持续改进 |

## 与 prd-writer 协作

```
prd-writer Stage 4 派生 stories/(status: draft, spec_test: pending)
        ↓
prd-reviewer 分级关卡评审(本 skill,标准=三关 / lite=两关)
        ↓ 全过
回写 spec_test: passed + 索引 ai-passed
        ↓ 研发 48h 走查(附评审报告)全过
PM 标 ready → kickoff 签收(研发仓 delivery-status.md 登记 in-dev)
```

全本 PRD 模式(模式 B):按 `prd-writer` SKILL.md 的「完成标准(DoD)」逐项 lint——全部 🔴 核心必填项 + **🔴 决策闭环自检门**(目标↔设计↔验收可追溯 / 内部无矛盾[非目标 vs 设计] / 展示指标口径完整[分子·分母·状态枚举]) 缺任一 = blocker,出现「永远不写」内容 = blocker,输出同格式报告。决策闭环门是模式 B 的核心增量——防"7 节齐全却不驱动决策"的 PRD 蒙混过关。

## 回归测试 fixtures

`tests/fixtures/` 含 standard 正负对 + lite 正负对 + overview,用于 skill 修改后的回归验证:

- `bad-ST-0401-告警规则管理.md`:**standard 负样例**(`bad-` 前缀标识),预埋 6 类缺陷(含 source 结构基准违例);预期输出 `expected-bad-ST-0401.md`(NOT-READY + SPEC-AMBIGUOUS)
- `golden-ST-0402-告警历史.md`:**standard 正样例**,应过 standard lint;预期输出 `expected-golden-ST-0402.md`(READY + SPEC-CLEAR)——防门禁过严误杀;含 1 个保留的中风险猜测探针(测第二关灵敏度)
- `lite-ST-0403-告警时间显示修正.md` / `bad-lite-ST-0404-导出体验.md`:**lite 正负对**,覆盖 lite lint 5 项;预期输出 `expected-lite-pair.md`(READY / NOT-READY 三类雷)
- lint 第 7 项豁免口径:fixture 环境**仅豁免文件存在性**(标 N/A);source/prototype 的**路径层级结构必须与 00-overview 基准一致,结构不符不在豁免范围,应报 blocker**
- 回归方法:派 subagent 只读 SKILL.md + fixture 文件跑一、二关,比对 expected 的「回归通过标准」;skill 检查项每次修改后必跑;盲测实绩记入各 expected 文件(隔离实例、未见预期)

## Changelog

- **2026-06-18 · v1.3** — 模式 B 强化（随 prd-writer v2.4.6 · MaaS V0.3.2 全本 PRD 评审回流）：模式 B 由"按 DoD 核心必填 + 永远不写"扩为**额外强制 prd-writer 新增的「🔴 决策闭环自检门」**（目标↔设计↔验收可追溯 / 内部无矛盾 / 展示指标口径完整[分子·分母·状态枚举]）——专治"7 节齐全却不驱动决策"的结构完整型 PRD；同步去掉硬编码"核心必填 9 项"（与 prd-writer DoD 的 10 项漂移）改为"全部 🔴 核心必填项"。两处（评审对象表 + 模式 B 说明）同步。
- **2026-06-12 · v1.2** — 营造(yingzao)大修,五轮细作(双盲评 74→84):① **golden 路径修复**(source/prototype 各多一层 `../` 对齐 overview 基准——此前被第 7 项全量豁免掩盖);② **golden 正样例首次盲测实绩入档**(隔离实例:一关 READY 7/7、二关 SPEC-CLEAR,挖出 1 中风险探针保留为灵敏度活证据);③ **「研发走查 5 问」内联建议版**(ready 门判据体系内可见);④ **lite 门禁正负 fixture 对从零建**(ST-0403/ST-0404+expected,盲测实绩三类雷全命中);⑤ 一致性闭环:第 7 项豁免口径统一为「仅豁免文件存在性,结构基准违例仍 blocker」(三处同步),bad-ST-0401 的 source 缺 `../` 登记为预埋缺陷 #6,回归节登记 lite 三件套
- **2026-06-12 · v1.1.1** — 第二轮评审修复:① dry-run 路径与分支名加 `{story_id}-{时间戳}` 后缀,防多 story / 多轮评审冲突;② fixtures 改造为一负一正(负样例 `bad-` 前缀 + expected 预期文件,新增 golden 正样例防门禁过严误杀),新增「回归测试 fixtures」节;③ self-consistency 条款精确化:正面样例必须过门禁,负样例显式标识
- **2026-06-12 · v1.1** — 落地契约修订(研发侧 NOT-READY 评审 7 条驱动):① lint 拆 standard(7 项)/ lite(5 项)双门禁,样例必须过自己的门禁(self-consistency);② lint 第 7 项升级为路径**可解析**强校验(目标文件真实存在);③ `spec_test: passed` 语义 = 分级关卡全过(标准=三关,lite=两关);④ 关卡全过 → `ai-passed`(非 ready),研发 48h 走查过才 `ready`;⑤ 干跑隔离硬规则(一次性 worktree + throwaway 分支,代码默认销毁,只留报告/截图归档 `stories/_review/`);⑥ 交付状态(in-dev/done)归研发仓 delivery-status.md,本 skill 不管辖;反模式 +2、Red Flags +1
- **2026-06-11 · v1.0** — 初始版本。源自 MaaS 项目研发分工讨论(2026-06-10)+ 行业调研:三关递进(lint / 对抗猜测点 / 干跑)· 处置规则(blocker 清零 / 误报沉淀 / 3 轮收敛上限)· 评审汇总报告格式 · 与 prd-writer v2.4 stories/ 机制衔接。方案全文:MaaS 仓 `docs/pm/specs/2026-06-11-story-spec-workflow.md`
