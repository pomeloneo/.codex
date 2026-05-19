---
name: claude-rulebook
description: Use when a task would benefit from the user's migrated Claude rulebook, including shared engineering standards and language-specific coding guidance. Consult the references that match the current stack before implementing or reviewing changes.
---

# Claude Rulebook

This skill exposes the user's Claude rule set to Codex in a skill-compatible way.

## When to use

- The task needs coding standards or review checklists.
- The project stack matches one of the imported rule sets.
- You need common engineering guidance plus language-specific rules.

## How to use

1. Read the relevant files under `references/rules/common/`.
2. Read the language or domain folder that matches the task, such as:
   - `references/rules/python/`
   - `references/rules/golang/`
   - `references/rules/java/`
   - `references/rules/rust/`
   - `references/rules/swift/`
   - `references/rules/typescript/`
   - `references/rules/web/`
3. Treat these files as coding guidance and review standards, not as Codex execution-policy rules.
4. If repository-local AGENTS or project instructions conflict with this rulebook, prefer the more specific project guidance.

## Notes

- These references were copied from the user's `~/.claude/rules/` directory.
- Claude `rules/` markdown is not natively executable by Codex, so this skill is the compatibility layer.
