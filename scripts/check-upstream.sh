#!/usr/bin/env bash
# Compare the upstream snapshot in upstream/ with the latest mattpocock/skills.
#
#   scripts/check-upstream.sh           show what changed upstream (no writes)
#   scripts/check-upstream.sh --update  refresh the snapshot to the latest commit
#
# After --update, `git diff upstream/` shows the upstream changes; port the ones
# you want into skills/grill-me-better/SKILL.md by hand.
set -euo pipefail

REPO="mattpocock/skills"
FILES=(
  "grilling/SKILL.md:skills/productivity/grilling/SKILL.md"
  "grill-me/SKILL.md:skills/productivity/grill-me/SKILL.md"
)

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
snap="$root/upstream"
pinned="$(cat "$snap/COMMIT")"
latest="$(curl -fsSL "https://api.github.com/repos/$REPO/commits/main" \
  | sed -n 's/^  "sha": "\([0-9a-f]*\)".*/\1/p' | head -n1)"

if [[ -z "$latest" ]]; then
  echo "Could not resolve latest commit of $REPO" >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

changed=0
for entry in "${FILES[@]}"; do
  local_path="${entry%%:*}"
  remote_path="${entry#*:}"
  mkdir -p "$tmp/$(dirname "$local_path")"
  curl -fsSL "https://raw.githubusercontent.com/$REPO/$latest/$remote_path" \
    -o "$tmp/$local_path"
  if ! diff -u "$snap/$local_path" "$tmp/$local_path" \
      --label "pinned/$local_path" --label "latest/$local_path"; then
    changed=1
  fi
done

if [[ "$changed" -eq 0 ]]; then
  echo "Up to date: upstream skill text unchanged since ${pinned:0:7} (latest ${latest:0:7})."
  exit 0
fi

if [[ "${1:-}" == "--update" ]]; then
  for entry in "${FILES[@]}"; do
    local_path="${entry%%:*}"
    cp "$tmp/$local_path" "$snap/$local_path"
  done
  echo "$latest" > "$snap/COMMIT"
  echo
  echo "Snapshot updated ${pinned:0:7} -> ${latest:0:7}. Review with: git diff upstream/"
else
  echo
  echo "Upstream changed (${pinned:0:7} -> ${latest:0:7}). Re-run with --update to refresh the snapshot."
fi
