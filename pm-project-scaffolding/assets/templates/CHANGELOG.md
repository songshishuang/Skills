# Changelog

本文档记录 **{{PROJECT_NAME}}** 产品 / 项目层面的重大变更（PM 视角的版本史）。代码层面的细粒度 commit 见 `git log`。

格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 的精神，按"产品阶段"组织版本号。

---

## [Unreleased]

### 计划新增
- ⚠️ TODO

### 待定
- ⚠️ TODO

---

## [v0.1] — {{DATE}} · 项目启动

### 新增
- 项目初始化（使用 `pm-project-scaffolding` skill 生成标准目录骨架）
- PM 完整生命周期 8 阶段对应的目录结构就位
- 首份 PRD 占位

### 文档
- README.md / CHANGELOG.md / CLAUDE.md / roadmap.md 顶层文档完整

---

## 维护约定

- **谁 push 谁更新**：产品功能上线、目录结构调整、PRD 主版本变更，都在 `[Unreleased]` 段加一行
- **版本切割**：每完成一个里程碑（v0.1 → v0.5 → v1.0），把 `[Unreleased]` 内容归并到新版本号下，留空 `[Unreleased]`
- **变更分类**：新增 / 变更 / 移除 / 修复 / 文档——按场景选最贴切的
- **不写细节**：代码层面的"修 bug、改字段"不进 CHANGELOG——那是 git log 的事
