#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
REMOTE="${CODEX_AUTO_SYNC_REMOTE:-origin}"
BRANCH="${CODEX_AUTO_SYNC_BRANCH:-main}"
DEBOUNCE_SECONDS="${CODEX_AUTO_SYNC_DEBOUNCE_SECONDS:-8}"
LOG_FILE="${CODEX_AUTO_SYNC_LOG:-$REPO_DIR/log/auto-sync-git.log}"
LOCK_DIR="${CODEX_AUTO_SYNC_LOCK_DIR:-$REPO_DIR/.auto-sync.lock}"
TRACKED_PATHS=(
  .gitignore
  README.md
  AGENTS.md
  version.json
  agents
  agent-instructions
  prompts
  scripts
  skills
)

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

remote_ref="$REMOTE/$BRANCH"
remote_fetch_ok=0

if git fetch "$REMOTE" "$BRANCH"; then
  remote_fetch_ok=1
else
  log "fetch failed from $REMOTE/$BRANCH"
fi

sync_with_remote() {
  if [ "$remote_fetch_ok" -ne 1 ]; then
    return 0
  fi

  if ! git show-ref --verify --quiet "refs/remotes/$remote_ref"; then
    return 0
  fi

  if git merge-base --is-ancestor "$remote_ref" HEAD; then
    return 0
  fi

  if git merge-base --is-ancestor HEAD "$remote_ref"; then
    git merge --ff-only "$remote_ref"
    log "fast-forwarded to $(git rev-parse --short HEAD)"
    return 0
  fi

  if git rebase "$remote_ref"; then
    log "rebased onto $remote_ref"
  else
    log "rebase failed; manual resolution required"
    exit 1
  fi
}

push_with_retry() {
  local attempt

  for attempt in 1 2; do
    if git push "$REMOTE" "$BRANCH"; then
      log "pushed $(git rev-parse --short HEAD) to $REMOTE/$BRANCH"
      return 0
    fi

    log "push attempt $attempt failed for $(git rev-parse --short HEAD)"

    if [ "$attempt" -eq 2 ]; then
      return 1
    fi

    if git fetch "$REMOTE" "$BRANCH"; then
      remote_fetch_ok=1
      sync_with_remote
    else
      log "fetch after failed push also failed"
      return 1
    fi
  done
}

git add -A -- "${TRACKED_PATHS[@]}"

if git diff --cached --quiet --exit-code; then
  sync_with_remote

  if [ "$remote_fetch_ok" -eq 1 ] &&
    git show-ref --verify --quiet "refs/remotes/$remote_ref" &&
    ! git diff --quiet "$remote_ref"..HEAD --; then
    push_with_retry || exit 1
  fi

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

sync_with_remote
push_with_retry || exit 1
