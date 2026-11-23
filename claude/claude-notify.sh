#!/bin/bash
# Claude Code Notification hook — fires when Claude needs your input
# (permission prompt, or finished and waiting). Reads hook JSON on stdin.
# Shows a silent macOS banner that identifies WHICH session/tab needs you.

# Hooks run with a minimal PATH — make sure jq / brew tools are findable.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Read the whole hook payload once, then pull out the fields we need.
input=$(cat)
msg=$(printf '%s' "$input" | jq -r '.message // empty' 2>/dev/null)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$msg" ] && msg="Claude needs your attention"

# Project name = the session's working dir basename (matches the Ghostty tab).
project=""
[ -n "$cwd" ] && project=$(basename "$cwd")

# Find this session's Ghostty pane. The hook runs detached, so $PPID may have
# no controlling tty — walk up to the first ancestor that owns a real ttys*.
p=$PPID
pt=""
while [ -n "$p" ] && [ "$p" != "0" ] && [ "$p" != "1" ]; do
  t=$(ps -o tty= -p "$p" 2>/dev/null | tr -d ' ')
  case "$t" in
    ttys*) pt="$t"; break ;;
  esac
  p=$(ps -o ppid= -p "$p" 2>/dev/null | tr -d ' ')
done

# Build a banner that names the tab: title = project, body = message + pane.
title="Claude Code"
[ -n "$project" ] && title="Claude Code — $project"
body="$msg"
[ -n "$pt" ] && body="$msg  ($pt)"

# Preferred: terminal-notifier — reliable banner regardless of focus/pane.
# (Note: clicking it can't focus a specific Ghostty tab — different process.)
if command -v terminal-notifier >/dev/null 2>&1; then
  # To re-enable sound, append to the line below:  -sound Glass
  # -group unique per pane → each session stays separate and they stack
  # (a session only replaces its own previous notification, not other sessions').
  terminal-notifier -title "$title" -subtitle "${project:-session}" -message "$body" -group "claude-${pt:-session}" >/dev/null 2>&1
  exit 0
fi

# Fallback: OSC 777 sent from this session's own Ghostty pane. Because it
# originates from that pane, clicking the banner makes Ghostty focus that tab.
[ -n "$pt" ] && printf '\033]777;notify;%s;%s\007' "$title" "$body" > "/dev/$pt" 2>/dev/null

# Optional sound — uncomment the next line to also play a chime on every notify:
# afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &

exit 0
