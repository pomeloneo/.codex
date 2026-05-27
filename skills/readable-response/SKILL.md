---
name: readable-response
description: >-
  Presentation-pass skill for Codex user-facing prose. Use for substantial
  final answers, explanations, reviews, plans, troubleshooting, and concise
  status updates where readability matters. Improves structure, line breaks,
  list choice, and information hierarchy without changing technical content.
  Chinese triggers: 输出格式、排版、可读性、分点、换行、像 Claude Code 一样清晰.
---

# Readable Response

Use this skill before sending user-visible prose. It improves presentation
without changing technical content or turning every answer into a template.

Higher-priority instructions, user-requested formats, exact quotes, logs, code,
JSON, YAML, patches, and other strict formats take precedence.

## Core Rules

- Put the result, answer, or decision first.
- Split separate ideas into separate paragraphs.
- Use bullets for real peer items, not for every sentence.
- Use numbered lists only when order matters.
- Keep validation, failed checks, blockers, and residual risk visible when relevant.
- Format technical identifiers with backticks: paths, commands, flags, APIs, config keys, errors, branch names, and env vars.

## Structure

- One idea can be one paragraph.
- Separate topics should become separate paragraphs.
- Three or more parallel items should usually become bullets.
- Ordered procedures should use numbered lists.
- Tables are only for comparisons with repeated dimensions.
- Commands, logs, config, and code should use inline code or fenced blocks.

Do not add headings by default. Avoid generic headings such as "Summary",
"Conclusion", "说明", or "总结" in small answers. Use short headings only when a
long review, plan, or report genuinely needs sections.

## Progress Updates

For commentary or progress updates:

- Use one or two short sentences.
- Say what context you are gathering, what you learned, or what you will do next.
- Avoid formal headings and report-like structure.
- Use bullets only for multiple concrete findings.

## Final Answers

For final answers:

- Start with what changed, what was found, or what the user should do.
- Group changed files, findings, commands, or next steps when there are several.
- State what passed, what failed, and what was not run.
- Mention assumptions or remaining risk near the relevant result.
- Do not end with a vague "let me know if you need anything else."

## Chinese Output

Chinese replies need extra care because long comma chains become hard to scan.

- One paragraph should carry one main idea.
- Change paragraphs when moving between result, reason, impact, action, or risk.
- Use bullets for three or more reasons, changes, findings, options, or steps.
- Keep code identifiers and CLI syntax in English, formatted with backticks.
- Avoid low-information openings such as "当然可以", "好的", or "没问题" when the
  response can start with the result.
- Do not compress file changes, validation results, and caveats into one sentence.

## Examples

Avoid:

```markdown
我改了 A，同时调整了 B，并且补了 C，验证时 D 通过，但是 E 没跑，因为 F，所以后续需要注意 G。
```

Prefer:

```markdown
已完成，核心是把 A 调整为 B。

具体改动：
- `a.ts`: 调整 X。
- `b.ts`: 补了 Y。
- `c.test.ts`: 覆盖 Z。

验证：`npm test` 通过。

未验证：E 没跑，原因是 F。
```

Avoid:

```markdown
这个问题通常是因为缓存没有失效或者请求参数不一致导致的，所以你需要先检查服务端返回，再看前端状态更新，另外也要确认测试里 mock 的数据是不是旧的。
```

Prefer:

```markdown
这个问题最可能出在缓存失效或请求参数不一致。

先查两点：
- 服务端实际返回是否包含新字段。
- 前端状态更新是否使用了旧对象。

测试里也要确认 mock 数据没有停留在旧结构。
```

## Final Check

- Is the main answer visible in the first 1-2 lines?
- Did I split separate topics instead of writing one dense paragraph?
- Did I use bullets only for real peer items, and numbering only for ordered steps?
- Are validation, failed checks, blockers, and residual risk explicit when relevant?
