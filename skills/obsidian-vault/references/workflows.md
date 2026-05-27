# Obsidian Workflows

Use these workflows to turn AI-agent work into durable Obsidian notes.

## Repository Or Project Exploration

Use when the user is exploring a new code repository, system, service, product area, or technical project with repeated agent Q&A.

Default note:

`项目分析/<项目名> 项目探索.md`

Process:

1. Identify the project name from the repo directory, service name, or user's wording.
2. Search for existing notes:
   - `项目分析/<项目名>*`
   - `personal/项目分析/<项目名>*`
   - content mentions of the project name
3. If a relevant note exists, update it. If not, create the default note.
4. During exploration, capture only durable findings:
   - key Q&A
   - architecture facts
   - business/domain concepts
   - code entry points and important files
   - data flow, control flow, dependencies
   - confirmed decisions
   - assumptions and open questions
5. Keep raw chat out of the note unless the user explicitly asks for transcript preservation.
6. Link related notes with `[[wikilinks]]` when they already exist or are likely to become durable concepts.

Good capture unit:

- Question
- Short answer
- Evidence/source
- Implication
- Open follow-up

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
5. Add a `关键问答` section for questions that changed understanding.
6. Add `后续问题` for unresolved or high-value follow-ups.

Do not search `lesson/` unless the user explicitly says to use course or learning materials.

## Live Conversation Capture

Use when the user says they want to record useful information into Obsidian while continuing to talk with the agent.

Process:

1. Establish or create the target note.
2. Keep a running `关键问答` section.
3. Append durable facts under the relevant conceptual section instead of appending chronological chat.
4. Mark uncertain claims as assumptions.
5. At milestones, compact the note:
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
2. Search existing notes in `知识沉淀/`, `项目分析/`, `业务学习/`, `daily_record/`, and `personal/` for that topic.
3. Update an existing note if the new knowledge belongs there.
4. Otherwise create `知识沉淀/<主题>.md`.
5. Capture the reusable insight, not the whole conversation.
6. Include evidence, examples, and "when to use" guidance when helpful.
7. Link related notes if they already exist.

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

- Include: `项目分析/`, `业务学习/`, `知识沉淀/`, `daily_record/`, `personal/`
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
- Do not move legacy notes from `personal/项目分析/` unless explicitly asked.
- Prefer small index/MOC notes over duplicating content.
- When renaming or moving notes, update wikilinks and report changed files.
