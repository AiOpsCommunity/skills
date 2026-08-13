# ADR templates

Read this when creating a record or setting up a new decision log.

## MADR, full form

Use for decisions with real trade-offs. This is the default.

```markdown
---
status: accepted
date: 2026-08-11
decision-makers: [name, name]
consulted: [name]
informed: [team]
---

# Use PostgreSQL as the primary datastore

## Context and Problem Statement

Two paragraphs at most. What situation forces a decision, what happens if we do
not decide, and what constrains the answer. State the question explicitly.

## Decision Drivers

- Operational cost and who carries the pager
- Team familiarity
- Data model fit, in particular relational integrity
- Managed hosting available in the EU

## Considered Options

- PostgreSQL
- MySQL
- MongoDB
- Stay on the existing SQLite setup

## Decision Outcome

Chosen option: PostgreSQL, because it meets the relational requirements while
keeping operational cost within reach of a team with no dedicated DBA.

### Consequences

- Good, because JSONB gives us a documented path for semi-structured data
  without a second datastore.
- Good, because every managed EU host we shortlisted supports it.
- Bad, because nobody on the team has tuned Postgres in production, so the
  first incident will be slow.
- Bad, because the existing SQLite migrations have to be rewritten before the
  next release.

### Confirmation

How we will know this was carried out: the staging environment runs Postgres
before sprint 14 and the SQLite adapter is removed from the codebase.

## Pros and Cons of the Options

### MySQL

- Good, because two team members have production experience with it.
- Neutral, because hosting options are comparable.
- Bad, because the JSON support is weaker than JSONB for our reporting queries.

### MongoDB

- Good, because the ingest shape maps naturally to documents.
- Bad, because we need cross-entity transactions in the billing path.

### Stay on SQLite

- Good, because it costs nothing today.
- Bad, because concurrent writes already fail under current load.

## More Information

Link to the spike, the benchmark, the vendor quote. No links to chat threads.
```

## MADR, short form

Use when the decision is real but small, or when there is genuinely one viable option.

```markdown
---
status: accepted
date: 2026-08-11
decision-makers: [name]
---

# Run migrations in a separate deploy step

## Context and Problem Statement

Migrations currently run on application boot, which means a slow migration
blocks every container start and a failed one crash-loops the deploy.

## Considered Options

- Separate deploy step
- Keep running on boot
- Manual migrations

## Decision Outcome

Chosen option: separate deploy step, because it makes migration failure visible
before traffic is routed to new containers.

### Consequences

- Good, because a failed migration stops the deploy instead of the service.
- Bad, because the deploy pipeline gains a step that has to be maintained.
```

## Nygard, original form

Use when the team wants the minimum, or when the existing log already uses it.

```markdown
# 7. Use PostgreSQL as the primary datastore

Date: 2026-08-11

## Status

Accepted

## Context

The forces at play, in neutral language. Facts and constraints, not opinions.
Describe the situation so completely that the decision reads as inevitable.

## Decision

We will use PostgreSQL. Active voice, full sentences: "We will ...".

## Consequences

What becomes easier and what becomes harder, both stated. Everything that
follows from the decision, positive, negative and neutral.
```

Superseding in Nygard style is a status line plus a link:

```markdown
## Status

Superseded by [12. Move billing to a dedicated datastore](0012-move-billing-to-a-dedicated-datastore.md)
```

## Index

```markdown
# Architecture Decision Records

| # | Decision | Status | Date |
| :-- | :-- | :-- | :-- |
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions | accepted | 2026-01-14 |
| [0007](0007-use-postgresql.md) | Use PostgreSQL as the primary datastore | superseded by 0012 | 2026-03-02 |
| [0012](0012-move-billing-to-a-dedicated-datastore.md) | Move billing to a dedicated datastore | accepted | 2026-08-11 |
```

## The first record

Many logs open with a record about keeping the log. It is worth writing, because
it fixes the format and location for everyone after you.

```markdown
---
status: accepted
date: 2026-08-11
decision-makers: [name]
---

# Record architecture decisions

## Context and Problem Statement

Decisions with long-lived consequences are made in chat and meetings, and the
reasoning is lost within weeks. New team members re-litigate settled questions.

## Considered Options

- ADRs in the repository
- A wiki page
- Nothing

## Decision Outcome

Chosen option: ADRs in the repository, in MADR format under `docs/decisions/`,
because they are versioned with the code and reviewed in the same pull request.

### Consequences

- Good, because the reasoning travels with the code.
- Bad, because it adds a step to decisions that people will sometimes skip.
```
