# Obsidian Workflows

Use these workflows to turn AI-agent work into durable Obsidian notes.

## Flow-Oriented Content

Use when any Obsidian capture includes process, workflow, decision path, lifecycle, control flow, data flow, user journey, routing, fallback, or multi-step system/business interaction content.

Process:

1. Read `diagram-pairs.md`.
2. Identify the exact note section or Q&A block that describes the flow.
3. Add an inline Mermaid diagram directly below that section or block.
4. Create or update the companion Obsidian Canvas `.canvas` file in the same folder as the target note unless an existing local convention says otherwise.
5. Add a Canvas wikilink immediately below the Mermaid diagram.
6. When editing an existing flow, update the prose, Mermaid, and Canvas together so they stay consistent.

## Project Planning

Use when the user is shaping a user-owned project, product idea, app, tool, PRD, implementation plan, roadmap, architecture proposal, or ongoing project decision record.

Default note:

`项目/<项目名>/<项目名> 项目探索.md`

Process:

1. Identify the project name from the repo directory, service name, or user's wording.
2. Search for existing notes:
   - `项目/<项目名>/*`
   - `项目/<项目名>*`
   - `项目分析/<项目名>*`
   - `personal/项目分析/<项目名>*`
   - content mentions of the project name
3. If a relevant note exists, update it. If not, create the default note under `项目/<项目名>/`.
4. During exploration, capture only durable findings:
   - key Q&A
   - architecture facts
   - business/domain concepts
   - product decisions
   - PRD scope
   - implementation plans
   - code entry points and important files
   - data flow, control flow, dependencies
   - confirmed decisions
   - assumptions and open questions
5. For any implementation plan, business process, data flow, control flow, dependency path, or lifecycle, apply the Flow-Oriented Content workflow.
6. Keep raw chat out of the note unless the user explicitly asks for transcript preservation.
7. Link related notes with `[[wikilinks]]` when they already exist or are likely to become durable concepts.

Good capture unit:

- Question
- Short answer
- Evidence/source
- Implication
- Open follow-up

## Repository Or Codebase Exploration

Use when the user is exploring an existing repository, source tree, service implementation, system internals, or codebase behavior.

Default note:

`代码库/<仓库名> 项目探索.md`

Process:

1. Identify the repository or service name from the working directory, remote URL, or user wording.
2. Search for existing notes:
   - `代码库/<仓库名>*`
   - `项目分析/<仓库名>*`
   - `personal/项目分析/<仓库名>*`
   - content mentions of the repository or service name
3. If a relevant note exists, update it. If not, create the default note under `代码库/`.
4. Capture repository-specific facts: entry points, module boundaries, control flow, data flow, tests, commands, dependencies, risks, and open questions.
5. For control flow, data flow, service interaction, request lifecycle, build pipeline, or dependency chain findings, apply the Flow-Oriented Content workflow.
6. Do not place product planning, PRDs, or implementation roadmaps under `代码库/` unless they are tightly tied to the existing repository.

## Business Or Domain Learning

Use when the user asks the agent to read materials, explain a business/domain, guide their understanding, or produce a final learning report.

Default note:

`业务学习/<业务名> 学习报告.md`

Process:

1. Clarify the business/domain name if it is ambiguous.
2. Gather source material and keep a source list.
3. Build understanding progressively:
   - vocabulary and core concepts
   - roles/stakeholders
   - business process
   - system/data architecture if relevant
   - risks, edge cases, and unresolved questions
4. Write the final report as a standalone note, not as a transcript.
5. For business process, role handoff, customer journey, data path, or operating model content, apply the Flow-Oriented Content workflow.
6. Add a `关键问答` section for questions that changed understanding.
7. Add `后续问题` for unresolved or high-value follow-ups.

Do not search `lesson/` unless the user explicitly says to use course or learning materials.

## Live Conversation Capture

Use when the user says they want to record useful information into Obsidian while continuing to talk with the agent.

Process:

1. Establish or create the target note.
2. Keep a running `关键问答` section.
3. Append durable facts under the relevant conceptual section instead of appending chronological chat.
4. When a captured answer describes a process or flow, apply the Flow-Oriented Content workflow under that answer or the relevant conceptual section.
5. Mark uncertain claims as assumptions.
6. At milestones, compact the note:
   - merge duplicate Q&A
   - move facts into architecture/business sections
   - keep open questions visible

If the user asks "帮我记录一下", capture the current useful context immediately and report the note path.

## General Durable Knowledge Capture

Use when the user wants to keep something useful but it is not clearly a codebase/project exploration, business/domain learning report, or daily note.

Default note:

`知识沉淀/<主题>.md`

Examples:

- troubleshooting lessons
- tool usage notes
- reusable engineering practices
- AI-agent workflow observations
- decision rationale without a single project owner
- personal rules of thumb
- explanations worth reusing later

Process:

1. Infer a short durable topic name from the conversation.
2. Search existing notes in `知识沉淀/`, `项目/`, `代码库/`, `项目分析/`, `业务学习/`, `daily_record/`, and `personal/` for that topic.
3. Update an existing note if the new knowledge belongs there.
4. Otherwise create `知识沉淀/<主题>.md`.
5. Capture the reusable insight, not the whole conversation.
6. Include evidence, examples, and "when to use" guidance when helpful.
7. Apply the Flow-Oriented Content workflow when the reusable knowledge is procedural, sequential, branching, or lifecycle-based.
8. Link related notes if they already exist.

Use this route for prompts like:

- "这个帮我沉淀成笔记"
- "记录到 Obsidian"
- "这个以后可能有用，记一下"
- "把刚才的结论整理成笔记"
- "把这次排障经验留存一下"
- "把这个工具的用法记一下"

## Personal Context Lookup

Use when the user asks Codex to infer preferences, habits, prior decisions, or historical context from their notes.

Default search scope:

- Include: `项目/`, `代码库/`, `项目分析/`, `业务学习/`, `知识沉淀/`, `daily_record/`, `personal/`
- Exclude unless explicit: `lesson/`, `awesome-codex-skills/`, `.obsidian*/`, `.trash/`

Process:

1. Translate the user request into 2-5 search keywords.
2. Search filenames first, then content.
3. Read only the most relevant notes.
4. Answer with:
   - what was found
   - what is inferred
   - which notes were used
   - uncertainty or missing context

Do not overgeneralize from one old note. If evidence is weak, say so.

## Note Organization

Use when the user asks to organize, merge, index, or clean up notes.

Rules:

- Propose a plan before bulk edits.
- Do not move legacy notes from `项目分析/` or `personal/项目分析/` unless explicitly asked.
- Prefer small index/MOC notes over duplicating content.
- When renaming or moving notes, update wikilinks and report changed files.
