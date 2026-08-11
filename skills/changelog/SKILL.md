---
name: changelog
description: Write and maintain CHANGELOG.md entries and release notes from git history, staged diffs, or a described set of changes, using Keep a Changelog categories (Added, Changed, Deprecated, Removed, Fixed, Security) and semantic versioning. Use this skill whenever the user mentions a changelog, CHANGELOG.md, release notes, "what changed", cutting or preparing a release, tagging a version, bumping a version, or asks to summarize commits for users - even if they do not say the word "changelog" explicitly.
---

# Changelog

Turn raw changes (commits, diffs, or a description) into changelog entries that a *user* of the software can read, and keep CHANGELOG.md consistent over time.

The core skill is not formatting. It is translation: a commit says what the developer did to the code, a changelog entry says what changed for the person using the software. `fix: null check in CartLineItemLoader` becomes "Fixed a crash when opening an empty cart".

## Workflow

### 1. Determine the scope

Ask only if it is genuinely ambiguous. Otherwise pick the obvious source:

| Situation | Scope to use |
| --- | --- |
| Preparing a release | Commits since the last tag: `git describe --tags --abbrev=0`, then `git log <tag>..HEAD` |
| About to commit | `git diff --cached` |
| User names a range, branch or PR | That range: `git log main..feature-x` |
| User pasted a list of changes | Use what they pasted, do not go looking in git |
| No git repo | Ask what changed, or read the diff they provide |

Useful commands:

```bash
git log <range> --no-merges --pretty=format:'%h %ad %s%n%b' --date=short
git diff <range> --stat
```

Read the diff, not only the subject lines, when a commit message is vague ("wip", "fixes", "update"). A vague message with a 200-line diff is usually several distinct entries.

### 2. Read the existing changelog first

If CHANGELOG.md exists, read the last two or three releases before writing anything, and match what you find:

- The language it is written in. A Dutch changelog gets Dutch entries.
- Heading style, date format, whether entries reference issue or PR numbers.
- Whether it uses an `## [Unreleased]` section.
- Whether it links versions to compare URLs at the bottom.

Consistency with the existing file beats the conventions in this skill. If there is no changelog at all, see "Starting a changelog from scratch" below before writing anything.

### 3. Classify each change

Use the six Keep a Changelog categories. Only include categories that have entries.

| Category | Use for |
| --- | --- |
| **Added** | New features, endpoints, options, settings, commands |
| **Changed** | Changes in existing behaviour, defaults, UI, performance, dependencies that users notice |
| **Deprecated** | Still works, will be removed later. Say what replaces it |
| **Removed** | Gone in this release |
| **Fixed** | Bug fixes |
| **Security** | Vulnerabilities and hardening. Include the CVE or advisory when there is one |

Mapping from conventional commits:

| Commit prefix | Category |
| --- | --- |
| `feat` | Added |
| `fix` | Fixed |
| `perf` | Changed |
| `refactor`, `chore`, `test`, `ci`, `build`, `style` | Usually omit. Include only when a user notices the effect |
| `docs` | Omit, unless the docs are the product |
| `BREAKING CHANGE` / `!` | Changed or Removed, plus a **BREAKING** marker and an upgrade note |

Omitting internal churn is a feature, not laziness. A changelog full of "bump eslint to 9.2" trains people not to read it. If the user wants a complete technical log instead, they will say so.

### 4. Write the entries

Each entry is one line, one change, from the user's perspective:

- Start with a verb in the same tense as the surrounding file. Default: past tense ("Added support for...", "Fixed a crash when...").
- Name the thing the user recognises (the screen, the command, the setting), not the class or file.
- Say what the effect is, not how it was implemented.
- Note what someone must do if a change requires action from them.
- No commit hashes in the body unless the existing file uses them. Issue or PR references at the end (`(#412)`) if the file does that.

**Example 1**
Input: `fix: guard against null customer in OrderConverter`
Output: `- Fixed an error when placing an order as a guest customer.`

**Example 2**
Input: `feat(api): add cursor pagination to /products, closes #212`
Output: `- Added cursor-based pagination to the products endpoint. (#212)`

**Example 3**
Input: `refactor!: drop Node 18 support, require Node 20`
Output: `- **BREAKING** Removed support for Node 18. Upgrade to Node 20 or later before updating.`

**Example 4** (several commits, one user-facing change)
Input: `wip checkout`, `fix tests`, `checkout step 2 done`
Output: `- Added a two-step checkout with an address confirmation screen.`

Never invent an entry to fill a category, and never soften a breaking change. If a diff is unclear, ask instead of guessing. It is better to say "commit a1b2c3d touches the price calculation but I cannot tell what changed for users, what should this entry say?" than to write something plausible and wrong.

