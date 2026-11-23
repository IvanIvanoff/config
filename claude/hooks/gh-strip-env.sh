#!/bin/bash
# PreToolUse hook (Bash): strip harmless env-var prefixes from read-only gh
# commands so they match sandbox.excludedCommands.
#
# Why: exclusions only match a command that starts with "gh ...". With a
# prefix like "SSL_CERT_FILE=... gh pr view", gh runs inside the sandbox and
# fails TLS with "x509: OSStatus -26276". gh doesn't need these variables
# (Go on macOS verifies certificates through the system).
#
# Safety: only removes assignments of the variables listed below, only when
# the rest is one of the excluded read-only gh subcommands. Never adds
# anything; every other command passes through untouched.
JQ=/opt/homebrew/bin/jq

input=$(cat)
cmd=$(printf '%s' "$input" | "$JQ" -r '.tool_input.command // empty')
[ -n "$cmd" ] || exit 0

vars='SSL_CERT_FILE|SSL_CERT_DIR|CURL_CA_BUNDLE|REQUESTS_CA_BUNDLE|NODE_EXTRA_CA_CERTS|GH_PAGER|PAGER|NO_COLOR|CLICOLOR|GH_NO_UPDATE_NOTIFIER|GH_PROMPT_DISABLED'
# value: no quotes, spaces or shell metacharacters
val='[^][:space:]"'"'"'`$;&|<>()[]*'
sub='pr[[:space:]]+(view|list|diff|checks)|run[[:space:]]+(list|view)|auth[[:space:]]+status'
re="^(($vars)=$val[[:space:]]+)+(gh[[:space:]]+($sub)([[:space:]].*)?)$"

if [[ $cmd =~ $re ]]; then
  new=${BASH_REMATCH[3]}
  printf '%s' "$input" | "$JQ" --arg c "$new" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      updatedInput: (.tool_input + {command: $c})
    }
  }'
fi
exit 0
