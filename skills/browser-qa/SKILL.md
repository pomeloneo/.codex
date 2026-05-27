---
name: browser-qa
description: Use this skill to automate visual testing and UI interaction verification using browser automation after deploying features.
origin: ECC
---

# Browser QA — Automated Visual Testing & Interaction

## When to Use

- After deploying a feature to staging/preview
- When you need to verify UI behavior across pages
- Before shipping — confirm layouts, forms, interactions actually work
- When reviewing PRs that touch frontend code
- Accessibility audits and responsive testing

## How It Works

Uses Codex Browser/Chrome automation, Playwright, Puppeteer, or an equivalent browser MCP to interact with live pages like a real user.

## Local App Reconnaissance

For local web apps, first make sure the app is actually running and hydrated:

1. If the server is not running, use the project dev command, Playwright `webServer`, or `~/.codex/skills/e2e-testing/scripts/with_server.py`
2. Navigate to the URL and wait for the rendered app, not just the initial HTML
3. Capture screenshot, console errors, network failures, and rendered DOM before deciding selectors
4. Execute actions only after selectors are confirmed from the rendered state

This avoids false QA failures caused by inspecting a pre-hydration DOM or a server that was never ready.

### Phase 1: Smoke Test
```
1. Navigate to target URL
2. Check for console errors (filter noise: analytics, third-party)
3. Verify no 4xx/5xx in network requests
4. Screenshot above-the-fold on desktop + mobile viewport
5. Check Core Web Vitals: LCP < 2.5s, CLS < 0.1, INP < 200ms
```

### Phase 2: Interaction Test
```
1. Click every nav link — verify no dead links
2. Submit forms with valid data — verify success state
3. Submit forms with invalid data — verify error state
4. Test auth flow: login → protected page → logout
5. Test critical user journeys (checkout, onboarding, search)
```

### Phase 3: Visual Regression
```
1. Screenshot key pages at 3 breakpoints (375px, 768px, 1440px)
2. Compare against baseline screenshots (if stored)
3. Flag layout shifts > 5px, missing elements, overflow
4. Check dark mode if applicable
```

### Phase 4: Accessibility
```
1. Run axe-core or equivalent on each page
2. Flag WCAG AA violations (contrast, labels, focus order)
3. Verify keyboard navigation works end-to-end
4. Check screen reader landmarks
```

## Output Format

```markdown
## QA Report — [URL] — [timestamp]

### Smoke Test
- Console errors: 0 critical, 2 warnings (analytics noise)
- Network: all 200/304, no failures
- Core Web Vitals: LCP 1.2s ✓, CLS 0.02 ✓, INP 89ms ✓

### Interactions
- [✓] Nav links: 12/12 working
- [✗] Contact form: missing error state for invalid email
- [✓] Auth flow: login/logout working

### Visual
- [✗] Hero section overflows on 375px viewport
- [✓] Dark mode: all pages consistent

### Accessibility
- 2 AA violations: missing alt text on hero image, low contrast on footer links

### Verdict: SHIP WITH FIXES (2 issues, 0 blockers)
```

## Integration

Works with any browser automation surface:
- Codex Browser plugin or Chrome connector tools (preferred when available — uses a real browser session)
- Playwright via an MCP such as Browserbase
- Direct Playwright or Puppeteer scripts

Pair with `/canary-watch` for post-deploy monitoring.
