# Templates

Read this when creating a new CHANGELOG.md, when adding a release section, or when you need the exact link syntax.

## New CHANGELOG.md

```markdown
# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-08-10

### Added

- First release.
```

Dutch variant of the header, for projects that write in Dutch:

```markdown
# Changelog

Alle noemenswaardige wijzigingen aan dit project staan in dit bestand.

Het format is gebaseerd op [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
en dit project volgt [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
```

Category headings in Dutch, if the file uses Dutch: `Toegevoegd`, `Gewijzigd`, `Verouderd`, `Verwijderd`, `Opgelost`, `Beveiliging`.

## Release section

```markdown
## [1.4.0] - 2026-08-10

### Added

- Added an export button to the order overview. (#412)

### Changed

- **BREAKING** Changed the default currency for new shops to EUR. Existing shops keep their setting.

### Fixed

- Fixed a crash when opening an empty cart.
```

Order the categories as: Added, Changed, Deprecated, Removed, Fixed, Security. Leave out empty ones. One blank line between the heading and the list, one between sections.

## Compare links

Some files keep reference-style links at the bottom. When they do, add a line for the new version and repoint `[Unreleased]`:

```markdown
[Unreleased]: https://github.com/owner/repo/compare/v1.4.0...HEAD
[1.4.0]: https://github.com/owner/repo/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/owner/repo/compare/v1.2.0...v1.3.0
```

Get the remote with `git remote get-url origin` and normalise an SSH URL (`git@github.com:owner/repo.git`) to its HTTPS form. GitLab uses the same `/compare/a...b` path, Bitbucket uses `/branches/compare/b%0Da`.

## Release notes (mode 2)

For a GitHub or GitLab release body, drop the `[Unreleased]` scaffolding and lead with highlights:

```markdown
## v1.4.0

Orders can now be exported to CSV, and the empty-cart crash several of you reported is gone.

### Added

- Added an export button to the order overview. (#412)

### Fixed

- Fixed a crash when opening an empty cart.

**Full changelog**: https://github.com/owner/repo/compare/v1.3.0...v1.4.0
```

Keep the highlights to one to three sentences and only mention things a reader cares about. If there is a breaking change, it goes in the highlights with the upgrade step, not buried in a list.

## Yanked releases

A release pulled after publishing stays in the file, marked so nobody uses it:

```markdown
## [1.3.1] - 2026-07-02 [YANKED]
```

Explain in one line underneath why it was yanked and which version to use instead.
