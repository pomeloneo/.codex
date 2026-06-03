# Obsidian Canvas Diagrams

Use this reference whenever Obsidian note content describes a process-like structure.

## Trigger

Create or update a Canvas diagram when the target note includes any of these:

- Process, workflow, operating procedure, implementation plan, or business flow
- Decision tree, branching path, routing logic, fallback path, or escalation flow
- Control flow, data flow, request flow, event flow, dependency chain, or pipeline
- Entity lifecycle, state transition, user journey, handoff, or multi-actor interaction

Do not wait for the user to explicitly ask for a diagram. If the `obsidian-vault` skill is being used and the durable content is flow-oriented, a Canvas diagram is part of the capture.

For this skill, Canvas is the only diagram format to add. If an existing redundant text diagram block only duplicates the process visualization, replace it with the Canvas link when editing that section. Preserve unrelated legacy diagram blocks unless the user asks to rewrite them.

## Required Output

For each important flow-oriented section:

1. Create or update a linked Obsidian Canvas `.canvas` file.
2. Add a Canvas wikilink in the Markdown note.

The Canvas file is the visual representation. The Markdown note keeps the explanation, evidence, caveats, and the link to open the visual canvas.

## Placement

Place the Canvas link directly below the content it explains:

- Under `核心流程`, `业务流程`, `数据流`, `控制流`, `生命周期`, or similar headings.
- Under the exact Q&A block when the answer describes a flow.
- Under the relevant paragraph/list/table if the note has no dedicated flow heading.

Do not put all Canvas links in a generic appendix unless the user asks for an appendix.

Use this note block shape:

```markdown
Canvas：[[<relative-vault-path>/<流程名>.canvas|打开 <流程名> Canvas]]
```

If the surrounding note uses English headings or link labels, match that style.

## Canvas File Rules

Create the Canvas file in the same folder as the target note by default. If that folder already has a local Canvas convention, follow it.

Before creating a new Canvas file, search for an existing related one:

```bash
rg --files "/Users/bytedance/Documents/Obsidian Vault" -g '*.canvas' -g '!**/.obsidian*/**' -g '!**/.trash/**' | rg -i "<keyword>"
```

Naming:

- One note-level flow: `<Note Title> Canvas.canvas`
- Section-level flow: `<Note Title> - <Section Title> Canvas.canvas`
- If an existing related `.canvas` file already covers the same flow, update it instead of creating a duplicate.

Link from the note with a vault-relative wikilink:

```markdown
Canvas：[[项目/<项目名>/<Note Title> - <Section Title> Canvas.canvas|打开 <Section Title> Canvas]]
```

Canvas JSON requirements:

- Use valid JSON only. No comments, trailing commas, Markdown fences, or YAML frontmatter inside `.canvas`.
- Use text nodes by default. Use file nodes only when pointing to existing notes or attachments that improve navigation.
- Use stable lower_snake_case node IDs.
- Keep coordinates integer-based and readable: left-to-right for sequences, top-to-bottom for staged processes, branches above/below the main path.
- Use `color` sparingly for semantics: same color means same type of node in one canvas.

Minimal Canvas shape:

```json
{
  "nodes": [
    {
      "id": "start",
      "type": "text",
      "text": "开始\n\n触发条件或输入",
      "x": 0,
      "y": 0,
      "width": 300,
      "height": 140,
      "color": "4"
    },
    {
      "id": "process",
      "type": "text",
      "text": "关键处理\n\n保留字段、来源或判断条件",
      "x": 420,
      "y": 0,
      "width": 340,
      "height": 160,
      "color": "2"
    }
  ],
  "edges": [
    {
      "id": "start_to_process",
      "fromNode": "start",
      "fromSide": "right",
      "toNode": "process",
      "toSide": "left"
    }
  ],
  "metadata": {
    "version": "1.0-1.0",
    "frontmatter": {}
  }
}
```

## Update Rules

- Update the prose and Canvas together. Never leave the Canvas stale when changing the flow explanation.
- If a note already has a correct Canvas link, update the existing Canvas instead of creating another file.
- If a note has flow prose but no Canvas link, add the Canvas file and link below the relevant section.
- If the flow is too large, create one overview Canvas at the main section and one detail Canvas under the most important branch. Link the detail Canvas from the overview section.
- Report both changed files: the Markdown note and each `.canvas` companion.
