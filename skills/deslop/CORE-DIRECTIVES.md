# Core Directives

Applied to ALL repos regardless of type. Every finding must cite file:line.

## Simplicity

- **Deletion test everything.** Module deletable without spreading complexity? Pass-through. Flag it.
- Nothing deletable, everything needed = target state. Anything else = slop.
- Overengineering = slop. Abstractions without multiple consumers = premature. Flag.
- God functions / god files > 300 lines → split or justify.
- Wrapper functions that add nothing → inline or delete.
- Config objects with 1 consumer → inline.

## Module Depth

- Shallow modules (interface ≈ implementation complexity) → deepen or merge.
- Pass-through methods / classes → delete, push logic to caller or callee.
- Barrel files re-exporting everything → justify or remove. Often hide circular deps.
- Helper/util dumps → break into domain-specific modules.
- `utils/`, `helpers/`, `common/` god folders → redistribute by domain.

## Code Quality

- Type safety: `any`, untyped catches, implicit `any` returns → flag critical.
- Magic strings/numbers → extract to named constants.
- Hardcoded values that vary by env → move to config/env.
- Copy-paste code (≥3 similar blocks) → extract shared abstraction.
- Inconsistent naming across codebase → flag, pick convention.
- Nested callbacks > 3 levels → refactor.
- Boolean params (unclear at call site) → use options object or named function.
- Long param lists (>4) → group into typed object.
- Mutation of shared state without guards → flag critical.

## Error Handling

- Catchall `catch(e) {}` swallowing errors → flag critical.
- `catch` that logs and re-throws without context → add context or don't catch.
- Missing error handling on async ops → flag.
- Generic 500 responses → proper status codes per error type.
- Unhandled promise rejections → flag critical.
- No graceful shutdown handler → flag major.

## Organization

- Files > 500 lines → split by responsibility.
- Directories with > 20 flat files → group by domain/feature.
- Naming: file name ≠ primary export → rename.
- Index files doing logic (not just re-exporting) → extract logic.
- Circular dependencies → flag critical, propose resolution.
- Import depth > 5 relative levels (`../../../../../`) → restructure.

## Leftovers & Dead Code

- Unused exports → flag, delete.
- Unused imports → flag, delete.
- Commented-out code → flag, delete. Git has history.
- TODO/FIXME/HACK comments → flag each. Assess if still relevant.
- Unused dependencies in package.json/Cargo.toml/etc → flag, remove.
- Old env vars referenced nowhere → flag, remove.
- Unreachable code paths → flag, delete.
- Empty catch blocks, empty functions → flag.
- Stale config files for removed tools → flag, delete.

## CI & Tooling

- No lint command → flag critical. Must exist.
- No typecheck command → flag critical (for typed langs). Must exist.
- No format command → flag major. Should exist.
- Commands exist but fail → flag critical. Must pass.
- No test command → flag major. Should exist.
- Tests exist but don't run → flag critical.
- No `.env.example` when `.env` used → flag.
- Secrets in codebase (API keys, passwords, tokens in source) → flag critical.
- `node_modules/`, `target/`, build artifacts in git → flag, add to .gitignore.
- Inconsistent package manager usage (mix of npm/yarn/pnpm lockfiles) → flag, pick one.

## Dependencies

- Deprecated packages → flag, suggest replacement.
- Packages with known vulnerabilities → flag critical.
- Pinned to ancient versions without reason → flag.
- Duplicate packages (same purpose, different lib) → flag, pick one.
- Heavy deps for trivial use (moment.js for one format call) → flag, suggest lighter alternative.
- Dev deps in production bundle → flag.

## Documentation

- No README → flag major.
- README outdated (references removed features/commands) → flag.
- Misleading comments (code changed, comment didn't) → flag, fix or delete comment.
- JSDoc on private internals but not public API → invert.

## Testing

- Zero tests → flag major.
- Tests exist but test implementation not behavior → flag.
- Flaky tests (timing-dependent, order-dependent) → flag.
- Tests with hardcoded sleep/delays → flag.
- Test files > 500 lines → split.
- No integration/e2e tests for critical paths → flag.
- Mocking internals instead of testing through public interface → flag.
