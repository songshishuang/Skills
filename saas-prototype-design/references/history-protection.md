# 历史版本保护机制

## 问题背景

实战项目中已发生 3 次「Agent 大改时覆盖丢失之前迭代功能」：

1. **Agent C 复制 v1 → v0.1** 时直接覆盖 `eval-sets.html`，丢失了之前 3 轮迭代的启用 toggle / 描述字段 / 版本历史 / 模型基线 3 sub-tab
2. **Agent 简化菜单**时把 v0.1/admission.html 的高级筛选区删了
3. **Agent 改 wizard 4→2 步**时把 Step 1 的元信息表单（标签 / 类别 / 描述）也删了

每次都靠手动重写恢复，浪费 1-2 小时。

## 解决方案（3 道防线）

### 防线 1 · 大改前自动备份（snapshot）

每次大改原型文件前，执行：

```bash
# 单文件备份
cp prototypes/v0.1/eval-sets.html prototypes/v0.1/.history/eval-sets.$(date +%Y%m%d-%H%M).html

# 或用 helper 脚本（推荐）
bash skills/saas-prototype-design/scripts/snapshot.sh prototypes/v0.1/eval-sets.html
```

备份目录：`prototypes/.history/`（与原型同层，方便 grep 历史内容）

**注意**：
- `.history/` **要纳入 git track**（不要 .gitignore），否则 git 中也丢
- 备份用日期 + 时分作为后缀，避免覆盖
- 大改前 + 每次重要里程碑后 都备份

### 防线 2 · HTML 头部 prototype-meta 注释

在每个原型文件 `<head>` 内加：

```html
<head>
  <meta charset="UTF-8">
  <title>...</title>
  <!-- prototype-meta
    version: 1.4.2
    last-modified: 2026-05-14 09:30
    last-modified-by: claude-agent-c
    key-features:
      - 启用/停用 toggle
      - 详情面板 3 sub-tab（基本信息 / 版本历史 / 模型基线）
      - 模型基线 4 档 reasoning_mode（no-think / min / high / max）
      - L2 卡片 col-span 均宽
      - 上传自定义评测集入口

    # ⭐ prd-mapping · 给 prd-writer Stage 0.5 反推 PRD 用的强契约（v2.x 新增）
    # 写完原型后填这一段，prd-writer 反推时直接读 → 不用 LLM 猜
    prd-mapping:
      page-role: "评测集管理 · 4 类模板列表"  # → PRD §三 需求范围 · 功能模块名
      user-roles: ["运营", "评测工程师"]       # → PRD §二.2 用户角色
      state-machine: []                       # → PRD §四.1.3 状态机（如有）
      key-flows:                              # → PRD §二.5 端到端流程图
        - "选模板 → 配置上下文 → 设置评分维度 → 试评测"
      business-entities: ["评测集", "模板", "基线"]  # → PRD §四.1 业务对象
      api-touch-points: []                    # → PRD §五.3 上下游依赖（如对接外部）

    changelog:
      - 2026-05-14 v1.4.2: 单 L2 示例 · 去性能集 / 去 L3-L5
      - 2026-05-13 v1.3.0: 基线 3 档 → 4 档
      - 2026-05-12 v1.2.0: 加 toggle + 版本历史 sub-tab
      - 2026-05-10 v1.0.0: 初版（v1 风格迁移）
  -->
```

**作用**：
- Agent 大改前必须读此注释，确认要保留的关键功能
- 改完后必须更新 `version` + `last-modified` + 加 `changelog` 条目
- 跨 Agent / 跨人协作时不丢迭代上下文
- **⭐ `prd-mapping` 段是 prd-writer Stage 0.5 反推 PRD 的强契约**：prd-writer 启动反推时直接读此段，无需让 LLM 二次推断 page-role / user-roles / state-machine / key-flows / business-entities —— 这些字段直接映射到 PRD 7 节结构对应位置。**未填写 prd-mapping 时 prd-writer 仍可工作但需 LLM 多轮猜测，浪费 token**。

### prd-mapping 字段语义（与 prd-writer v2.3 7 节结构对齐）

