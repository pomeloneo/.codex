# Global Guidance for Codex

Adapted from `/Users/bytedance/.claude/AGENTS.md` for Codex on 2026-04-23.

## Surface Policy

- `skills/` is the canonical reusable workflow surface.
- Prefer plugin-provided capabilities first when the same workflow is already available.
- Use skills for deeper playbooks and domain guidance.
- Use `~/.codex/prompts/*.md` only for explicit legacy slash commands. Prefer skills for reusable instructions.
- Use the `claude-rulebook` skill when migrated Claude coding standards are relevant.

## Maintenance Rules

- Prefer one canonical surface for each workflow.
- If an ad-hoc workflow becomes repeatable, convert it into a skill.
- Avoid duplicating the same policy across `AGENTS.md`, skills, and project docs.

## Quality Bar

- All tests pass with 80%+ coverage.
- No security vulnerabilities.
- Code is readable and maintainable.
- Performance is acceptable.
- User requirements are met.
