---
name: architecture-guardrails
description: Frontend architecture guardrails for planning or implementing non-trivial changes in large TypeScript/React/Lynx monorepos, especially projects with dependency injection, staged startup, UI configuration services, contribution/registry extension points, headless core boundaries, or product/platform variants. Use before generating an implementation plan, adding a feature, changing app startup, touching B-end workbench/platform UI, wiring services, or modifying cross-module dependencies.
---

# Architecture Guardrails

Use this skill to make Codex respect an existing frontend architecture before it writes a plan or code. The goal is not generic "clean architecture"; the goal is to fit the local operating model: DI, staged startup, config-driven UI, contribution registries, and headless/platform boundaries.

## When To Activate

Activate for non-trivial frontend work involving:

- new features, modules, pages, panels, services, or cross-package changes
- implementation plans for a large monorepo
- dependency injection, service registration, service consumption, or app context wiring
- startup, preload, boot, lifecycle, mount, hydration, or first-screen performance
- B-end workbench/platform UI: routes, side menus, title bars, drawers, slots, layout, global UI state
- contribution, registry, extension point, plugin, controller, middleware, action point, or config registration
- shared core/domain code that may be reused by web, Lynx, mobile, SSR, or product variants

Do not use this skill for small isolated UI edits unless they touch the above surfaces.

## Required Output In Plans

Before a substantive implementation plan, include an **Architecture Fit** section:

```markdown
Architecture Fit
- Existing mechanism:
- Target layer/module:
- Dependency direction:
- DI/service entry:
- Startup impact:
- UI configuration/contribution path:
- Headless/platform boundary:
- Variant impact:
- Open architecture questions:
```

If any item is irrelevant, say `N/A`. If any item is unclear and affects the design, stop and ask.

## Hard Constraints

### 1. Prefer Existing DI And Service Registries

When a repo already has dependency injection or service registration, treat it as the default integration path.

- Prefer service contracts, service tokens, decorators, `ServiceRegistry`, container context, or local service factories over direct imports of concrete service implementations.
- Register new services at the existing composition/root boundary.
- Inject dependencies into services/controllers/contributions instead of reaching across layers.
- If a direct import is simpler, justify why the dependency is purely local and not architectural.

### 2. Preserve Staged Startup

Do not collapse startup work into one synchronous blob.

- Identify blocking work before first render/first usable UI.
- Push non-critical service warmup, contribution registration, preload, telemetry setup, and optional feature initialization into async/lazy/ready-after stages when the existing architecture supports it.
- Keep startup steps idempotent when they may rerun or update settings.
- In plans, explicitly call out any task that can delay first screen or app ready.

### 3. Use UI Configuration Services For B-End Workbench UI

For B-end platform/workbench UI, prefer config-driven extension over scattered JSX conditionals.

- Route, side menu, title bar, drawer, slot, absolute-position UI, and layout behavior should go through the existing UI configuration service or manager when present.
- Add or modify config registration close to the feature/contribution that owns the UI.
- Do not hard-code product/platform differences into central layout unless the change is a new extension point or a truly global policy.
- Treat middleware/reporting/events in the UI configuration service as first-class architecture surfaces.

### 4. Prefer Contribution/Registry Extension

When a host supports contributions, registries, controllers, middleware, action points, or extension descriptors:

- Implement feature behavior as a contribution or registered extension first.
- Modify the host only to expose a missing extension point, fix lifecycle ordering, or change shared policy.
- Keep contribution registration discoverable and aligned with existing sync/async registration phases.
- Avoid making the host import every feature implementation directly.

### 5. Keep Headless Core Separate From Platform Adapters

Shared core/domain/service code should not know about UI runtimes.

- Keep React, DOM, browser globals, Lynx globals, app bridge APIs, and product-specific UI out of headless core.
- Put platform-specific behavior in adapters, entries, page layers, or variant packages.
- Isolate product/platform differences through variants, configuration, or adapters rather than spreading `if product/platform` checks through core.

## Working Process

1. Search local project guidance first: `AGENTS.md`, `.cursor/rules`, `.trae/rules`, `README.md`, module READMEs, and architecture lint rules.
2. Locate existing mechanisms before proposing new ones: DI tokens, service registries, lifecycle loaders, UI config services, contribution descriptors, registries, managers, and variant packages.
3. Write the **Architecture Fit** section.
4. If the architecture path is clear, continue with the normal implementation plan.
5. If the path is unclear, ask targeted questions before coding.

## Red Flags

- A feature imports a concrete service from a distant package when the repo has service tokens.
- UI layout changes are implemented as central JSX conditionals despite a config service.
- Startup work performs heavy network/init synchronously without identifying first-screen impact.
- A host/workbench imports each business feature directly instead of using contribution registration.
- Shared core imports React, DOM, Lynx, browser APIs, bridge APIs, or product UI.
- Variant logic spreads across common code instead of being localized in adapters/config/variant packages.

## Reference Exemplars

Read `references/pippit-vicut-patterns.md` when you need concrete local examples from:

- `/Users/bytedance/gitlab/pippit`
- `/Users/bytedance/gitlab/vicut-hybrid-monorepo`

These repos are exemplars, not templates to copy blindly. Extract the architecture mechanism, then fit the current repository.
