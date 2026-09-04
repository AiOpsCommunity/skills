# Contributing

Each skill is a folder under `skills/` with one `SKILL.md` inside. That folder is the single
source of truth. See [README.md](README.md) for install and full authoring details.

## One-time setup

Run `npm install` once after cloning. It installs the tooling and enables a
local Git hook that checks your commit messages.

## Commit messages

This repo uses [Conventional Commits](https://www.conventionalcommits.org). The
message format decides the next version number, so it matters:

- `feat: ...` — a new skill or capability (minor release)
- `fix: ...` — a correction to an existing skill (patch release)
- `docs: ...`, `chore: ...`, `refactor: ...` — no release on their own
- a `!` after the type or a `BREAKING CHANGE:` footer — major release

Example: `feat(adr): support Nygard format`. The hook (and CI) will reject
anything that doesn't match.

## Adding or editing a skill

- **One skill per pull request.**
- Folder name is **kebab-case** and becomes the `/command`. Keep the frontmatter `name` equal
  to the folder name.
- Edit `skills/<name>/SKILL.md` directly — it is plain markdown. **Never** commit or edit a
  `.skill` zip; those are generated build artifacts.
- Write `description` with the **key use case first**. It is capped at ~1,536 characters in the
  listing and is what Claude matches on to decide when to run the skill.
- Keep the `SKILL.md` body concise (aim under ~500 lines). Move bulky reference material into
  sibling files and link them from `SKILL.md`.
- When you add a skill, also add:
  - a plugin entry in `.claude-plugin/marketplace.json`, and
  - a row in the **Skills** table in `README.md`.

## Do not commit

- `*.skill` files and the `dist/` directory (both git-ignored). Generate them on demand with
  `./scripts/build-skill.sh <name>`.

## Before opening a PR

- `python3 -m json.tool .claude-plugin/marketplace.json` — confirm the catalog is valid JSON.
- Test the skill locally: copy the folder into a project's `.claude/skills/`, then invoke
  `/skill-name` (or ask a matching question) and confirm it triggers. `claude --debug` shows
  frontmatter parse errors.
