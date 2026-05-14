# Plan Template

Output format for `deslop.plan.md`. Caveman voice. Dense.

```markdown
# De-Slop Plan

Generated: [date]
Repo: [name]
Type: [backend/frontend/fullstack/library/monorepo/other]
Stack: [languages, frameworks, DB, key deps]

## Summary

[2-3 sentences. What state repo is in. Biggest problems. Overall assessment.]

## Critical [N items]

Items that break things, expose secrets, or block CI. Fix first.

### C1. [Short title]
**Severity**: critical
**Where**: `path/to/file.ts:L42`
**Problem**: [what's wrong]
**Fix**: [what to do]

### C2. ...

## Architecture [N items]

Structural changes. Schema. Service boundaries. Patterns that need rethinking.

### A1. [Short title]
**Severity**: major
**Where**: `path/to/file.ts:L42` + `other/file.ts:L10`
**Problem**: [what's wrong, why current approach bad]
**Fix**: [concrete change — not "consider improving"]
**Impact**: [what gets better]

### A2. ...

## Quality [N items]

Code-level. Depth. Abstractions. DRY. Type safety.

### Q1. [Short title]
**Severity**: major|minor
**Where**: `path/to/file.ts:L42`
**Problem**: [what's wrong]
**Fix**: [what to do]

### Q2. ...

## Cleanup [N items]

Dead code. Unused deps. Stale config. Formatting.

### CL1. [Short title]
**Where**: `path/to/file.ts:L42`
**Action**: [delete/remove/rename/move]

### CL2. ...

## Nice-to-Have [N items]

Improvements that add value. Not slop — just opportunities.

### N1. [Short title]
**Where**: `path/to/file.ts:L42`
**Suggestion**: [what and why]

### N2. ...

## Execution Order

Recommended order respecting dependencies:

1. [C items first — unblock CI, fix security]
2. [A items — structural changes before code-level]
3. [Q items — code quality with stable structure]
4. [CL items — cleanup after changes stabilize]
5. [N items — nice-to-have last]

Notes on grouping: [items that should be done together, items that conflict]
```
