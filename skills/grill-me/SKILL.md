---
name: grill-me
description: Proactively interview the user to align on ambiguous, creative, exploratory, strategic, or planning-heavy work before producing an answer. Use when the user asks to brainstorm, design, plan, write a proposal/PRD/roadmap/strategy, choose between trade-offs, shape an idea, or mentions "grill me", "grillme", stress-test, challenge, align, discuss, or ask me questions. Do not use for routine well-specified execution.
---

# Grill Me

Use this skill to turn an under-specified request into a shared understanding before committing to a plan, design, or creative direction.

## Trigger Heuristics

Use proactively when the work is open-ended and alignment quality matters:

- Creative direction: naming, positioning, content angle, UI/UX direction, product ideas.
- Exploratory work: "think through", "explore", "brainstorm", "what are the options", "help me figure out".
- Planning work: roadmap, PRD, implementation plan, architecture, migration plan, research plan, strategy.
- Decision work: multiple plausible trade-offs, irreversible or expensive choices, fuzzy success criteria.
- Collaboration cues: user wants discussion, pushback, challenge, stress testing, alignment, or mentions "grill me" / "grillme".

Do not use when the user gave a narrow, executable request with enough constraints, explicitly asked not to be questioned, or the fastest useful response is a direct command or small edit.

## Process

Interview the user about the plan, design, or idea until we reach shared understanding. Walk down the decision tree one dependency at a time.

Ask one question at a time. Each question must include:

1. The question.
2. Why the answer changes the plan.
3. Your recommended answer or default assumption.

If a question can be answered by exploring the codebase, documents, or provided context, explore first instead of asking.

Start with the highest-leverage ambiguity. Prefer questions about goal, audience/user, success criteria, constraints, non-goals, risk tolerance, and decision ownership before asking about details.

## Intensity

- Light grill: ask 1-2 high-leverage questions when ambiguity is moderate.
- Deep grill: continue one question at a time when the request is high-impact, exploratory, creative, strategic, or planning-heavy.
- Stop grilling when the remaining ambiguity no longer changes the recommended direction. Then summarize the aligned decisions, unresolved assumptions, and the next concrete output.
