# Wiki Maintenance Log

> Append-only。每条以 `## [YYYY-MM-DD] <action> | <title>` 开头，可 grep。
>
> 三类 action：
> - `ingest` — 摄入新源
> - `query` — 查询（如产生新 page 也记）
> - `lint` — 体检（含发现 + 修复）
>
> 速查：
> ```bash
> grep "^## \[" log.md | tail -5        # 最近 5 条
> grep "^## .* ingest " log.md           # 所有 ingest
> grep "^## .* lint " log.md             # 所有 lint
> ```

---

## [{{DATE}}] init | wiki 骨架就位

由 `pm-project-scaffolding` 初始化生成 docs/wiki/ 空骨架：
- `index.md` / `log.md` / `CLAUDE.md`
- `concepts/` · `entities/` · `decisions/` · `topics/`
- `glossary.md`

下一步：用 `pm-wiki-maintainer` skill 触发 ingest，开始填充 wiki。
