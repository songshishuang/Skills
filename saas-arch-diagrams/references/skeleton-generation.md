# arch-skeleton.yaml 切片生成规则（v2.0 新增）

> 仿 `prd-writer` v2.3 角色切片机制：HTML 架构图是人类消费物，但 AI agent（`pm-wiki-maintainer` ingest / `prd-writer` Stage 1 引用 / 自动 lint）需要**机器可读骨架**。每次画完架构图同时派生 `arch-skeleton.yaml`，下游 AI 工具直读 YAML 不读 HTML。

## 设计原则

1. **HTML 全本是 source of truth · skeleton.yaml 自动派生**（禁手工编辑）
2. **仅含 4 维元数据**：层 / 能力域 / 子能力 / 端 —— 不含视觉细节（CSS / 色彩 / 布局）
3. **每次架构图改动后重新生成**（写入 frontmatter `generated_at` 时间戳）
4. **下游消费契约固定 · 跨版本兼容**：字段名不轻易改，只追加新字段
5. **生成时机自动**：架构图 HTML 落盘后立即派生，与 HTML 同名（如 `产品架构图.html` → `产品架构图.skeleton.yaml`）

## YAML schema（v1）

```yaml
# 自动生成 · 勿手工编辑
meta:
  source_html: docs/product-planning/功能架构图.html
  diagram_type: functional   # functional | product
  version: V0.1
  generated_at: 2026-06-01
  generated_by: saas-arch-diagrams skill v2.0

# 4 层骨架（功能架构图）· 产品架构图只有 layers + ecosystem，无 capability_domains
layers:
  - id: L1
    name: 端层
    role: 用户使用的客户端入口
  - id: L2
    name: 业务服务层
    role: 核心业务能力
  - id: L3
    name: 数据资产层
    role: 数据存储 / 知识库 / 评测集
  - id: L4
    name: 平台底座
    role: 基础设施 / 监控 / 计量

# 端清单
endpoints:
  - id: ops
    name: 运营端
    layer: L1
    user_roles: [运营人员, 评测工程师, 采购]
  - id: vendor
    name: 供应商端
    layer: L1
    user_roles: [供应商账号]

# 能力域（功能架构图独有）
capability_domains:
  - id: A
    name: 供应商生命周期
    color: purple                    # 仅作示例色 · 实际项目自定义
    sub_capabilities:
      - id: A1
        name: 入驻准入
        layer: L2
        pages: [vendor-onboarding.html, ops-vendor-review.html]
        out_of_scope: false          # true = dotted 置灰 + line-through
        downstream: null             # 不在本平台 → 标下游
  - id: B
    name: 质量评估
    color: amber
    sub_capabilities:
      - id: B1
        name: 评测任务
        layer: L2
        pages: [ops-eval-list.html, ops-eval-pipeline.html, ops-eval-report.html]
        out_of_scope: false

# 生态关系（产品架构图独有 · 功能架构图可空）
ecosystem:
  upstream: [模型供应商账号, 第三方评测集来源]
  downstream: [API 网关聚合层, 业务方接入应用]
  external_deps: [合规备案系统, 财务结算系统]

# 横切关注点
cross_cutting:
  - 治理（横切 A/B/C/D）
  - 安全合规（横切 A/B/C/D）
  - 计量计费（横切 B/C/D）
```

## 下游消费场景

### 场景 1 · pm-wiki-maintainer ingest

`pm-wiki-maintainer` 收到「ingest 架构图到 wiki」指令时：
1. **不读 HTML**（充满 lyr-N / col-span CSS class 噪音）
2. **读 arch-skeleton.yaml** 提取：
   - `capability_domains[].name` → 写入 `docs/wiki/concepts/<能力域>.md`
   - `endpoints[]` → 写入 `docs/wiki/entities/roles/<角色>.md`
   - `ecosystem.downstream/upstream` → 写入 `docs/wiki/topics/生态关系.md`
3. 完整 ingest 映射表见 `pm-wiki-maintainer/references/ingest-workflow.md`「从架构图 ingest」

### 场景 2 · prd-writer Stage 1 引用

`prd-writer` Stage 1 写 PRD §三 需求范围时，**自动读 arch-skeleton.yaml**：
- `endpoints[].name` → PRD §二.2 用户角色清单
- `capability_domains[].sub_capabilities[]` → PRD §三.1 需求清单的"系统"列
- `ecosystem.downstream` → PRD §五.3 上下游依赖

避免 PM 手填重复，且**保证 PRD 与架构图能力域命名一致**（自动通过本 yaml 对齐）。

### 场景 3 · 自动 lint

简单 lint 规则（用 `yq` / `jq` 即可，无需 LLM）：
- `endpoints[].layer` 必须 == L1（端层）→ 违反报错"端不在 L1 层"
- `sub_capabilities[].pages` 至少 1 项 → 违反报错"子能力无入口页面"
- `capability_domains[]` 数量 ≥ 2 时必须有 `cross_cutting` → 强提示加横切
- `out_of_scope: true` 必须有 `downstream` 或 `external_deps` 引用 → 反模式 10 自动检测

## 生成流程

`saas-arch-diagrams` skill 完成架构图后**额外做一步**：

1. **解析 HTML**：读 HTML，按 class 名（`.lyr-1` / `.layer` / `.cap-domain` / `.sub-cap` / `.m-out`）提取结构
2. **填 skeleton.yaml**：按上文 schema 填字段
3. **写入磁盘**：与 HTML 同目录同名 `.skeleton.yaml`
4. **告知用户**：「✅ 同步生成 arch-skeleton.yaml · 下游 wiki ingest / PRD 引用 / lint 都可直接消费」

## 不该做的

- ❌ 把 CSS class / 色彩 / col-span / inline style 放进 yaml（这些是视觉，下游不需要）
- ❌ 手工编辑 yaml（永远从 HTML 重新生成）
- ❌ 字段名乱改（破坏下游消费契约）
- ❌ 把 ADR / 决策细节塞 yaml（那是 `pm-wiki-maintainer/decisions/` 的事）

## 反模式

| ❌ 反模式 | ✅ 正确做法 |
|---|---|
| HTML 改了不重新生成 yaml | 加 git pre-commit hook：HTML 改 → yaml 重新生成 |
| yaml 手工填写覆盖自动生成 | yaml frontmatter 加 `generated_by` 标记，禁止手工 |
| 下游消费者 grep HTML 找能力域名 | 改为读 yaml，省 95% token |
| 把 `out_of_scope: true` 写在 HTML class 上 | yaml 是 source of truth；HTML 渲染时按 yaml 决定是否加 dotted class |