### 5. Decide the version

Semantic versioning, based on the highest-impact change in the set:

- **Major** (`2.0.0`): anything breaking, removed, or requiring migration.
- **Minor** (`1.3.0`): new functionality, backwards compatible. Deprecations go here.
- **Patch** (`1.2.4`): fixes and internal changes only.

Propose the version and say why in one line ("minor, because of the two new endpoints and no breaking changes"). Let the user overrule. Pre-1.0 projects and calendar versioning (`2026.08.1`) exist. Follow the file, do not force semver on a project that clearly uses something else.

### 6. Write it to the file

Insert the new section directly under `## [Unreleased]`, above the previous release. Never rewrite or reorder published releases. Keep the existing blank-line rhythm and update the compare links at the bottom if the file has them.

For the exact file skeleton, the release-section template, and the compare-link pattern, read [templates.md](templates.md).

## Starting a changelog from scratch

When there is no CHANGELOG.md, do not silently create one with default conventions. The first file sets the pattern for every future release, and guessing wrong is annoying to undo. Three things need deciding, and most of them you can infer rather than ask.

**Where the file goes.** Repository root, named `CHANGELOG.md` in caps, next to the README. In a monorepo, each published package gets its own changelog in its own directory, and a root changelog only if the repo itself is released as a whole.

**Which conventions apply.** Infer, then state your assumption in one line so the user can correct it:

| Question | Where to look |
| --- | --- |
| Language | README, existing docs, commit messages. Do not default to English in a Dutch codebase |
| Current version | `git tag --sort=-v:refname \| head`, `package.json`, `composer.json`, `pyproject.toml`, `*.csproj` |
| Versioning scheme | The shape of existing tags. `v2.3.1` is semver, `2026.08.1` is calendar versioning, no tags at all means you propose semver |
| Date format | ISO (`2026-08-10`) unless the project clearly uses something else |

If the project has no version anywhere and has never been released, propose `0.1.0` for something still moving, or `1.0.0` if the user says it is going live.

**How far back to go.** This is the real question. Offer the choice explicitly, with a recommendation:

1. **Start from now** (default for an existing project with a long history). Create the file with a header, an `## [Unreleased]` section, and the changes currently in scope. Older history stays in git where it already lives. Add one line under the header noting that the changelog starts at this version, so the gap is deliberate rather than mysterious.
2. **Backfill from tags** (good when there are a handful of clean releases). For each tag, read the commits between it and the previous one, write a section, and date it with the tag's own date, not today: `git for-each-ref --format='%(creatordate:short)' refs/tags/<tag>`. Do not use `git log -1` for this; on an annotated tag it returns the date of the tagged commit, which can be days off from when the tag was actually cut. Work newest to oldest and stop when the entries get thin or the commit messages stop being informative. Say how far back you went.
3. **One initial entry** (fits a first release or a young project). A single section with `- Initial release.` or a short list of the main capabilities.

Backfilled entries are reconstructions. They are less accurate than entries written at the time, because a commit from eight months ago rarely says what the user-visible effect was. Keep them coarse, prefer fewer and broader bullets, and never fabricate detail to make an old release look complete. If a stretch of history is unreadable, it is fine to write `- See git history for changes before 1.2.0.` and move on.

For the file skeleton, the Dutch header variant, and the compare-link block, read [templates.md](templates.md).

## Output modes

Ask or infer which one is wanted. Default to the first.

1. **Changelog entry** - written into CHANGELOG.md. The default when a repo has one.
2. **Release notes** - a standalone message for a GitHub or GitLab release, a store listing, or an email. Same content, more prose, a short "Highlights" intro of one to three sentences, and no `[Unreleased]` scaffolding.
3. **Draft only** - shown in chat for review, nothing written to disk. Use this when the user is exploring, or when the file is dirty and they have not said they want it changed.

Show the proposed entries before writing when the set is large or the version bump is debatable. A quick "here is the section I am about to add, ok?" is cheaper than an unwanted commit.

## Pitfalls

- **Duplicate entries.** Check whether a change is already listed under `[Unreleased]` before appending. Cherry-picks and merge commits cause this.
- **Merge commits.** Use `--no-merges` and read the underlying commits, otherwise you write "Merge pull request #88" as a feature.
- **Squashed history.** One squashed commit often hides several user-facing changes. Read the diff.
- **The unreleased section that never ships.** When cutting a release, move everything from `[Unreleased]` into the new version section and leave `[Unreleased]` empty with its category headings removed.
- **Dates.** Use ISO format (`2026-08-10`) unless the file does otherwise. Use the actual release date, not a guess.
