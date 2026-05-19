#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
LABEL="${CODEX_AUTO_SYNC_LABEL:-com.pomeloneo.codex-auto-sync}"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
SCRIPT="$REPO_DIR/scripts/auto-sync.sh"
UID_VALUE="$(id -u)"
INTERVAL_SECONDS="${CODEX_AUTO_SYNC_INTERVAL_SECONDS:-300}"

xml_escape() {
  printf '%s' "$1" |
    sed \
      -e 's/&/\&amp;/g' \
      -e 's/</\&lt;/g' \
      -e 's/>/\&gt;/g' \
      -e 's/"/\&quot;/g'
}

mkdir -p "$HOME/Library/LaunchAgents" "$REPO_DIR/log"

REPO_XML="$(xml_escape "$REPO_DIR")"
SCRIPT_XML="$(xml_escape "$SCRIPT")"
LABEL_XML="$(xml_escape "$LABEL")"

cat > "$PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL_XML</string>

  <key>ProgramArguments</key>
  <array>
    <string>$SCRIPT_XML</string>
  </array>

  <key>WorkingDirectory</key>
  <string>$REPO_XML</string>

  <key>RunAtLoad</key>
  <true/>

  <key>StartInterval</key>
  <integer>$INTERVAL_SECONDS</integer>

  <key>WatchPaths</key>
  <array>
    <string>$REPO_XML/.gitignore</string>
    <string>$REPO_XML/README.md</string>
    <string>$REPO_XML/AGENTS.md</string>
    <string>$REPO_XML/version.json</string>
    <string>$REPO_XML/agents</string>
    <string>$REPO_XML/agent-instructions</string>
    <string>$REPO_XML/prompts</string>
    <string>$REPO_XML/scripts</string>
    <string>$REPO_XML/skills</string>
  </array>

  <key>StandardOutPath</key>
  <string>$REPO_XML/log/auto-sync-launchd.out.log</string>

  <key>StandardErrorPath</key>
  <string>$REPO_XML/log/auto-sync-launchd.err.log</string>

  <key>ThrottleInterval</key>
  <integer>30</integer>
</dict>
</plist>
PLIST

chmod 644 "$PLIST"
chmod +x "$SCRIPT"

launchctl bootout "gui/$UID_VALUE" "$PLIST" 2>/dev/null || true
launchctl bootstrap "gui/$UID_VALUE" "$PLIST"
launchctl enable "gui/$UID_VALUE/$LABEL"
launchctl kickstart -k "gui/$UID_VALUE/$LABEL"

printf 'Installed %s\n' "$PLIST"