| prd-mapping 字段 | 对应 PRD 章节 | 含义 |
|---|---|---|
| `page-role` | §三 需求范围 · 功能模块名 | 这页在产品里扮演什么角色（如"评测任务列表" / "新建评测向导"） |
| `user-roles` | §二.2 用户角色 | 哪些角色用这页（列出 user_id 名称） |
| `state-machine` | §四.1.3 业务对象生命周期 | 涉及状态机的对象 + 状态名清单（如 `[pending, evaluating, online]`） |
| `key-flows` | §二.5 端到端流程图 | 用户完成核心任务的 3-5 步骤描述（如 "选模板 → 配置 → 试评测"） |
| `business-entities` | §四.1 业务对象关系 | 这页操作的业务对象（如 `["评测集", "模板"]`） |
| `api-touch-points` | §五.3 上下游依赖 | 对接的外部 API / 上游服务（如有） |

> ⚠️ **节号兼容**：上表基于 prd-writer **v2.3+ 7 节结构**。如遇旧版 PRD（13 节 v2.2-），映射关系见 prd-writer SKILL.md 兼容表。

### 防线 3 · Agent 改原型的标准 prompt 协议

不要派 Agent「重写文件」，要派 Agent「**在现有基础上扩展/修改**」。

#### 标准 prompt 模板

```
必读：
1. {file-path}（当前文件）
2. {file-path} 头部的 prototype-meta 注释（必须保留 key-features 中列出的功能）
3. skills/saas-prototype-design/_BUILD_SPEC.md（设计规范）

任务：
在 {file-path} 现有 HTML 基础上做以下修改（不重写整页）：

【保留】
- sidebar / topbar / brand
- 所有 prototype-meta 中列出的 key-features
- 现有交互（Modal / Drawer / Toast / Wizard）

【修改】
- {section X}：{改成什么样}

【删除】
- {section Y}：{为什么删}

【新增】
- {新功能}：{放在哪里}

完成后必做：
1. 更新 prototype-meta：version 升级 / last-modified 时间 / 加 changelog 条目
2. 报告：原行数 → 新行数 + 改动清单
3. 用 grep 自检：「Step N」「v0.x」「v1 / v2」「TODO」等过时引用 = 0

禁止：
- 删除 prototype-meta key-features 中列出的功能
- 重写整页
- 引入新外部依赖（Tailwind CDN 等）
- 用占位文字「TBD」「待补充」
```

#### 关键点

1. **必读 prototype-meta** — 强制 Agent 先看历史功能再改
2. **保留 / 修改 / 删除 / 新增 4 字段** — 改动必须分类声明，避免误删
3. **更新 prototype-meta + changelog** — 留痕 Agent 改了什么
4. **完成后 grep 自检** — 抓文案残留

## Helper 脚本（真相源 = skill 的 `scripts/` 目录,本文不内嵌副本）

> v2.2 起此处不再粘贴脚本源码——曾因内嵌副本与 `scripts/` 实际版本漂移,导致两边检查规则不一致(占位按钮检查一边正常一边静默)。**改脚本只改 `scripts/`,此处只记用法。**

### `scripts/snapshot.sh` — 大改前备份

```
bash <skill>/scripts/snapshot.sh <file-or-dir>
```

备份到同目录 `.history/`,文件名带 `YYYYMMDD-HHMM` 时间戳;支持单文件或整目录。

### `scripts/check-residual.sh` — 改后残留自检

```
bash <skill>/scripts/check-residual.sh <file>
```

7 项检查:PM 规划性术语 / Step 步数残留 / 死链 `href="#"` / 占位按钮(无 data-action·onclick·submit,含明细定位)/ data-action 种类清单 / Modal·Drawer 触发与容器配对 / prototype-meta 存在性。

## 团队规范

**所有人 + 所有 Agent 改原型时都必须**：

1. 改前 `bash snapshot.sh <file>` 备份
2. 改前 Read `<file>` 头部 prototype-meta
3. 用「保留 / 修改 / 删除 / 新增」prompt 模板派 Agent
4. 改完更新 prototype-meta + changelog
5. 改完 `bash check-residual.sh <file>` 自检

## 灾难恢复

如果某文件被覆盖丢失了关键功能：

```bash
# 列出该文件所有历史快照
ls -lt prototypes/v0.1/.history/eval-sets.*

# 比较丢失功能在哪个版本还在
for f in prototypes/v0.1/.history/eval-sets.*.html; do
  echo "$f: $(grep -c "启用/停用 toggle" "$f")"
done

# 恢复最近含该功能的版本（或部分摘取）
diff prototypes/v0.1/eval-sets.html prototypes/v0.1/.history/eval-sets.20260513-1450.html
```
