# Claude Code setup

My Claude Code configuration: sandbox settings, hooks and helper tools.
The generic, shareable version with explanations lives in
`~/work/claude-setup` (`SETUP.md`).

## New laptop

```sh
brew install jq gnupg pinentry-mac
xcode-select --install          # Command Line Tools: git, python3 for with-proxy-auth
# install Claude Code, clone this repo to ~/config, link .gitconfig/.zshrc as usual
~/config/claude/sync.sh install # copies files into ~/.claude and ~/.local/bin
~/config/claude/sync.sh gpg     # GPG keyring for signed commits inside the sandbox
```
Then:
- restore `~/.claude/bin/ch-prod-ro` from the password manager (it contains
  credentials, so it is never in git);
- start `claude`, reinstall the plugins listed in `enabledPlugins` (`/plugin`);
- in a session, check `echo test | gpg --batch --local-user <KEY> --clearsign`.

## After changing the live setup

```sh
~/config/claude/sync.sh status    # what differs
~/config/claude/sync.sh collect   # copy live -> repo
git -C ~/config diff -- claude/   # review, then commit
```

## What's here

| Repo file | Installed to | What |
|---|---|---|
| `settings.json` | `~/.claude/settings.json` | permissions, sandbox, hooks, plugins |
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | my rules for every session |
| `claude-notify.sh` | `~/.claude/claude-notify.sh` | Notification hook (macOS banner) |
| `hooks/gh-strip-env.sh` | `~/.claude/hooks/` | strips `SSL_CERT_FILE=…` etc. from `gh` commands so the sandbox exclusion matches |
| `hooks/mix-proxy-auth.sh` | `~/.claude/hooks/` | runs `mix …` through `with-proxy-auth` |
| `bin/with-proxy-auth` | `~/.local/bin/` | local proxy shim: fixes `407` for elixir_make downloads in the sandbox |

Not in git: `~/.claude/bin/ch-prod-ro` (credentials), `~/.gnupg-sandbox`
(recreated by `sync.sh gpg`), session memory, plugin caches.

Files are copied, not symlinked. Hooks and settings run outside the sandbox,
so they must not live in a folder that sandboxed commands can write to.
