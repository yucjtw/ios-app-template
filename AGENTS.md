# Agent Instructions

- `AGENTS.md` is the single source of truth; `CLAUDE.md` and `README.md` are symlinks to it. Edit `AGENTS.md` only and never replace a symlink with a regular file, or the copies will drift apart.
- `.claude/skills/` is a symlink to `.agents/skills/`. Add or edit skills under `.agents/skills/`, so every agent client reads the same skills.
