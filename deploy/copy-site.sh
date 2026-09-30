#!/usr/bin/env bash
# Copy the website (public/) to a target directory.
#
# Usage: deploy/copy-site.sh <target-dir> [--delete]
#   deploy/copy-site.sh /var/www/indrik-site/public
#   deploy/copy-site.sh user@vps:/var/www/indrik-site/public   (needs rsync)
#   deploy/copy-site.sh ./out --delete    remove files in the target that are no longer in public/
set -euo pipefail

target="${1:-}"
delete="${2:-}"

if [[ -z "$target" || "$target" == -* ]]; then
  echo "Usage: $0 <target-dir> [--delete]" >&2
  exit 1
fi
if [[ -n "$delete" && "$delete" != "--delete" ]]; then
  echo "Unknown option: $delete" >&2
  exit 1
fi

src="$(cd "$(dirname "${BASH_SOURCE[0]}")/../public" && pwd)"

if command -v rsync >/dev/null 2>&1; then
  # --exclude '.*' keeps dotfiles (.git, .env, ...) out of the web root
  rsync -rlt --exclude '.*' ${delete:+--delete} "$src"/ "$target"/
else
  if [[ "$target" == *:* && "$target" != /* ]]; then
    echo "Remote targets need rsync, which is not installed." >&2
    exit 1
  fi
  if [[ -n "$delete" ]]; then
    echo "--delete needs rsync, which is not installed." >&2
    exit 1
  fi
  mkdir -p "$target"
  cp -R "$src"/. "$target"/
fi

echo "Copied $src -> $target"
