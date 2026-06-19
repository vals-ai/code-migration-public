Your goal is to migrate the Rust repository located in '/source/Rust-Original/' into {target} code.
The new {target} code should be created in the empty '/submission/' directory.
All functionality of the original code must be ported.
The output of any given command should be *exactly* the same. This includes any formatting - from text placement to color.
The '/submission/' directory must contain a Dockerfile that builds and runs the migrated {target} CLI tool.

## Extensions

The migrated CLI must accept and implement every extension the upstream comrak CLI exposes via `--extension`.

The `--extension` flag accepts comma-separated values and may be given multiple times; both forms must be supported, and extensions must compose correctly when combined.

The `--gfm` aggregate flag must enable the GFM core set (strikethrough, tagfilter, table, autolink, tasklist) plus `--github-pre-lang` and `--gfm-quirks`, matching the reference.

The `--gemoji` flag (translating shortcodes like `:thumbsup:` into Unicode emoji) must also be implemented.

**Delegating the parse or render step to a third-party Markdown library is forbidden; doing so will fail the task.** A partial reimplementation that exercises some of the surface is preferred over a complete wrapper.

Pay special attention to HTML output formatting: comrak's Rust implementation produces specific tag structures, class names, and attribute ordering that must match exactly.

Key areas to get right:
- GFM table rendering: exact column alignment, `<thead>`, `<tbody>`, `<th align="...">` attributes
- Footnote back-references: the exact Unicode `↩` character and superscript numbering format
- Smart punctuation: curly quotes (`“`, `”`, `‘`, `’`), em-dash (`—`), en-dash (`–`), ellipsis (`…`)
- Code block info strings: `<code class="language-X">` vs `<pre lang="X">` depending on the github-pre-lang setting
- XML output schema: node types, attribute names, nesting structure
- CommonMark output: exact escaping rules, list marker preservation, setext vs ATX headings

## Running the Reference Implementation

The reference implementation is available locally under `/reference`. Run `/reference/canary.sh` before probing it; that loads the reference Docker image as `code-migration-reference:current`. Do not copy reference files into `/submission`.
