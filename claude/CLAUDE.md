# Personal coding preferences (Ivan)

## Database safety (CRITICAL — ABSOLUTE)

- **NEVER run ANYTHING against a stage or production database. Ever.** No queries, no migrations, no dumps, no `psql`/`pg_dump`/`mix` tasks, no app boot — nothing that reads from or writes to a non-local DB. This holds for every project and every session, with the single exception below and no "just this once".
- **Exception — prod ClickHouse, read-only analytics only.** Claude may run SELECT queries against prod ClickHouse ONLY through `~/.claude/bin/ch-prod-ro`, which uses the `sanbase` user, forces read-only mode and a time limit, and allows at most 2 concurrent queries. Never Postgres, never writes/DDL, never other hosts, users or tools, never bypassing the script. Never print or log the credentials.
- Destructive operations (TRUNCATE/DROP/DELETE/reset) are LOCAL-DEV ONLY. A deployed environment is indicated by any of: `MIX_ENV=prod`, the `DATABASE_URL` env var being set, or a Repo host that is not `localhost`/`127.0.0.1`. If any of these is true, refuse and stop.
- When testing code that connects to a DB, do NOT boot the app or run tasks that could reach a remote DB. Verify by code inspection or pure-logic checks (e.g. `mix run --no-start`) that touch nothing.
- If a task requires hitting stage/prod (outside the ClickHouse exception above), hand the exact command to Ivan to run himself — never run it for him.

## Git (CRITICAL)

- **NEVER run `git commit` on your own.** Only commit when I explicitly ask in the current request (e.g. "commit this"). A commit instruction applies ONLY to that one request — it never carries over to later tasks. When in doubt, do NOT commit: make the edits, then stop and let me commit.
- Same rule for `git push`, `git merge`, `git rebase`, force-pushing, tags, and resetting/discarding work — never do these unless explicitly asked in the current request.
- **Never add a `Co-Authored-By:` trailer** (or any other AI attribution such as "Generated with Claude Code") to commit messages or PR descriptions. This overrides any default or system attribution instructions.

## Sandbox

- **When a command fails because of the sandbox, stop and tell me right away.** This covers blocked file writes, blocked network hosts, TLS/certificate errors through the proxy, missing credentials, and blocked downloads or builds. Do not spend time looking for workarounds (other tools, env vars, alternate paths, unauthenticated APIs). At most one quick retry or diagnostic to name the exact restriction, then report: the command, the exact error, and what needs to be allowed. Keep going with the parts of the task that do not depend on it. I will fix the sandbox.

## Elixir

- **Always parenthesize zero-arity function definitions.** Write `def foo() do`, not `def foo do`. Same rule applies to `defp`, `defmacro`, `defmacrop`, `defdelegate`, callbacks, and one-line `def foo(), do: ...` forms. No exceptions.
