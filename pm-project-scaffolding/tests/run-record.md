# 实跑存档 · 2026-06-13（Y-012 大修）

| 场景 | 命令要点 | 结果 |
|---|---|---|
| T1 ai-saas | --type ai-saas --roles operator,admin | exit 0；产物含 skills/ + prototypes/；`docs/wiki/index.md` 首行=pm-wiki-maintainer 模板版 ✓；entities 四子目录 ✓ |
| T2 特殊字符 | --tagline "AI & Data \| 一体化平台" --type internal-tool | exit 0；README 逐字保留「AI & Data \| 一体化平台」✓（修复前同输入会损坏渲染——sed & 展开） |
| T3 非法 NAME | --name "Bad/Name" | **exit 1** + 报错「仅允许小写字母/数字/连字符」✓，零产物落盘 |

T4（AI 行为）未实测——估分项，待装载实例跑。
环境：macOS bash，沙箱 /tmp；修复版 init.sh（sed 转义 + NAME 校验 + 真相源消费）。
