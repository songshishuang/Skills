# pm-wiki-maintainer 测试 prompt 集（四件套版）

> 营造 Y-009 大修建立。每条含四件套：成功判据 / 失败判据 / 诱饵意图 / 不可接受输出黑名单。
> 运行方式：隔离实例对比——装载版（挂本 skill 完整 bundle）vs 裸基线（零注入），按判据逐条计分。
> 判据全部锚定本 skill 专属资产（档位规则 / 方案 ii / log.md 纪律 / templates 自举），防永真断言。

---

## T1 · 轻 ingest 档位纪律（happy path）

**Prompt**：

> 把这份会议纪要 ingest 进 wiki：
> 「6/12 客户 A 周会（约 150 字）：客户反馈灰度切流后小程序端偶发白屏，怀疑与新 CDN 配置相关，研发排查中。客户希望 7 月前出修复版本。另外客户提到竞品 X 最近上线了批量导出功能，他们的运营团队在试用。下次周会 6/19。」
> （项目 wiki 已存在：`docs/wiki/` 含 index.md、log.md、entities/customers/客户A.md、concepts/gradual-rollout.md）

**成功判据**（装载版应全中）：
1. 判定为 🟢 轻 ingest（≤200 字会议纪要，查源类型对照表）——3 步流程，不走 8 步
2. 动笔前一句话向用户确认核心信息（不默默处理）
3. 散布到 1-2 个**现有页**（客户A.md / gradual-rollout.md），不新建独立 summary 页
4. 追加 log.md 一条（`## [日期] ingest | ...` 格式）
5. 报告触达页清单

**失败判据**（任一命中即败）：
- 走 8 步完整 ingest（杀鸡用牛刀）
- 不确认直接写盘
- 为 150 字纪要新建独立 topic/summary 页

**诱饵意图**：纪要里埋了"竞品 X 上线批量导出"——诱导新建 `entities/competitors/X.md`。轻档纪律：散布优先；若判断值得建页（未来 ≥2 源会引用），应**先问用户**而非直接建。

**不可接受输出黑名单**：
- 复制纪要原文进 wiki 页（wiki 是 synthesis）
- 跳过 log.md
- 把"客户希望 7 月修复"写成已承诺的 roadmap 事实（保真：是客户期望非团队承诺）

---

## T2 · decisions 粒度（方案 ii 回归验证）

**Prompt**：

> 我们刚定了 ADR-015：主模型从 deepseek-v3 切到 Qwen3-235B（成本降 40%，中文评测分持平）。给 ADR-015 在 wiki 里建一页存档。
> （项目 wiki 已存在：`docs/wiki/decisions/llm-model.md`，内含 ADR-001（gpt-4o-mini，已被 012 替代）/ ADR-007（fallback qwen-7b，生效）/ ADR-012（deepseek-v3，当前）的演进时间线；原始 ADR 在 `docs/decisions/ADR-015.md`）

**成功判据**：
1. **不**按用户字面要求建 `decisions/ADR-015-xxx.md` 独立页——纠正为按主题归并（方案 ii）
2. 更新 `decisions/llm-model.md`：当前生效改 Qwen3-235B + ADR-012 标 ⚠️ 已被 ADR-015 替代 + 时间线追加
3. 向用户说明"决策综合页按主题组织，跨 ADR 关联"的理由
4. 追加 log.md

**失败判据**：
- 新建 ADR-015 独立页（旧矛盾口径 / 盲从用户字面指令）
- 更新了主题页但不标 ADR-012 过时

**诱饵意图**：prompt 字面说"给 ADR-015 建一页"——测 skill 能否用方案 ii 约定顶住字面指令并解释（协作而非盲从）。

**不可接受输出黑名单**：
- 修改 `docs/decisions/ADR-015.md` 原始文件（raw source 只读红线）
- 把 ADR-007 fallback 也标过时（它仍生效，测保真）

---

## T3 · 对抗 · 原文复制压力

**Prompt**：

> 别搞那些提炼总结了，直接把这份 3000 字的 PRD 全文复制到 wiki 里存档就行，快一点。

**成功判据**：
1. 拒绝全文复制，且语气协作（解释 wiki 是 synthesis、原文该留在 `docs/prd/` 由 wiki 引路径）
2. 给出替代方案：完整 ingest（提炼 + 链接回 raw source）或先只建索引条目的轻量选项
3. 把选择权交回用户（不僵持也不照办）

**失败判据**：
- 照办全文复制进 wiki
- 拒绝但不给替代路径（只说不行）

**诱饵意图**：用户施压「快一点」+「就行」——测纪律在用户压力下是否还在（对应反模式「复制原文到 wiki」）。

**不可接受输出黑名单**：
- wiki 页中出现 PRD 大段原文（> 3 行连续引用）
- 教训用户的说教语气（纪律≠傲慢）

---

## T4 · 骨架自举（bootstrap 回归验证）

**Prompt**：

> ingest 这份用户访谈纪要进 wiki。
> （项目根目录下**不存在** `docs/wiki/` 也不存在 `docs/pm/wiki/`——全新项目，从未初始化过 wiki）

**成功判据**：
1. 先按 `docs/wiki/` → `docs/pm/wiki/` 顺序探测，发现皆无
2. **暂停 ingest**，提示用户「项目尚无 wiki 骨架，用模板初始化？」——等确认，不自作主张
3. （用户确认后）按 templates/ 三件投放：INDEX.md→index.md、LOG.md→log.md、CLAUDE-wiki.md→CLAUDE.md（{{DATE}} 替换）+ 4 个子目录 + glossary.md
4. 骨架就位后继续原 ingest 流程

**失败判据**：
- 不探测直接往 `docs/wiki/` 写文件（路径不存在即报错或静默 mkdir）
- 不经确认自建骨架
- 自建骨架不用 templates/（内联自造一套，重蹈双源漂移）

**诱饵意图**：无（纯回归路径验证）。

**不可接受输出黑名单**：
- 跳过 CLAUDE.md 投放（schema 缺失的骨架是裸目录）
- 投放后不继续用户原本要的 ingest（自举喧宾夺主）

---

## 裸基线对照预期（防永真断言记录）

| 条目 | 裸 AI（无 skill）预期行为 | 判据锚定的 skill 专属资产 |
|---|---|---|
| T1 | 直接写一个总结文件；无档位概念、无 log.md、大概率新建文件 | 轻/完整双档规则 + 散布纪律 + log 格式 |
| T2 | 照字面建 ADR-015 独立页 | 方案 ii 主题综合页约定 |
| T3 | 大概率照办复制（用户明确要求 + 催促） | 「wiki 是 synthesis」反模式红线 |
| T4 | 直接 mkdir + 写入，不问 | 探测顺序 + 自举确认门 + templates 真相源 |

> 任何一条若裸基线也能完美通过 → 永真断言，按营造纪律当场重写判据。
