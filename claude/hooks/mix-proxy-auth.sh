#!/bin/bash
# PreToolUse hook (Bash): run `mix ...` commands through with-proxy-auth.
#
# Why: inside the sandbox, elixir_make (precompiled NIFs such as lazy_html)
# ignores the credentials in HTTPS_PROXY and fails with "407 Proxy
# Authentication Required". with-proxy-auth gives the command a local,
# credential-free proxy that forwards to the sandbox proxy (same allowlist).
#
# Rewrites only commands whose first word, after optional VAR=value
# assignments, is `mix`. The assignments stay in front, so deny rules like
# Bash(MIX_ENV=prod *) still match. Pipes after mix (`mix test | tail`) work;
# a second mix in an && / ; chain is not wrapped. Outside the sandbox the
# wrapper just runs the command.
JQ=/opt/homebrew/bin/jq
W=/Users/ivanivanov/.local/bin/with-proxy-auth
[ -x "$W" ] || exit 0

input=$(cat)
cmd=$(printf '%s' "$input" | "$JQ" -r '.tool_input.command // empty')
[ -n "$cmd" ] || exit 0

re='^(([A-Za-z_][A-Za-z0-9_]*=[^][:space:]"'"'"'`$;&|<>()[]*[[:space:]]+)*)(mix([[:space:]].*)?)$'
if [[ $cmd =~ $re ]]; then
  new="${BASH_REMATCH[1]}$W ${BASH_REMATCH[3]}"
  printf '%s' "$input" | "$JQ" --arg c "$new" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      updatedInput: (.tool_input + {command: $c})
    }
  }'
fi
exit 0
