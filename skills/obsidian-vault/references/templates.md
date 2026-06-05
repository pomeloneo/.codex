# Obsidian Note Templates

Use these templates as starting points. Preserve the style of an existing target note when updating one.

## Canvas Diagram Link

Use directly below the relevant process, workflow, data-flow, control-flow, lifecycle, journey, or Q&A content.

```markdown
Canvas：[[<relative-vault-path>/<流程名>.canvas|打开 <流程名> Canvas]]
```

## Obsidian-Native Style Blocks

Use these blocks to make substantial notes easier to scan. Do not force every block into every note; choose the ones that match the content.

```markdown
> [!summary] 一句话结论
> 

相关笔记：

- [[ ]]

> [!tip] 阅读路径
> 

> [!warning] 注意
> 

> [!quote]- 代码证据
> - `<path>:<line>`：
```

For long codebase notes:

- Put the durable conclusion before evidence.
- Prefer short evidence lists over giant tables.
- Use collapsible `[!quote]-` blocks for dense file references.
- Keep tables small; split broad comparisons into sections when they exceed about 8 rows.
- Add a quick index near the end for important entry files.

## Project Exploration

```markdown
---
type: project-exploration
project: <项目名>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---

# <项目名> 项目探索

> [!summary] 一句话结论
> 

仓库：`<path>`

相关笔记：

- 

## 图谱

- 

## 核心结论

> [!abstract] 真实架构
> - 

> [!warning] 注意事项
> - 

## 代码证据地图

### <主题>

> [!quote]- 证据
> - `<path>:<line>`：

## 技术架构

### 模块与边界

- 

### 核心流程

- 

<如本节包含流程、分支、数据流或生命周期，在此处下方插入 `Canvas Diagram Link`；生成实际笔记时删除此占位行。>

### 关键依赖

- 

## 业务架构

- 

## 代码入口

| 入口 | 作用 | 备注 |
|---|---|---|
| `<path>` |  |  |

## 待验证问题

- [ ] 

## 关联笔记

- 
```

## Business Learning Report

```markdown
---
type: business-learning
topic: <业务名>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---

# <业务名> 学习报告

## 一句话理解


## 背景与目标


## 核心概念

| 概念 | 解释 | 备注 |
|---|---|---|
|  |  |  |

## 业务流程

1. 

<如本节包含业务流程、角色交接、分支或用户旅程，在此处下方插入 `Canvas Diagram Link`；生成实际笔记时删除此占位行。>

## 角色与系统

| 角色/系统 | 责任 | 交互对象 |
|---|---|---|
|  |  |  |

## 技术/数据架构


## 关键问答

### Q:

**结论**：

**证据/来源**：

## 风险与边界

- 

## 后续问题

- [ ] 

## 资料来源

- 

## 关联笔记

- 
```

## Key Q&A Block

```markdown
### Q: <问题>

**结论**：<短答案>

**证据**：<文件、链接、命令输出、材料来源>

**影响**：<这件事改变了什么理解或决策>

**待验证**：<不确定点，没有就写“无”>
```

## General Knowledge Note

```markdown
---
type: knowledge-capture
topic: <主题>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---

# <主题>

## 核心结论

- 

## 适用场景

- 

## 关键细节

- 

## 示例

<如果示例描述流程、步骤、分支或生命周期，在对应示例下方插入 `Canvas Diagram Link`；生成实际笔记时删除此占位行。>

## 证据与来源

- 

## 相关问题

- 

## 关联笔记

- 
```

## Personal Context Lookup Summary

```markdown
## 检索结论

- 

## 使用的笔记

- [[Note Title]]

## 推断

- 

## 不确定点

- 
```
