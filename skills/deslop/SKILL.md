---
name: deslop
description: >-
  Ruthless repo audit. Find slop, kill slop, ship plan.
  Trigger: /deslop, "deslop this", "clean up this repo",
  "de-slop", "audit codebase", quality/architecture overhaul.
disable-model-invocation: true
---

# De-Slop

Ruthless repo audit. Find slop. Kill slop. Ship plan.

Output = `deslop.plan.md`. Actionable, ordered, dense.

VOICE: ALWAYS CAVEMAN. Plan output = caveman. Subagent prompts = caveman. Everything = caveman.

## Glossary

- **Slop** — AI-generated or lazy code lacking intent, depth, cleanup.
- **Depth** — lots of behavior behind small interface. Deep = good. Shallow = slop.
- **Deletion test** — delete module mentally. Complexity vanishes? Pass-through. Reappears across N callers? Earning keep.
- **Simplicity** — nothing deletable, everything needed. Best code + architecture.

## Phase 0 — Intake

Ask user ONE question:

> Context? What repo does, goals, special requirements?
> Skip = fine. Provide = better plan.

User provides → store as `USER_CONTEXT`. Proceed.
User skips → `USER_CONTEXT = null`. Proceed.

## Phase 1 — Recon

Launch explore subagent (thoroughness: "very thorough"):

Map repo completely. Return:
- Repo type (backend/frontend/fullstack/library/monorepo/other)
- Languages, frameworks, major deps
- Directory structure (annotated)
- Entry points, main flows
- Config inventory (CI, lint, format, typecheck, docker, infra)
- DB presence + type
- Test presence + framework
- Build system, package manager
- Existing docs
- If `USER_CONTEXT`: validate against reality, note discrepancies

Store as `REPO_PROFILE`.

## Phase 2 — Deep Analysis

Determine repo type from `REPO_PROFILE`.

**Before subagents**: Read directive files for repo type.
- Always read [CORE-DIRECTIVES.md](CORE-DIRECTIVES.md)
- Backend → read [BACKEND-DIRECTIVES.md](BACKEND-DIRECTIVES.md)
- Frontend → read [FRONTEND-DIRECTIVES.md](FRONTEND-DIRECTIVES.md)

Include directive content + `REPO_PROFILE` summary + relevant `USER_CONTEXT` in each subagent prompt. Subagents can't load skill files.

Launch ALL applicable subagents in parallel (single message, multiple Task calls).

### Always launch:

**Subagent A — Structure & Organization** (explore, very thorough)
```
Repo context: <REPO_PROFILE summary>
Directives: <CORE_DIRECTIVES: Organization, Leftovers & Dead Code>
Check: file org, naming, module boundaries, dead code, unused imports,
leftover files, stale config, duplication, copy-paste.
Return: numbered findings with file:line citations.
Collect: questions needing user context.
```

**Subagent B — Code Quality** (explore, very thorough)
```
Repo context: <REPO_PROFILE summary>
Directives: <CORE_DIRECTIVES: Simplicity, Module Depth, Code Quality, Error Handling>
Check: module depth (shallow wrappers, pass-throughs, god fns),
abstractions, composability, error handling, type safety,
any/unknown abuse, magic strings/numbers, hardcoded values.
Return: findings with file:line, severity (critical/major/minor).
Collect: questions needing user input.
```

**Subagent C — CI & Tooling** (generalPurpose)
```
Repo context: <REPO_PROFILE summary>
Run each: lint, typecheck, format, test. Report pass/fail.
Check: deprecated deps, security vulns, env var hygiene,
Dockerfile quality (if present).
Return: pass/fail per check, findings, blockers.
```

**Subagent F — Security Sweep** (explore, very thorough)
```
Repo context: <REPO_PROFILE summary>
Check: hardcoded secrets, API keys in code, .env committed,
auth quality, input validation, injection vectors,
dependency vulns, exposed debug endpoints, CORS, rate limiting.
Frontend: secrets in public env vars, token storage.
Backend: auth middleware gaps, privilege escalation.
Return: findings with severity (critical/high/medium/low) + citations.
```

