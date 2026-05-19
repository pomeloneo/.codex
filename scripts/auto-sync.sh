#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
REMOTE="${CODEX_AUTO_SYNC_REMOTE:-origin}"
BRANCH="${CODEX_AUTO_SYNC_BRANCH:-main}"
DEBOUNCE_SECONDS="${CODEX_AUTO_SYNC_DEBOUNCE_SECONDS:-8}"
LOG_FILE="${CODEX_AUTO_SYNC_LOG:-$REPO_DIR/log/auto-sync-git.log}"
LOCK_DIR="${CODEX_AUTO_SYNC_LOCK_DIR:-$REPO_DIR/.auto-sync.lock}"

mkdir -p "$(dirname "$LOG_FILE")"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$*" >> "$LOG_FILE"
}

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  exit 0
fi

cleanup() {
  rmdir "$LOCK_DIR" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

sleep "$DEBOUNCE_SECONDS"

cd "$REPO_DIR"

if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ] || [ -f .git/MERGE_HEAD ]; then
  log "skip: another git operation is in progress"
  exit 0
fi

current_branch="$(git symbolic-ref --quiet --short HEAD || true)"
if [ "$current_branch" != "$BRANCH" ]; then
  log "skip: on branch ${current_branch:-detached}, expected $BRANCH"
  exit 0
fi

git add -A -- \
  .gitignore \
  README.md \
  AGENTS.md \
  version.json \
  agents \
  agent-instructions \
  prompts \
  scripts \
  skills

if git diff --cached --quiet --exit-code; then
  exit 0
fi

forbidden_paths="$(
  git diff --cached --name-only |
    grep -E '^(auth\.json|config\.toml|history\.jsonl|session_index\.jsonl|sessions/|archived_sessions/|log/|logs_.*\.sqlite|state_.*\.sqlite|[^/]+\.sqlite|cache/|tmp/|\.tmp/|plugins/|vendor_imports/|computer-use/|rules/|skills/\.system/|installation_id|models_cache\.json)' || true
)"

if [ -n "$forbidden_paths" ]; then
  git reset -q
  log "abort: forbidden paths reached the index"
  printf '%s\n' "$forbidden_paths" >> "$LOG_FILE"
  exit 1
fi

secret_matches="$(
  git grep --cached -I -l -E '(sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY|eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,})' || true
)"

if [ -n "$secret_matches" ]; then
  git reset -q
  log "abort: secret-like patterns found in staged files"
  printf '%s\n' "$secret_matches" >> "$LOG_FILE"
  exit 1
fi

commit_message="Auto-sync Codex configuration"
commit_detail="Triggered by local ~/.codex file changes at $(date '+%Y-%m-%d %H:%M:%S %z')."

git commit -m "$commit_message" -m "$commit_detail"

if git push "$REMOTE" "$BRANCH"; then
  log "pushed $(git rev-parse --short HEAD) to $REMOTE/$BRANCH"
else
  log "push failed for $(git rev-parse --short HEAD)"
  exit 1
fi
