#!/usr/bin/env bash
#
# validate.sh - structural checks for this repo. Run before opening a PR.
# CI runs the same script, so a green run here means a green run there.
#
# Fails on (these break installation or discovery):
#   - marketplace.json invalid, or an entry missing name, source or description
#   - an entry whose source is not ./skills/<name>, or whose folder is missing
#   - a skill folder without SKILL.md, or with frontmatter that does not parse
#   - a frontmatter name that differs from the folder, or no description
#   - a skill not listed in marketplace.json or in the README's Skills table
#   - a relative link in a skill that points at a file that does not exist
#   - a committed .skill archive
#
# Warns on (worth a look, does not block):
#   - a description longer than the 1,536 characters the listing shows
#   - a SKILL.md body over 500 lines
#   - "the <name> skill" where no skill of that name is in this repository
#
# It cannot tell you whether a skill is any good. Test it locally for that;
# see CONTRIBUTING.md.

set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root" || exit 1

python3 - <<'PY'
import json
import os
import re
import subprocess
import sys

DESCRIPTION_LIMIT = 1536
BODY_LIMIT = 500

failures = 0
warned = False


def err(msg):
    global failures
    print(f"  FAIL: {msg}", file=sys.stderr)
    failures += 1


def warn(msg):
    global warned
    print(f"  warn: {msg}")
    warned = True


def ok(msg):
    print(f"  ok: {msg}")


def frontmatter(text):
    """The top-level keys of a SKILL.md frontmatter, or None when it is not closed.

    Handles `key: value` and the folded or literal block forms (`key: >`), which
    is all a skill's frontmatter uses. Not a YAML parser, and does not need to be.
    """
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---", 3)
    if end == -1:
        return None
    fields = {}
    key = None
    for line in text[4:end].splitlines():
        match = re.match(r"^([A-Za-z][\w-]*):\s*(.*)$", line)
        if match:
            key, value = match.groups()
            fields[key] = "" if value in (">", "|", ">-", "|-") else value.strip()
        elif key and line.startswith((" ", "\t")):
            fields[key] = (fields[key] + " " + line.strip()).strip()
    for key, value in fields.items():
        if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
            fields[key] = value[1:-1]
    return fields, text[end + 4:]


# ---------------------------------------------------------------- marketplace

print("marketplace.json")
try:
    with open(".claude-plugin/marketplace.json") as fh:
        marketplace = json.load(fh)
    ok("valid JSON")
except (OSError, ValueError) as exc:
    err(f"cannot read .claude-plugin/marketplace.json: {exc}")
    sys.exit(1)

listed = set()
for entry in marketplace.get("plugins", []):
    name, source = entry.get("name"), entry.get("source")
    if not name or not source:
        err(f"entry missing name or source: {entry}")
        continue
    listed.add(name)
    if source != f"./skills/{name}":
        err(f"{name}: source is {source}, expected ./skills/{name}")
    elif not os.path.isdir(source):
        err(f"{name}: {source} does not exist")
    if not entry.get("description"):
        err(f"{name}: no description, which is what /plugin shows before install")

with open("README.md") as fh:
    readme = fh.read()

# ---------------------------------------------------------------- skills

skills = sorted(
    d for d in os.listdir("skills") if os.path.isdir(os.path.join("skills", d))
)

for name in skills:
    print(f"\nskills/{name}")
    before = failures
    base = os.path.join("skills", name)
    doc = os.path.join(base, "SKILL.md")

    if name not in listed:
        err(f"not listed in .claude-plugin/marketplace.json, so nobody can install it")
    if f"(skills/{name}/SKILL.md)" not in readme:
        err(f"no row in the README's Skills table linking skills/{name}/SKILL.md")

    if not os.path.isfile(doc):
        err("no SKILL.md, so Claude Code will not load it")
        continue

    with open(doc, encoding="utf-8") as fh:
        text = fh.read()

    parsed = frontmatter(text)
    if parsed is None:
        err("SKILL.md has no frontmatter, or it is not closed with ---")
        continue
    fields, body = parsed

    if fields.get("name") != name:
        err(f"frontmatter name is '{fields.get('name')}', folder is '{name}'")
    description = fields.get("description", "")
    if not description:
        err("no description, so Claude cannot tell when to use it")
    elif len(description) > DESCRIPTION_LIMIT:
        warn(
            f"description is {len(description)} characters; the listing cuts it "
            f"at {DESCRIPTION_LIMIT}, so put the triggers first"
        )

    lines = body.count("\n")
    if lines > BODY_LIMIT:
        warn(f"SKILL.md body is {lines} lines; move detail into a sibling file")

    for path in sorted(
        os.path.join(root, f)
        for root, _, files in os.walk(base) for f in files
        if f.endswith(".md")
    ):
        with open(path, encoding="utf-8") as fh:
            content = fh.read()
        # Code blocks hold examples, not links this skill depends on.
        prose = re.sub(r"```.*?```", "", content, flags=re.S)
        for target in re.findall(r"\]\(([^)\s]+)\)", prose):
            if re.match(r"^[a-z]+:|^#", target):
                continue
            resolved = os.path.normpath(
                os.path.join(os.path.dirname(path), target.split("#")[0])
            )
            if not os.path.exists(resolved):
                err(f"{os.path.relpath(path, base)} links to {target}, which does not exist")
        for other in sorted(set(re.findall(r"\bthe ([a-z0-9]+(?:-[a-z0-9]+)+) skill\b", prose))):
            if other not in skills:
                warn(
                    f"{os.path.relpath(path, base)} refers to the {other} skill, which "
                    "is not in this repository. Someone who installs only this skill "
                    "does not have it"
                )

    if failures == before:
        ok("looks good")

for orphan in sorted(listed - set(skills)):
    err(f"marketplace lists {orphan}, but skills/{orphan} does not exist")

# ---------------------------------------------------------------- build output

archives = subprocess.run(
    ["git", "ls-files", "*.skill", "dist/*"], capture_output=True, text=True
).stdout.split()
for path in archives:
    err(f"{path} is committed; .skill archives are build output, see build-skill.sh")

print()
if failures:
    print("validation failed", file=sys.stderr)
    sys.exit(1)
print("all checks passed" + (" (with warnings)" if warned else ""))
PY
