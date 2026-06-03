---
name: obsidian-vault
description: Search, capture, edit, diagram, and organize the user's Obsidian knowledge base across work and personal machines. Use when the user asks Codex to record useful conversation findings into Obsidian, preserve project/repository exploration notes, create business-learning reports, capture general durable knowledge, save key Q&A, visualize process or workflow content with Mermaid plus Obsidian Canvas, search the user's personal note context, maintain wikilinks/backlinks/index notes, or make explicit Obsidian vault/config changes.
---

# Obsidian Vault

Use this skill to work with the user's Obsidian vault as a personal knowledge system, not just as a folder of Markdown files.

## Default Behavior

- Preserve useful knowledge from AI-agent conversations as structured notes, not raw transcripts.
- Prefer durable information: conclusions, key Q&A, architecture/business understanding, decisions, evidence, open questions, and next actions.
- Use existing notes and folders when they fit. Do not create taxonomy for its own sake.
- When note content includes a process, workflow, decision path, lifecycle, control flow, data flow, user journey, or multi-step business/system interaction, represent it twice: an inline Mermaid diagram and a linked Obsidian Canvas file.
- Place the Mermaid diagram and Canvas link directly below the relevant section, list, table, or Q&A block rather than collecting all diagrams at the end.
- Do not put new notes under `personal/` by default.
- Do not search `lesson/` by default. Only include course/learning material when the user explicitly asks to search courses, lessons, or learning content.
- Do not modify Obsidian config/profile directories unless the user explicitly asks for plugin, theme, hotkey, workspace, or app configuration changes.

## Load References

- Read `references/vault-map.md` before choosing paths, detecting profiles, or changing Obsidian config.
- Read `references/workflows.md` before capturing project exploration, business learning, Q&A, or personal-context lookup.
- Read `references/diagram-pairs.md` before creating or updating process, workflow, data-flow, control-flow, lifecycle, or journey content.
- Read `references/templates.md` before creating a substantial new note or report.

Use `scripts/detect_vault_profile.py` when the current vault root or active profile is unclear.

## Vault Roots

Known content vault roots:

- Work machine: `/Users/bytedance/Documents/Obsidian Vault`
- Personal machine: `/Users/neo/Documents/Obsidian Vault`

Known profile config directories:

- `work`: `.obsidian_work`
- `personal`: `.obsidian_personal`

For ordinary note content, the active profile usually does not matter. For config/plugin/theme/hotkey/workspace changes, determine the profile first; if evidence conflicts or is ambiguous, stop and ask.

## Default Note Destinations

- User-owned project or product planning: `项目/<项目名>/`
- Repository/codebase exploration: `代码库/<仓库名> 项目探索.md`
- Business/domain learning reports: `业务学习/<业务名> 学习报告.md`
- General durable knowledge: `知识沉淀/<主题>.md`
- Daily or short-lived notes: `daily_record/`
- Course archives: `lesson/` only when explicitly requested

Legacy notes may exist under `项目分析/` or `personal/项目分析/`. Read them when relevant, but do not move them unless the user explicitly asks to reorganize.

## Safety Rules

- Preserve existing folder structure, note style, headings, YAML frontmatter, tags, callouts, embeds, and wikilinks.
- Before creating a note, search for an existing note with the same or closely related topic.
- Prefer editing a small, explicit set of notes. Ask before broad rewrites, bulk moves, or cross-vault reorganizations.
- Treat `.canvas` files created for a note as normal content assets. Create or update them only when they directly support the note being edited, and leave unrelated Canvas files alone.
- Do not edit `.obsidian/`, `.obsidian_work/`, `.obsidian_personal/`, `.trash/`, plugin files, generated attachments, or large binary assets unless explicitly requested.
- When moving or renaming notes, update affected wikilinks and report the changed files.

## Search Rules

Use `rg` and `rg --files` first.

Default content search should exclude hidden/config/trash directories and `lesson/`:

```bash
rg -n "keyword" "/Users/bytedance/Documents/Obsidian Vault" \
  -g '*.md' \
  -g '!lesson/**' \
  -g '!awesome-codex-skills/**' \
  -g '!**/.obsidian*/**' \
  -g '!**/.trash/**'
```

Include `lesson/` only when the user explicitly asks to search course or learning material.

When checking for existing Canvas companions, search `.canvas` files explicitly:

```bash
rg --files "/Users/bytedance/Documents/Obsidian Vault" \
  -g '*.canvas' \
  -g '!lesson/**' \
  -g '!awesome-codex-skills/**' \
  -g '!**/.obsidian*/**' \
  -g '!**/.trash/**' | rg -i "keyword"
```

## Linking Rules

- Plain note link: `[[Note Title]]`
- Aliased note link: `[[Note Title|display text]]`
- Heading/block links: `[[Note Title#Heading]]`, `[[Note Title#^block-id]]`
- Embeds: `![[Attachment.png]]` or `![[Note Title]]`
- Canvas link: `[[path/to/Flow.canvas|Open Flow Canvas]]` or a Chinese alias matching the note style.

When adding links, prefer the note title that actually exists on disk. Search first if unsure.

## Capture Quality Bar

When preserving an AI-agent conversation into Obsidian:

- Extract key Q&A instead of saving the entire chat.
- Separate confirmed facts from assumptions and open questions.
- Preserve source paths, URLs, commands, or evidence when they matter.
- Write notes so future Codex sessions can quickly recover context.
- If a note becomes too long, split by durable topic and add links from an index/MOC note.

## Routing Rules

When the user asks to "record this", "save this to Obsidian", "沉淀成笔记", or similar:

1. Use an explicit target note or folder if the user provides one.
2. Use `项目/<项目名>/` for user-owned project planning, product ideas, PRDs, implementation plans, roadmaps, and ongoing project decision records.
3. Use `代码库/` for repository, codebase, service, system, or source-tree exploration notes.
4. Use `业务学习/` for business, domain, industry, product, or process learning.
5. Use `daily_record/` for same-day temporary notes, quick logs, or explicit daily notes.
6. Use `知识沉淀/` for everything else that should be durable: methods, tool usage, troubleshooting lessons, AI-agent workflows, reusable decisions, thinking patterns, and general lessons learned.

Before creating a note in `知识沉淀/`, search for an existing related note and update it when that is more useful than creating another file.
