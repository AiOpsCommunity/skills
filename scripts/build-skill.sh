#!/usr/bin/env bash
#
# build-skill.sh — package a skill folder into an uploadable .skill archive.
#
# A .skill file is just a ZIP of the skill folder with the folder at the
# archive root (claude.ai's Settings -> Skills -> Upload requires the folder
# inside the zip, not a bare SKILL.md). The folder under skills/ is the single
# source of truth; this archive is a throwaway build output (git-ignored).
#
# Usage:
#   ./scripts/build-skill.sh <skill-name>     # build one skill
#   ./scripts/build-skill.sh --all            # build every skill under skills/
#
# Output: dist/<skill-name>.skill

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_dir="$repo_root/skills"
dist_dir="$repo_root/dist"

build_one() {
  local name="$1"
  local src="$skills_dir/$name"

  if [[ ! -f "$src/SKILL.md" ]]; then
    echo "error: $skills_dir/$name/SKILL.md not found" >&2
    return 1
  fi

  mkdir -p "$dist_dir"
  local out="$dist_dir/$name.skill"
  rm -f "$out"

  # Zip from inside skills/ so the archive contains "<name>/SKILL.md" at its root.
  ( cd "$skills_dir" && zip -r -q "$out" "$name" -x '*.DS_Store' )
  echo "built $out"
}

main() {
  if [[ $# -lt 1 ]]; then
    echo "usage: $0 <skill-name> | --all" >&2
    exit 1
  fi

  if [[ "$1" == "--all" ]]; then
    for dir in "$skills_dir"/*/; do
      build_one "$(basename "$dir")"
    done
  else
    build_one "$1"
  fi
}

main "$@"
