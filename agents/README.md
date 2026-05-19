# Codex Custom Agents

Generated from `~/.claude/agents` on 2026-04-23.

## Notes

- These are translated Claude-style agents for Codex.
- Codex custom agents are explicit-use roles; they do not auto-trigger just from their description.
- The agent TOML files live in `~/.codex/agents/`.
- Long-form role instructions are embedded directly in each TOML under `developer_instructions`.
- If a role depended on Claude-only tools or unavailable MCP servers, use the caveats column below as a warning.

## Registry

| Agent | Category | Model | Reasoning | Sandbox | Caveats |
|---|---|---|---|---|---|
| a11y-architect | Planning | gpt-5.4 | high | read-only | duplicate model in source |
| architect | Planning | gpt-5.4 | high | read-only | - |
| build-error-resolver | Execution | gpt-5.4 | medium | workspace-write | - |
| chief-of-staff | Planning | gpt-5.4 | high | read-only | - |
| code-architect | Planning | gpt-5.4 | medium | read-only | - |
| code-explorer | Research | gpt-5.4 | medium | read-only | - |
| code-reviewer | Review | gpt-5.4 | medium | read-only | - |
| comment-analyzer | Research | gpt-5.4 | medium | read-only | - |
| conversation-analyzer | Research | gpt-5.4 | medium | read-only | - |
| cpp-build-resolver | Execution | gpt-5.4 | medium | workspace-write | - |
| cpp-reviewer | Review | gpt-5.4 | medium | read-only | - |
| csharp-reviewer | Review | gpt-5.4 | medium | read-only | - |
| dart-build-resolver | Execution | gpt-5.4 | medium | workspace-write | - |
| database-reviewer | Review | gpt-5.4 | medium | read-only | - |
| doc-updater | Execution | gpt-5.4-mini | medium | workspace-write | - |
| docs-lookup | Research | gpt-5.4 | medium | read-only | MCP-dependent |
| e2e-runner | Execution | gpt-5.4 | medium | workspace-write | - |
| flutter-reviewer | Review | gpt-5.4 | medium | read-only | - |
| gan-evaluator | Research | gpt-5.4 | high | read-only | - |
| gan-generator | Execution | gpt-5.4 | high | workspace-write | - |
| gan-planner | Planning | gpt-5.4 | high | read-only | - |
| go-build-resolver | Execution | gpt-5.4 | medium | workspace-write | - |
| go-reviewer | Review | gpt-5.4 | medium | read-only | - |
| harness-optimizer | Execution | gpt-5.4 | medium | workspace-write | - |
| healthcare-reviewer | Review | gpt-5.4 | high | read-only | - |
| java-build-resolver | Execution | gpt-5.4 | medium | workspace-write | - |
| java-reviewer | Review | gpt-5.4 | medium | read-only | - |
| kotlin-build-resolver | Execution | gpt-5.4 | medium | workspace-write | - |
| kotlin-reviewer | Review | gpt-5.4 | medium | read-only | - |
| loop-operator | Execution | gpt-5.4 | medium | workspace-write | - |
| opensource-forker | Execution | gpt-5.4 | medium | workspace-write | - |
| opensource-packager | Execution | gpt-5.4 | medium | workspace-write | - |
| opensource-sanitizer | General | gpt-5.4 | medium | workspace-write | - |
| performance-optimizer | Execution | gpt-5.4 | medium | workspace-write | - |
| planner | Planning | gpt-5.4 | high | read-only | - |
| pr-test-analyzer | Research | gpt-5.4 | medium | read-only | - |
| python-reviewer | Review | gpt-5.4 | medium | read-only | - |
| pytorch-build-resolver | Execution | gpt-5.4 | medium | workspace-write | - |
| refactor-cleaner | Execution | gpt-5.4 | medium | workspace-write | - |
| rust-build-resolver | Execution | gpt-5.4 | medium | workspace-write | - |
| rust-reviewer | Review | gpt-5.4 | medium | read-only | - |
| security-reviewer | Review | gpt-5.4 | medium | read-only | - |
| seo-specialist | General | gpt-5.4 | medium | read-only | web-search dependent |
| silent-failure-hunter | Research | gpt-5.4 | medium | read-only | - |
| tdd-guide | Planning | gpt-5.4 | medium | workspace-write | - |
| type-design-analyzer | Research | gpt-5.4 | medium | read-only | - |
| typescript-reviewer | Review | gpt-5.4 | medium | read-only | - |

## Suggested Starters

- `planner`, `architect`, `code-reviewer`, `docs-lookup` are the safest day-to-day starting set.
- `build-error-resolver`, `refactor-cleaner`, `doc-updater`, `e2e-runner`, and language-specific `*-build-resolver` roles are execution-oriented.
- `docs-lookup` expects a docs MCP if available; otherwise it should fall back explicitly.
- `seo-specialist` expects web search capability when used for current-web tasks.

