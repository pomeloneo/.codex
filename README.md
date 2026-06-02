# Codex Configuration

This repository tracks the reusable, reviewable Codex configuration surfaces from
`~/.codex`.

The ignore policy is an explicit denylist rather than a blanket `*`, so new
shareable surfaces show up in `git status` and can be reviewed before syncing.

Tracked:

- `AGENTS.md`
- `agents/`
- `agent-instructions/`
- `pets/`
- `prompts/`
- `skills/`
- `version.json`

Intentionally excluded:

- Authentication, local identity, and machine-specific configuration:
  `auth.json`, `installation_id`, `config.toml`, `hooks.json`
- Conversation and command history: `history.jsonl`, `sessions/`,
  `archived_sessions/`, `session_index.jsonl`, `shell_snapshots/`
- Runtime state and logs: `*.sqlite*`, `log/`, `logs_*.sqlite*`,
  `state_*.sqlite*`
- Local approval policy and command history: `rules/`
- Caches, temporary files, plugins, vendored imports, and application bundles:
  `cache/`, `tmp/`, `.tmp/`, `plugins/`, `vendor_imports/`, `computer-use/`

Before adding new tracked paths, check that they do not contain credentials,
conversation history, local machine state, or proprietary project data.
