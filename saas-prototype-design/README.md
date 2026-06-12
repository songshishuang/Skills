# saas-prototype-design

> **别人教 AI 把界面画得好看,这个 skill 防 AI 把原型做坏。**

AI 生成企业后台原型的真实痛点从来不是"不会画",而是:多人多 Agent 改着改着设计语言漂移、精心迭代的功能被一次大改覆盖丢失(我们发生过 3 次)、同样的返工坑反复踩。本 skill 把一个企业 SaaS 项目 **30+ 轮迭代、55+ 页原型**的实战经验蒸馏成可执行纪律。

## 为什么装它

| 资产 | 数量 | 说明 |
|---|---|---|
| 不可违反铁律 | **12 条** | 每条来自真实返工(端的定义 / 中文字段 / 真实示例数据…) |
| 反模式负样本库 | **29 条** | ❌ 错误写法 + ✅ 修正 + 排查脚本——全生态稀缺的"踩坑账本" |
| 组件模式 | **25 个** | sidebar / filter-form / drawer / wizard / 分页器 / 状态机字典… 含精确数值规格 |
| 模板资产 | **5 件** | tokens.css(5 配色 × 明暗)/ chrome 框架 / 起手页面骨架 / 主题切换器 |
| 防覆盖机制 | **1 套** | snapshot 备份 + prototype-meta 留痕 + Agent 改写「保留/修改/删除」协议 + 残留自检脚本 |

它独有的两件事(经同类调研验证,Anthropic 官方 frontend-design、90k+ 星的风格库均不具备):**真实返工反模式库**与**历史版本保护协议**。

## 30 秒上手

```bash
# Claude Code(个人级安装)
git clone https://github.com/songshishuang/Skills /tmp/skills && \
  cp -R /tmp/skills/skills/saas-prototype-design ~/.claude/skills/
```

触发方式——对 Claude 说(更多触发词见 SKILL.md frontmatter):

> 用 saas-prototype-design 做一个「工单列表页」高保真原型

或从 0 起手:复制 `templates/page-skeleton.html`,按 SKILL.md「主工作流 7 步」走。

其他平台(Codex / Cursor / Gemini / Copilot)安装路径见 SKILL.md「跨平台支持」段。

## 文件地图

```
SKILL.md                      # 入口:12 铁律 + 主工作流 7 步 + 速查表
references/
├── design-tokens.md          # 设计语言完整规范(5 配色 × 明暗 × 密度)
├── component-patterns.md     # 通用组件 §1-§18
├── business-components.md    # 业务特化组件 §19-§25(评级/雷达/告警/健康灯)
├── anti-patterns.md          # 29 条反模式(本 skill 的灵魂)
├── history-protection.md     # 防覆盖三铁律
├── agent-protocol.md         # 派 Agent 改原型的标准 prompt
└── changelog-archive.md      # v1.x 演进史
templates/                    # tokens.css / chrome.css / chrome.js / page-skeleton.html / theme-switcher.html
scripts/                      # snapshot.sh(备份)/ check-residual.sh(7 项自检)
```

## 不适用

生产前端工程、C 端营销页、架构图(→ saas-arch-diagrams)、从原型反推 PRD(→ prd-writer)。
