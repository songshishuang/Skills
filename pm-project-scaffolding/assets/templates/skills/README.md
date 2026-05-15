# Skills 库

> 可对外整体分发的 Skill 库——**每个 Skill 目录是干净的可交付包**。

## 设计哲学

`skills/{name}/` 是对外可分发的 Skill 包；设计计划单独放 `skills/plan/`——保持每个 Skill 目录的纯净。

如果客户要部署一个 Skill，把 `skills/{name}/` 整个目录给他即可，不会带上内部设计稿。

## 标准 Skill 目录结构

```
skills/{skill-name-slug}/
├── SKILL.md                 主入口（YAML frontmatter + 引导）
├── scripts/                 可执行脚本（.sh / .py）
├── references/              知识库（多份 .md）
└── assets/                  资源（模板 / 截图 / 样例数据）
```

## 设计计划

每个 Skill 在落地实现前，应该先写设计计划——放 [`plan/`](./plan/) 目录。

## 命名约定

- `skill-name-slug`：英文小写连字符
- `SKILL.md`：全大写（Anthropic 标准约定）

## 当前 Skill 列表

⚠️ 目录刚初始化。计划开发的第一个 Skill 时先在 `plan/` 写设计计划，再创建 `{name}/` 目录。

## 关于 SKILL.md 的 YAML frontmatter

```yaml
---
name: skill-name-slug
description: 一句话描述 + 触发关键词。当用户提到 X / Y / Z 时使用。
---
```

`description` 字段直接影响触发准确率——必须包含**用户可能用到的关键词**和**明确的触发场景**。
