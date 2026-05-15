# Prototypes · 高保真原型

> {{PROJECT_NAME}} 各角色工作台的高保真原型。

## 角色

按业务角色分子目录（roles: `{{ROLES}}`）：

⚠️ TODO：补充每个角色的业务定位 + 入口文件

| 子目录 | 角色 | 入口 | 业务定位 |
|---|---|---|---|
| `{role-1}/` | ⚠️ TODO | `index.html` 或 `workbench.html` | ⚠️ TODO |

## 共享资源

- `assets/` — 共享 mock 数据 / 组件 / 样式
- `index.html` — 多角色导航 hub

## 关键设计原则

⚠️ TODO（参考原型设计阶段沉淀的项目特有约定）：

1. 多端独立 · 不共享运行时状态
2. 视觉一致性约定（颜色 / 字体 / 间距）
3. 交互模式（modal / artifact / sidebar）

## 本地预览

```bash
# 从仓库根目录
python3 -m http.server 8000
# 浏览器打开 http://localhost:8000/prototypes/
```

## 演进路径

当前是高保真原型——**有意为之**：

- 用原型阶段把交互模式、关键设计决策先验证
- PRD 和原型评审通过后，再启动工程实施（`../app/`）

避免过早工程化被沉没成本绑架。
