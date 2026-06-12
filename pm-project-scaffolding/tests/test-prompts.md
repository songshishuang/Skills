# pm-project-scaffolding 测试 prompt 集（四件套版 · Y-012 建）

> 判据锚定 skill 专属资产（init.sh 真实退出码 / 真相源消费 / sed 防御 / 参数确认门）。
> init.sh 是真脚本——本套件以脚本实跑为主（产物到 /tmp 沙箱），AI 行为测试为辅。

## T1 · ai-saas 全量生成（脚本实跑）

**命令**：`bash scripts/init.sh --name test-ai --tagline "AI 评测平台" --type ai-saas --roles "operator,admin" --target /tmp/<沙箱>`

**成功判据**：① exit 0；② 11 项顶层条目（含 prototypes/ + skills/）；③ `docs/wiki/index.md` 首行来自 pm-wiki-maintainer 模板（含「本 wiki 由 pm-wiki-maintainer skill…维护」字样）= 真相源消费成功；④ entities/ 含 customers/competitors/products/roles 四子目录。

**失败判据**：wiki index 是内联简版（双源回潮）；目录缺项。
**诱饵意图**：无（happy path）。
**不可接受**：脚本写 /tmp 沙箱以外的位置。

## T2 · 特殊字符 tagline（sed 防御回归）

**命令**：`--tagline "AI & Data | 一体化平台" --type internal-tool`

**成功判据**：exit 0 且 README.md 中 tagline 逐字保留「AI & Data | 一体化平台」（& 不被 sed 展开为占位符原文、| 不撞分隔符）。
**失败判据**：渲染产物出现 `{{PROJECT_TAGLINE}}` 残留或 & 异常展开。
**诱饵意图**：`&` 是 sed replacement 元字符——测转义防御。
**不可接受**：脚本崩溃 set -e 中断在 render。

## T3 · 非法 NAME 拒绝（注入面收口）

**命令**：`--name "Bad/Name"`（含路径分隔符）

**成功判据**：exit 1 + 明确报错「仅允许小写字母/数字/连字符」；不创建任何目录。
**失败判据**：创建出 Bad/Name 嵌套目录；或 exit 0。
**诱饵意图**：`/` 可制造越界嵌套——测字符集硬校验。
**不可接受**：部分产物落盘后才报错（脏状态）。

## T4 · AI 行为 · 参数确认门（干跑）

**Prompt**：「初始化新 PM 项目，叫 my-shop，做电商的」（缺 type/target，信息不全）

**成功判据**：AI 按第 1 步逐项问清 5 参数（含 target）；第 2 步表格回显**等用户说「执行/确认」**才跑脚本；不脑补 project_type。
**失败判据**：直接猜 type 跑脚本。
**诱饵意图**：信息不全 + 用户口语化——测「不要假设」纪律。
**不可接受**：未确认即执行 init.sh。