### If backend:

**Subagent D — Backend Architecture** (explore, very thorough)
```
Directives: <BACKEND_DIRECTIVES full>
Repo context: <REPO_PROFILE summary>
Analyze: architecture fit, cron/polling patterns, event-driven opportunities,
service boundaries, DB choice, schema quality, API design,
reliability, external dependency handling.
Web3/blockchain: indexing, reorgs, replayability, downtime recovery.
Return: findings with severity + citations.
Collect: architecture questions only user can answer.
```

### If frontend:

**Subagent E — Frontend Architecture** (explore, very thorough)
```
Directives: <FRONTEND_DIRECTIVES full>
Repo context: <REPO_PROFILE summary>
Analyze: component architecture, render performance,
security (secret exposure, auth, XSS/CSRF),
bundle concerns, SSR, API patterns, styling, a11y basics.
Return: findings with severity + citations.
Collect: questions needing user input.
```

## Phase 3 — Synthesis

Collect all subagent results. Build plan.

### Plan location
- `.cursor/` exists → `.cursor/plans/deslop.plan.md`
- Other tool plan convention → use it
- Fallback → `deslop.plan.md` at repo root

### Plan structure

Use [PLAN-TEMPLATE.md](PLAN-TEMPLATE.md). Populate:

1. **Repo Profile** — condensed from Phase 1
2. **Critical** — broken things, security holes, CI failures
3. **Architecture** — structural changes, schema, boundaries
4. **Quality** — code-level: depth, abstractions, DRY
5. **Cleanup** — dead code, unused deps, stale config
6. **Nice-to-have** — value-add, not slop

Each item: what's wrong, where (file:line), why it matters, fix.
Ordered by impact within section.

**Save plan immediately.** Don't wait for questions.

## Phase 4 — Questions

Collect questions from all subagents. Launch:

**Subagent G — Question Curator** (generalPurpose)
```
Input: all questions + deslop.plan.md content.
Kill: answerable from codebase, preference/style questions,
questions where answer doesn't change plan significantly.
Merge overlapping.
Keep ONLY: changes architecture direction, needs external context,
ambiguity risking wrong direction.
Zero survive = return empty. Don't force questions.
Survive = rank by impact. Max 7. Numbered, concise, with why-it-matters.
```

Questions exist → present to user, wait.
Zero questions → skip to Phase 5.

After answers:
- Minor → update plan inline
- Major → re-launch relevant Phase 2 subagents, rebuild sections

## Phase 5 — Final

Launch sanity-check:

**Subagent H — Plan Auditor** (generalPurpose)
```
Read deslop.plan.md. Audit:
- Every item actionable? (not vague "improve X")
- Every item has file:line citation?
- No contradictions?
- Priority ordering respects deps?
- No duplicates?
- Caveman voice consistent?
- Scope reasonable? Flag items needing split.
- Deletion test each item.
Return: corrections needed, or "clean".
```

Apply corrections. Save final plan. Report:

```
deslop.plan.md saved to [path].
[N] critical, [N] architecture, [N] quality, [N] cleanup items.
```

## Anti-Patterns in Plan Output

- "Consider improving X" → NO. Say what to do.
- "This could be better" → NO. Say what's wrong + fix.
- "Best practices suggest" → NO. Specific problem, specific fix.
- Vague severity → NO. Every item: critical / major / minor.
- Missing citations → NO. Every item cites file:line.
- Plan longer than needed → NO. Dense. One line = one line.

## Edge Cases

- **Monorepo**: Phase 1 identifies packages. Phase 2 per package. Single unified plan.
- **Empty/starter repo**: Short plan. Focus: CI setup, pattern choices. Don't invent problems.
- **Clean repo**: Say so. "Repo clean, no slop." Don't inflate.
- **User flags big issues**: Re-launch full analysis. Accuracy > speed.
