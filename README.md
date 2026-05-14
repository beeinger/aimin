# aimin

Personal AI coding agent rules. One source of truth for cursor, codex, claude code, opencode.

## Install

```bash
curl -sSL https://raw.githubusercontent.com/beeinger/aimin/main/install.sh | bash
```

Clones to `~/.aimin`, links CLI to `~/.local/bin/aimin`, runs setup (symlinks rules to all tools).
Re-running the same command updates to latest.

## CLI

```bash
aimin setup              # Link rules to all tools
aimin teardown           # Remove all global links
aimin update             # Pull latest from github
aimin add ~/Work/myapp   # Add rules to a project
aimin add .              # Add rules to current directory
aimin remove ~/Work/myapp # Remove rules from a project
aimin target add <path>  # Register a custom rules target
aimin target rm <path>   # Unregister a custom rules target
aimin target list        # Show registered targets
aimin status             # Show what's installed where
aimin edit               # Open rules in $EDITOR
aimin path               # Print rules directory
aimin uninstall          # Full removal
```

## What Gets Linked

| Tool | Target |
|------|--------|
| Codex | `~/.codex/AGENTS.md` |
| Claude Code | `~/.claude/CLAUDE.md` |
| OpenCode | `~/.config/opencode/AGENTS.md` |
| Cursor | `~/.cursor/rules/*.mdc`, `~/.cursor/skills/*` |

Per-project `aimin add` links `.cursor/rules/`, `.cursor/skills/`, `AGENTS.md`, and `CLAUDE.md` into the project.

## Custom Targets

Register any additional directory that should receive `.mdc` rule symlinks:

```bash
aimin target add ~/.hcursor-profile   # second cursor profile
aimin target add ~/.windsurf          # another IDE
aimin target list                     # show all registered targets
aimin target rm ~/.windsurf           # remove one
```

Custom targets are stored in `~/.aimin/targets` and automatically included in `setup`, `teardown`, and `status`.

## Structure

```
AGENTS.md        Universal base (codex, opencode, cursor fallback)
CLAUDE.md        @AGENTS.md bridge (claude code)
rules/
  core.mdc       Always-on: voice, quality, git, execution
  typescript.mdc TS/Bun patterns (glob: *.ts, *.tsx)
  solidity.mdc   Foundry/contracts (glob: *.sol)
  infra.mdc      Docker/k8s/CI/secrets (glob: Dockerfile, *.yaml)
  docs.mdc       Documentation standards (glob: *.md)
  workflow.mdc   Task scoping, delegation, verification
skills/
  deslop/        Deep repo audit — find slop, kill slop, ship plan
bin/
  aimin          CLI entrypoint
```

## Update

```bash
aimin update   # pulls latest + re-runs setup
```

## Uninstall

```bash
aimin uninstall
```

Tears down all links, removes CLI, deletes `~/.aimin`.

## Credits

- [mattpocock/skills](https://github.com/mattpocock/skills) — modular, deep-module skills architecture that inspired the per-domain `.mdc` rule structure.
- [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) — caveman voice standard for token-efficient, substance-first AI communication.
- [Cursor](https://cursor.com) — `.mdc` rule format and glob-activated rule activation.
- [Anthropic](https://anthropic.com) — `AGENTS.md` universal standard adopted by Claude Code and the broader ecosystem.

## License

MIT
