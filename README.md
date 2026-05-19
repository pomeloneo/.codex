# Codex Configuration

This repository tracks the reusable, reviewable Codex configuration surfaces from
`~/.codex`.

Tracked:

- `AGENTS.md`
- `agents/`
- `agent-instructions/`
- `prompts/`
- `scripts/`
- `skills/`
- `version.json`

Intentionally excluded:

- Authentication and local configuration: `auth.json`, `config.toml`
- Conversation and command history: `history.jsonl`, `sessions/`,
  `archived_sessions/`, `session_index.jsonl`, `shell_snapshots/`
- Runtime state and logs: `*.sqlite*`, `log/`, `logs_*.sqlite*`,
  `state_*.sqlite*`
- Local approval policy and command history: `rules/`
- Caches, temporary files, plugins, vendored imports, and application bundles:
  `cache/`, `tmp/`, `.tmp/`, `plugins/`, `vendor_imports/`, `computer-use/`

Before adding new tracked paths, check that they do not contain credentials,
conversation history, local machine state, or proprietary project data.

## Auto Sync

This repo can be auto-synced with GitHub through a local launchd agent.

Install or refresh the agent:

```bash
scripts/install-auto-sync-launchd.sh
```

The agent runs `scripts/auto-sync.sh` when tracked configuration paths change.
The script:

- stages only the explicit tracked paths listed in the script
- refuses known sensitive/runtime paths
- scans staged content for common token and private-key patterns
- commits and pushes to `origin/main`

Logs are written to `log/auto-sync-git.log` and are intentionally ignored.
