# 派 Agent 改原型的协议

## 核心原则

> Agent 永远在「修改」而非「重写」。

## 4 种典型 Agent 任务 + 对应 prompt 模板

### 类型 1 · 局部增删（如「Step 2 加字段映射动态化」）

```
必读：
1. {file-path}（当前 N 行 · 头部 prototype-meta 含 key-features）
2. references/component-patterns.md §X
3. references/design-tokens.md

任务：定位到 {section}，做 {具体改动}。

【保留】sidebar / topbar / 现有 modal / drawer / wizard 步数
【修改】{section X 的 Y 部分}：{改成 Z}
【删除】无
【新增】无

完成后：
- 更新 prototype-meta version: x.y.z → x.y.(z+1)
- 加 changelog 一行
- 报告：行数变化 + 改动清单（≤ 5 条）
- grep 自检：删除任何残留引用
```

### 类型 2 · 全面重构（如「wizard 5 步 → 2 步」）

```
必读：
1. {file-path}（当前结构 · 必须先 Read 全文）
2. references/anti-patterns.md §21（wizard 步数频繁变化）
3. references/component-patterns.md §10（wizard）

任务：将 wizard 从 N 步重构为 M 步。

【保留】
- prototype-meta 中 key-features 列出的所有功能（必须逐条核对）
- 设计 token / chrome / 现有交互
- mock 数据真实性

【修改】
- Stepper：N 步 → M 步
- step-panel data-panel 编号重排
- 按钮 data-step-target 重排（如 4 → 3）
- step-actions 按钮文案（如「下一步：Metric」→「下一步：校验」）
- 顶部 page-subtitle「N 步向导」→「M 步向导」

【删除】
- 第 X 步 panel 整段（连同 stepper-item + stepper-line）
- 相关 JS（如 skip-trial handler）

【新增】
- 无（除非合并需要新 sub-section）

完成后必做：
1. grep -nE "Step [0-9]" {file} → 确认无过时引用
2. grep -nE "N 步" {file} → 确认全是新数字 M
3. 提交按钮文案有意义（如「提交入库（审批后生效）」不是「下一步」）
4. 测试每个 stepper-item 点击可跳转
5. 更新 prototype-meta + changelog
```

### 类型 3 · 复制为基础 + 改造（如「v1 → v0.1 迁移」）

```
⚠️ 此类任务最易丢失迭代功能！必须严格遵守：

必读：
1. {target-file}（目标文件 · 如已存在，必须先备份 → .history/）
2. {source-file}（源文件）
3. {target-file} 头部 prototype-meta（若存在）

任务：以 {source-file} 为基础，覆盖 {target-file}，并按以下规则**精修保留功能**。

第 1 步 · 备份目标文件：
  bash skills/saas-prototype-design/scripts/snapshot.sh {target-file}

第 2 步 · 提取目标文件的 key-features：
  - 读 {target-file} 头部 prototype-meta（如有）
  - 否则 grep 出关键功能：data-toggle / sub-tab / 模态 ID / wizard 步数等

第 3 步 · 复制源文件作为新模板。

第 4 步 · 对照 key-features 清单逐条恢复：
  for feature in features:
    if feature 在源文件中没有:
      手动从备份 .history/{file}.{timestamp}.html 中提取代码片段，插入新文件
    else:
      跳过（源文件已有）

第 5 步 · 写入新 prototype-meta（version + changelog）

完成后：
- 报告：恢复了哪些 key-feature（清单）+ 删除了哪些（清单）+ 新增了什么
- 不允许「丢失」key-feature 而不报告

【严禁】
- 直接 cp 覆盖（不读 key-features）
- 用源文件完全替代（不保留迭代）
- 不更新 prototype-meta
```

### 类型 4 · 批量同步（如「13 文件 sidebar 统一」）

```
必读：
1. 1 个范例文件的 sidebar 段（如 prototypes/v0.1/index.html sidebar）
2. references/design-tokens.md（sidebar 类名规范）

任务：用 Python 脚本批量替换 {N 个文件} 的 sidebar 段为统一结构。

策略：
1. 提取范例 sidebar HTML（含 brand + nav + footer）
2. Python 脚本对每个目标文件：
   a. Read 文件
   b. re.sub 匹配 <aside class="sidebar">...</aside> 整段
   c. 替换为新 sidebar HTML（保留该文件原 active 项）
   d. Write 回去
3. 用 grep 验证：每文件都有新结构 / active 项正确 / brand 一致

【保留】每个文件的 main 区 / topbar / scripts / styles 不动
【批量修改】仅 sidebar 段

完成后：
- 报告：成功更新 N 个文件
- 每个文件的 active 项落位是否正确（用 grep 检验）
- 1 个文件抽样验证渲染正常
```

## 防 Agent 失控的 5 个红线

### 红线 1：不读 prototype-meta 不许改

任何 Agent 必须先 Read 文件头部 prototype-meta（如有），列出要保留的 key-features，再开始改。

### 红线 2：删除功能必须报告

不允许 Agent「悄悄」删除功能而不在完成报告中明示。

### 红线 3：不更新 prototype-meta 不算完成

每次改完必须更新 version + last-modified + changelog 条目。

### 红线 4：超过 200 行的改动必须先备份

```
work-size > 200 lines → snapshot.sh required
```

### 红线 5：所有占位按钮必须有 action

```
<button>X</button>  ❌
<button data-action="...">X</button>  ✓
```

## 多 Agent 并行的协调

多个 Agent 同时改不同文件时：

- ✅ 不同目录 / 不同文件 → 并行安全
- ⚠️ 同文件多 Agent → 后改的会覆盖前改的，**禁止**
- ⚠️ 跨文件共享资源（如 tokens.css）→ 串行，每次只 1 个 Agent 改

派多 Agent 前自检：

```bash
# 列出每个 Agent 将改的文件
Agent 1: prototypes/v0.1/eval-sets.html
Agent 2: prototypes/v0.1/admission.html
Agent 3: prototypes/v0.1/admission-eval-upload.html

# 检查无重复
sort -u {Agent file list} 是否等于 原始列表
```

## 验收 Agent 产出的 checklist

收到 Agent 完成报告后：

```
[ ] 文件实际存在且行数符合报告
[ ] head 中 prototype-meta 已更新（version 升级 + changelog 新行）
[ ] grep 检查无过时引用（旧 Step / 旧版本 / TODO）
[ ] 抽样测试 1-2 个交互（按钮 / drawer / tab 切换）能正常工作
[ ] sidebar / topbar / brand 未被无意改动（与同目录其他文件一致）
[ ] 设计 token 类名一致（无 Tailwind 残留）
```
