#!/bin/bash
# Keep my Claude Code setup in this repo and restore it on a new machine.
#
#   claude/sync.sh collect   copy the live files INTO this repo (then review + commit)
#   claude/sync.sh install   copy this repo's files into place (new laptop / restore)
#   claude/sync.sh gpg       create ~/.gnupg-sandbox for signed commits in the sandbox
#   claude/sync.sh status    show which live files differ from the repo
#
# Files are COPIED, never symlinked: ~/config can be written by sandboxed
# commands, while hooks and settings run outside the sandbox. Copies in
# ~/.claude/hooks etc. are write-protected by the sandbox; symlinks into
# ~/config would not be.
#
# Run `install` and `gpg` in a normal terminal: the sandbox blocks writes to
# ~/.claude/settings.json, hooks and ~/.local/bin.
set -euo pipefail

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# repo path               live path                          mode
FILES=(
  "settings.json          $HOME/.claude/settings.json        644"
  "CLAUDE.md              $HOME/.claude/CLAUDE.md            644"
  "claude-notify.sh       $HOME/.claude/claude-notify.sh     755"
  "hooks/gh-strip-env.sh  $HOME/.claude/hooks/gh-strip-env.sh  644"
  "hooks/mix-proxy-auth.sh $HOME/.claude/hooks/mix-proxy-auth.sh 644"
  "bin/with-proxy-auth    $HOME/.local/bin/with-proxy-auth   755"
)

each() { for line in "${FILES[@]}"; do set -- $line; "$CB" "$1" "$2" "$3"; done; }

do_collect() {
  local src=$2 dst=$REPO/$1
  [ -f "$src" ] || { echo "  missing (skipped): $src"; return; }
  mkdir -p "$(dirname "$dst")"; cp "$src" "$dst"; echo "  $src -> claude/$1"
}

do_install() {
  local src=$REPO/$1 dst=$2 mode=$3
  [ -f "$src" ] || { echo "  missing in repo (skipped): $1"; return; }
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && ! cmp -s "$src" "$dst"; then
    cp "$dst" "$dst.bak-$(date +%Y%m%d-%H%M%S)"; echo "  backed up $dst"
  fi
  cp "$src" "$dst"; chmod "$mode" "$dst"; echo "  claude/$1 -> $dst"
}

do_status() {
  local src=$2 dst=$REPO/$1
  if [ ! -f "$src" ]; then echo "  not installed: $src"
  elif [ ! -f "$dst" ]; then echo "  not collected: $1"
  elif cmp -s "$src" "$dst"; then echo "  same:    $1"
  else echo "  CHANGED: $1  (diff $dst $src)"; fi
}

case ${1:-} in
  collect)
    CB=do_collect each
    jq empty "$REPO/settings.json" && echo "settings.json is valid JSON"
    echo "Review with: git -C $REPO/.. diff -- claude/" ;;
  install)
    command -v jq >/dev/null || { echo "install jq first (brew install jq)"; exit 1; }
    jq empty "$REPO/settings.json" || { echo "claude/settings.json is not valid JSON, aborting"; exit 1; }
    CB=do_install each
    mkdir -p "$HOME/.claude/schemas"
    curl -fsSL https://json.schemastore.org/claude-code-settings.json \
      -o "$HOME/.claude/schemas/claude-code-settings.json" && echo "  schema downloaded" || echo "  schema download failed (only affects editor hints)"
    if [ -x "$HOME/work/claude-setup/devcontainer/cdev" ]; then
      ln -sf "$HOME/work/claude-setup/devcontainer/cdev" "$HOME/.local/bin/cdev" && echo "  linked cdev"
    fi
    echo
    echo "Next:"
    echo "  - claude/sync.sh gpg            (signed commits inside the sandbox)"
    echo "  - restore ~/.claude/bin/ch-prod-ro from your password manager (it holds credentials; not in git)"
    echo "  - start Claude, run /plugin to reinstall plugins listed in enabledPlugins" ;;
  gpg)
    KEY=$(git config --global user.signingkey)
    [ -n "$KEY" ] || { echo "no user.signingkey in git config"; exit 1; }
    mkdir -m 700 -p "$HOME/.gnupg-sandbox"
    GNUPGHOME="$HOME/.gnupg" gpg --export "$KEY" | GNUPGHOME="$HOME/.gnupg-sandbox" gpg --import
    echo no-autostart > "$HOME/.gnupg-sandbox/gpg.conf"
    GNUPGHOME="$HOME/.gnupg-sandbox" gpgconf --kill gpg-agent || true
    rm -f "$HOME"/.gnupg-sandbox/S.*
    ln -s "$(GNUPGHOME="$HOME/.gnupg" gpgconf --list-dirs agent-extra-socket)" "$HOME/.gnupg-sandbox/S.gpg-agent"
    GNUPGHOME="$HOME/.gnupg" gpgconf --launch gpg-agent
    ls -l "$HOME/.gnupg-sandbox/S.gpg-agent" ;;
  status)
    CB=do_status each ;;
  *)
    sed -n '2,15p' "$0"; exit 1 ;;
esac
