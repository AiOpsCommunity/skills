---
name: adr
description: Write, update and supersede Architecture Decision Records (ADRs) in MADR or Nygard format, and keep the decision log consistent over time. Use this skill whenever the user mentions an ADR, an architecture decision, a design decision, a decision record or decision log, asks to document or revisit why something was chosen, wants to compare options before committing to one, or says a past decision no longer holds - even if they do not use the term "ADR" explicitly.
---

# ADR

Capture an architecture decision so that someone reading it in a year understands not just what was chosen, but what else was on the table and why it lost.

The failure mode of decision logs is not bad formatting. It is that they get written once, never revisited, and quietly become lies. Half the value of this skill is in step 5: keeping the log honest when a decision changes.

## Workflow

### 1. Find the existing log

```bash
ls -d doc/adr docs/adr docs/decisions doc/decisions adr 2>/dev/null
```

If a directory exists, read the two most recent records and follow whatever you find: format, numbering, date style, language, front matter or no front matter. An existing convention always wins over the defaults below.

If nothing exists, ask where it should live (`docs/decisions/` is the MADR default, `doc/adr/` the older adr-tools default) and which format. Recommend MADR, and offer Nygard when the user wants the smallest possible thing. See [templates.md](templates.md) for both.

### 2. Number and name the file

`NNNN-short-title-in-kebab-case.md`, zero-padded to four digits, sequential, never reused and never renumbered. Take the highest existing number and add one. If two people add records in parallel and collide, the second one renumbers rather than the first.

The title is the decision, not the topic. "Use PostgreSQL for the primary datastore" beats "Database". Someone scanning the directory listing should be able to read the decisions without opening anything.

### 3. Gather what you need

An ADR is worthless if the alternatives are invented after the fact to make the chosen option look good. Ask for what you cannot find:

- What problem forces a decision now, and what happens if nothing is decided.
- Which options were genuinely considered. Two is a minimum, and "do nothing" is often one of them.
- The drivers that decide it: constraints, quality attributes, team skills, cost, lock-in, deadlines.
- Who decides, and who needs to be consulted or informed.

If the user only has the outcome, say so in the record rather than fabricating a comparison. A short record with one option and honest reasoning is better than a fake trade-off table.

### 4. Write it

Follow the template. Two things matter more than the rest:

**Consequences must include the bad ones.** Every real decision costs something: added operational surface, a skill the team lacks, a lock-in, a migration later. A consequences section with only benefits means nobody thought it through, and it is the first thing a reviewer should push back on.

**Write for a stranger.** No internal shorthand without expansion, no "as discussed in the meeting", no links to chat threads that will rot. The record must stand alone.

Keep it short. One page is normal, three is a sign that the decision should have been split.

### 5. Statuses and superseding

This is where decision logs live or die. Records are append-only history: never rewrite the substance of an accepted record, never delete one.

| Status | Meaning |
| :-- | :-- |
| `proposed` | Written, not yet agreed |
| `accepted` | Agreed and in force |
| `rejected` | Considered and turned down. Keep it, it stops the idea coming back every quarter |
| `deprecated` | No longer applies, nothing replaces it |
| `superseded by 0012` | Replaced by a newer record |

When a decision changes, write a **new** record and link both ways:

- The new record gets `Supersedes 0007` in its front matter or a line under the status.
- The old record's status becomes `superseded by 0012`, with a one-line pointer. That is the only edit ever made to an accepted record.

Before writing a new record, check whether it contradicts an existing one. If it does and the user has not mentioned it, flag it: "this conflicts with 0007, which chose the opposite. Supersede it, or is the scope different?" Silently adding a contradicting record is the single most damaging thing this skill can do.

### 6. Keep the index current

If the directory has a `README.md` or `index.md` listing records, add a row: number, title, status, date. If it does not, offer to create one once there are more than five records. A directory listing stops being readable around then.

## Auditing an existing log

When asked to review the log rather than add to it, check for:

- Records still on `proposed` months after their date. Either they were accepted informally or they died. Ask which.
- Accepted records that contradict each other, with no superseding link.
- Records that describe technology no longer in the codebase. Verify against the repo before claiming this: check package manifests, config files, directory names.
- Consequences sections with no downsides.
- Missing records for decisions clearly visible in the code, for example a message queue that appears in the infrastructure but nowhere in the log.

Report findings, propose the specific fix per record, and let the user pick. Do not mass-edit statuses.

## Anti-patterns

- **The retro-ADR factory.** Generating twenty records for decisions made years ago produces a directory nobody reads. Write records for decisions that are still contested or still costly to reverse.
- **ADRs for non-decisions.** "Use TypeScript" in a repo that has been TypeScript since day one is documentation, not a decision. If there was no alternative, there is no record.
- **The living document.** Editing an accepted record until it matches current reality destroys the history that makes the log worth keeping. New record, supersede, move on.
- **Consequence-free records.** See above. Push back on it.

## Output

Write the file, then show the user a short summary: path, title, status, and which records it supersedes or conflicts with. For anything larger than a trivial record, show the draft before writing when the user has not asked for it to be created directly.
