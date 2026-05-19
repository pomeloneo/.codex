---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# TypeScript/JavaScript Patterns

> This file extends [common/patterns.md](../common/patterns.md) with TypeScript/JavaScript specific content.

## Default Patterns

- Keep API response shapes consistent across a service boundary.
- Prefer small reusable utilities and hooks over ad-hoc repeated logic.
- Encapsulate data access behind a clear repository or service boundary when persistence logic grows.
- Reuse established framework patterns before inventing local abstractions.

## References

- See [common/patterns.md](../common/patterns.md) for the cross-language defaults.
- See skill: `frontend-patterns` for React hooks, forms, rendering, and client-side state patterns.
- See skill: `backend-patterns` for API, repository, and server-side architecture guidance.
