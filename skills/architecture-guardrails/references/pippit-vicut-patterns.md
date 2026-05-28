# Pippit And Vicut Architecture Patterns

This reference captures architecture mechanisms from two local exemplar repos. Use it to recognize patterns, not to force identical code structure onto other projects.

## Pippit: B-End Workbench Architecture

Repo: `/Users/bytedance/gitlab/pippit`

Useful files:

- `README.md`: explains the broad layering: `bedrock`, `services`, `core`, `render`, `editor`, `workbench`.
- `packages/services/workbench-service/src/loader/workbench-loader.ts`: staged workbench boot.
- `packages/services/workbench-service/src/loader/workbench-lifecycle.ts`: lifecycle hook names.
- `packages/services/workbench-service/src/loader/start-up-service.interface.ts`: startup service contract.
- `packages/services/workbench-service/src/workbench-service.tsx`: workbench service and contribution registration.
- `packages/services/workbench-service/src/registries/*.ts`: controller, middleware, action point, pre-handler registries.
- `packages/services/ui-configuration-service/*`: config-driven platform/workbench UI.
- `packages/entry/graphic/src/task/register-*-contribution-*.ts`: sync/async contribution registration.
- `packages/ag-ui-kit/.eslintrc.architecture.js`: physical dependency direction enforcement.
- `packages/scene-template-sdk/.eslintrc.architecture.js`: headless core vs host-specific entries.

### Mechanism: DI And Service Contracts

Pippit uses `@byted-image/lv-bedrock/di` and local DI wrappers. Typical signals:

- `createDecorator<T>('service-name')` for service contracts.
- `@Inject(...)` or `@IInstantiationService` in constructors.
- `ServiceRegistry`, `SyncDescriptor`, `InstantiationContext`, `useService`, `getService`.
- service implementation registered near entry/startup/composition code.

Guardrail:

- Do not add a distant direct import of a concrete service when a token or registry path exists.
- New service-like behavior should have a contract and be wired at the composition boundary.

### Mechanism: Staged Workbench Startup

The Workbench loader follows a staged sequence:

1. lifecycle `$onInit`
2. init registered services
3. init middlewares
4. lifecycle `$onMount`
5. mount workbench shell/controllers
6. lifecycle `$afterControllersInit`
7. async attach/render
8. lifecycle `$onReady`

Guardrail:

- In plans that touch startup, classify tasks as blocking init, mount-time, attach-time, ready-after, or lazy/async.
- Contribution registration can be sync or async. Preserve the existing split instead of making every feature eager.

### Mechanism: B-End UI Configuration Service

`ui-configuration-service` provides config-driven managers for routes, side menus, title bars, slots, drawers, block content, and variant-specific platform UI.

Typical signals:

- interface method `registerConfig(configs: Partial<IUiMixinConfig>)`
- manager methods such as `PageRouteManager.registerConfig`, `SideMenuManager.registerConfig`, `TitleBarManager.registerConfig`
- platform variants: `platform`, `platform-mobile`, `dreamina`, `ai-workflow`, `canvas-editor`, `ai-creator`, `smart-tools`

Guardrail:

- For B-end platform/workbench UI, add route/menu/titlebar/slot behavior through the config service before editing central layout.
- Product/platform-specific UI belongs in the relevant variant/config layer.

### Mechanism: Contribution And Registry Mode

Workbench/editor features commonly enter through contribution descriptors and registries:

- `IContributionDescriptor`
- `InstantiationPhase`
- `workbenchService.registerContribution(...)`
- `extensionService.register(code.contribution)`
- `ControllerRegistry`, `MiddlewareRegistry`, `ActionPointRegistry`

Guardrail:

- New feature behavior should be contributed to the host.
- Host changes are appropriate when adding a new extension point, changing ordering, or enforcing shared lifecycle/policy.

### Mechanism: Physical Layers Enforce Soft Rules

Pippit's architecture lint files encode dependency direction. Examples:

- shared/base/core should not import upper UI/business layers.
- service/core packages should stay headless where intended.
- host-specific web/Lynx/browser entries depend on core, not the reverse.

Guardrail:

- Treat physical layering as enforcement for the soft architecture, not as the whole design.

## Vicut: C-End/Lynx Lightweight Architecture

Repo: `/Users/bytedance/gitlab/vicut-hybrid-monorepo`

Useful files:

- `README.md`: apps/libs/packages split and `emo` workflow.
- `.trae/rules/project_rules.md`: rule routing for Lynx, responsive layout, lifecycle, ReactLynx, components, data service.
- `.trae/rules/react_lynx.md`: ReactLynx coding constraints.
- `.trae/rules/responsive_layout.md`: responsive layout constraints.
- `packages/p2i-core/README.md`: UI-independent service layer and DI-lite model.
- `packages/p2i-core/src/srv/index.ts`: `Srv` service accessor/proxy pattern.
- `packages/p2i-omni/src/index.ts`: variant package that injects service dependencies.
- `apps/videocut-lynx/src/pages/commerce/pages/credits_center/lifecycle/container_service.ts`: local page-level DI container.

### Mechanism: Headless Core With Variants

`p2i-core` is the common state/logic layer. Variant packages such as `p2i-omni` extend or inject differences.

Guardrail:

- Keep scenario-independent state and logic in core.
- Put omni/dreamina/app differences in variant packages or app entries.
- Avoid making common core depend on Lynx page details.

### Mechanism: DI-Lite And Local Containers

Vicut may use lighter patterns than Pippit:

- `Srv` singleton/proxy service accessor in `p2i-core`.
- page-level `ServiceRegistry` and `InstantiationService` for local modules such as credits center.
- services under app pages for local business/page concerns.

Guardrail:

- Match the local degree of ceremony. Do not force full Pippit-style DI into a lightweight area, but still preserve the local service boundary.

### Mechanism: Startup, Preload, And Runtime Constraints

Lynx/C-end pages often care about preload, eventbus lifecycle, page visibility, cache reads, and first-screen timings.

Guardrail:

- Classify preload and service warmup separately from render-critical work.
- Follow `.trae/rules` for Lynx/ReactLynx/runtime constraints before applying generic React patterns.

## How To Transfer These Patterns

- If the target repo already has one of these mechanisms, prefer its local implementation.
- If the target repo lacks the mechanism, do not introduce it just because pippit/vicut has it. First ask whether the added architecture weight is justified.
- Prefer "smallest architecture-compatible change" over "big architecture transplant."
