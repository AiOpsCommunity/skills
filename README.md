# AiOps Community skills

A collection of [Claude skills](https://code.claude.com/docs/en/skills). Each skill is a
folder under [`skills/`](skills/) containing a single `SKILL.md` file (YAML frontmatter +
markdown instructions). That folder is the **only** source of truth — there is no separate
binary to keep in sync.

> **About `.skill` files:** a `.skill` file is just a **ZIP** of a skill folder, used to
> upload to claude.ai. It is a build output, not a source file — it is git-ignored and
> generated on demand with [`scripts/build-skill.sh`](scripts/build-skill.sh). Never edit a
> `.skill` file directly; edit the `SKILL.md` in the folder.

## Skills

| Skill | Description |
| :---- | :---------- |
| [`adr`](skills/adr/SKILL.md) | Write, update and supersede Architecture Decision Records (ADRs) in MADR or Nygard format, and keep the decision log consistent over time. |
| [`aiops-community-proposal`](skills/aiops-community-proposal/SKILL.md) | Draft a client proposal on behalf of an individual IT professional responding to an assignment found via the AiOps Community, in a plain, honest, non-salesy house style. |
| [`changelog`](skills/changelog/SKILL.md) | Write and maintain CHANGELOG.md entries and release notes from git history, staged diffs, or a described set of changes, using Keep a Changelog categories and semantic versioning. |

## Install

### Claude Code — plugin marketplace (one command)

```text
/plugin marketplace add AiOpsCommunity/skills
/plugin install aiops-community-proposal@aiops-skills
/reload-plugins
```

Plugin skills are namespaced, so invoke with `/aiops-community-proposal:aiops-community-proposal`
(or the bare `/aiops-community-proposal` if no other skill claims that name). Update later with
`/plugin marketplace update aiops-skills`.

### Claude Code — copy the folder

Clone the repo and copy a skill folder into a skills directory:

```bash
git clone https://github.com/AiOpsCommunity/skills.git
# Personal — available in all your projects:
cp -r skills/aiops-community-proposal ~/.claude/skills/
# or Project — only this repo:
cp -r skills/aiops-community-proposal /path/to/project/.claude/skills/
```

The **directory name becomes the command**, so this gives you `/aiops-community-proposal`.
Claude Code picks up new folders on restart and reflects `SKILL.md` edits live within a session.

### claude.ai — upload a `.skill` file

For claude.ai (Pro/Max/Team/Enterprise with code execution), build the zip and upload it:

```bash
./scripts/build-skill.sh aiops-community-proposal   # -> dist/aiops-community-proposal.skill
```

Then go to **Settings → Skills → Upload skill** on claude.ai and select the generated
`dist/<name>.skill` file.

## Add a new skill

1. Create the folder (kebab-case — the name becomes the `/command`):

   ```bash
   mkdir -p skills/my-new-skill
   ```

2. Create `skills/my-new-skill/SKILL.md` with frontmatter and a body:

   ```markdown
   ---
   name: my-new-skill
   description: What the skill does and, first, when to use it. Claude matches on this.
   ---

   # My new skill

   Instructions Claude follows when the skill runs...
   ```

   - Keep `name` equal to the folder name.
   - Put the **key use case first** in `description`; the listing truncates it at ~1,536
     characters, and that text is what Claude uses to decide when to trigger the skill.
   - Keep the body concise (aim for under ~500 lines). For bulky reference material, add
     sibling files (e.g. `reference.md`, `scripts/`) and link them from `SKILL.md` so they
     load only when needed.

3. Register it so others can install and discover it:
   - Add a plugin entry to [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json)
     (`name`, `source: "./skills/my-new-skill"`, `description`).
   - Add a row to the **Skills** table above.

See [CONTRIBUTING.md](CONTRIBUTING.md) for the short checklist.

## Edit an existing skill

Edit `skills/<name>/SKILL.md` directly — it is plain markdown. **Never** touch a `.skill`
zip; those are generated. If you change a skill's purpose, update its `description` here and in
`marketplace.json` too.

## Test a skill locally

Copy or symlink the folder into a project's `.claude/skills/`, then either invoke it directly
with `/skill-name` or ask a question that matches its `description` and confirm Claude triggers
it. Run `claude --debug` to surface YAML frontmatter parse errors. To sanity-check the plugin
path without publishing, run `/plugin marketplace add ./` from the repo root.

## Repo layout

```
.
├── README.md
├── CONTRIBUTING.md
├── .claude-plugin/
│   └── marketplace.json         # plugin catalog for /plugin install
├── .github/
│   └── workflows/
│       └── pr-checks.yml        # runs validate.sh, shellcheck and claude plugin validate
├── scripts/
│   ├── build-skill.sh           # folder -> dist/<name>.skill (for claude.ai upload)
│   └── validate.sh              # structure: registration, frontmatter, links
└── skills/
    └── <skill-name>/
        └── SKILL.md             # the skill (single source of truth)
```
