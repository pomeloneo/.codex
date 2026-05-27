---
name: agentic-engineering
description: Operate as an agentic engineer using eval-first execution, decomposition, and cost-aware execution routing.
origin: ECC
---

# Agentic Engineering

Use this skill for engineering workflows where AI agents perform most implementation work and humans enforce quality and risk controls.

## Operating Principles

1. Define completion criteria before execution.
2. Decompose work into agent-sized units.
3. Route execution effort by task complexity.
4. Measure with evals and regression checks.

## Eval-First Loop

1. Define capability eval and regression eval.
2. Run baseline and capture failure signatures.
3. Execute implementation.
4. Re-run evals and compare deltas.

## Task Decomposition

Apply the 15-minute unit rule:
- each unit should be independently verifiable
- each unit should have a single dominant risk
- each unit should expose a clear done condition

## Execution Routing

- Low-effort direct work: classification, boilerplate transforms, narrow edits
- Standard Codex work: implementation, refactors, focused debugging
- High-reasoning or multi-agent work: architecture, root-cause analysis, multi-file invariants, independent validation

## Session Strategy

- Continue session for closely-coupled units.
- Start fresh session after major phase transitions.
- Compact after milestone completion, not during active debugging.

## Review Focus for AI-Generated Code

Prioritize:
- invariants and edge cases
- error boundaries
- security and auth assumptions
- hidden coupling and rollout risk

Do not waste review cycles on style-only disagreements when automated format/lint already enforce style.

## Cost Discipline

Track per task:
- execution mode
- token estimate
- retries
- wall-clock time
- success/failure

Escalate effort only when the current mode fails with a clear reasoning gap or validation gap.
