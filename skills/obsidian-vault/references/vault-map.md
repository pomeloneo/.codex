# Vault Map

This reference defines where to search and write in the user's Obsidian vault.

## Known Vaults

| Machine | Vault root | Default profile | Config directory |
|---|---|---|---|
| work | `/Users/bytedance/Documents/Obsidian Vault` | `work` | `.obsidian_work` |
| personal | `/Users/neo/Documents/Obsidian Vault` | `personal` | `.obsidian_personal` |

`/Users/bytedance/Documents/Obsidian Vault` and `/Users/neo/Documents/Obsidian Vault` are the same logical content vault on different machines.

## Profile Detection

Profile matters only for Obsidian app/plugin/config changes. Ordinary Markdown note edits do not require choosing a profile.

Detection order:

1. If the user explicitly says `work` or `personal`, use that profile.
2. If the current path is under `/Users/bytedance/Documents/Obsidian Vault`, default to `work`.
3. If the current path is under `/Users/neo/Documents/Obsidian Vault`, default to `personal`.
4. If `.obsidian` is a symlink, resolve it and map the target to `.obsidian_work` or `.obsidian_personal`.
5. If profile evidence conflicts, stop and ask before editing config.

Use:

```bash
python3 ~/.codex/skills/obsidian-vault/scripts/detect_vault_profile.py
```

or:

```bash
python3 ~/.codex/skills/obsidian-vault/scripts/detect_vault_profile.py "/path/to/file/or/vault"
```

## Directory Semantics

Default writable note areas:

- `项目分析/`: new repository, codebase, system, or project exploration notes.
- `业务学习/`: business/domain learning reports and synthesized business context.
- `知识沉淀/`: durable knowledge that does not naturally belong to project analysis, business learning, or daily notes.
- `daily_record/`: daily notes and short-lived captures.

Context areas:

- `personal/项目分析/`: legacy project analysis notes. Read when relevant; do not move by default.
- `personal/`: personal long-term notes. Search when the user asks for personal habits, preferences, history, or prior thinking.

Normally excluded:

- `lesson/`: course archive. Search only when the user explicitly mentions courses, lessons, learning content, or asks to use course material.
- `awesome-codex-skills/`: active/source project material, not personal context unless the task is about these skills.
- `.obsidian/`, `.obsidian_work/`, `.obsidian_personal/`: app/profile config. Edit only on explicit config/plugin/theme/hotkey/workspace requests.
- `.trash/`, `_attachments/`, `*.assets/`, plugin data, and binary assets unless explicitly requested.

## Path Choice Rules

- Do not add a `personal/` prefix for new project or business notes.
- Use top-level `项目分析/` for project exploration by default.
- Use top-level `业务学习/` for business learning by default.
- Use top-level `知识沉淀/` for general reusable knowledge, methods, tool usage, troubleshooting lessons, AI-agent workflow notes, and durable conclusions that do not belong elsewhere.
- If an older related note exists under `personal/项目分析/`, read it for context and link to it rather than moving it automatically.
- Ask before creating a new top-level directory other than `项目分析/`, `业务学习/`, or `知识沉淀/`.

## Search Commands

Default vault search, excluding course and config content:

```bash
rg -n "keyword" "/Users/bytedance/Documents/Obsidian Vault" \
  -g '*.md' \
  -g '!lesson/**' \
  -g '!awesome-codex-skills/**' \
  -g '!**/.obsidian*/**' \
  -g '!**/.trash/**'
```

Filename search:

```bash
rg --files "/Users/bytedance/Documents/Obsidian Vault" \
  -g '*.md' \
  -g '!lesson/**' \
  -g '!awesome-codex-skills/**' \
  -g '!**/.obsidian*/**' \
  -g '!**/.trash/**' | rg -i "keyword"
```

Backlink search:

```bash
rg -n "\\[\\[Note Title(\\||\\]|#)" "/Users/bytedance/Documents/Obsidian Vault" -g '*.md'
```
