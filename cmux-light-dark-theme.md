# cmux: light/dark theme switching

Notes from setting up a light/dark toggle in cmux (stable 0.65.2, Nov 2026)
and the issues hit along the way.

## Final working setup

1. **Per-appearance themes** (cmux theme override):

   ```sh
   cmux themes set --light "GitHub Light Default" --dark "Ghostty Default Style Dark"
   ```

   Writes to `~/Library/Application Support/com.cmuxterm.app/config.ghostty`:

   ```
   # cmux themes start
   theme = light:GitHub Light Default,dark:Ghostty Default Style Dark
   # cmux themes end
   ```

2. **Toggle appearance** (works on stable):

   ```sh
   cmux config cycle app.appearance light dark
   ```

   Writes `"app": { "appearance": "light" | "dark" }` to `~/.config/cmux/cmux.json`.
   The running app picks it up without a reload.

3. **Reload everything** (cmux.json + all Ghostty configs): `cmd+shift+,` or `cmux reload-config`.

## Shortcut

An action is defined in `~/.config/cmux/cmux.json`:

```jsonc
"actions": {
  "toggleAppearance": {
    "type": "setting",
    "title": "Toggle Light/Dark Appearance",
    "path": "app.appearance",
    "cycle": ["light", "dark"],
    "shortcut": "cmd+ctrl+l"
  }
}
```

- `cmux config doctor` accepts it, but the **action registry and per-action
  `shortcut` are a nightly-only feature**. On stable 0.65.2 neither the shortcut
  nor the Command Palette entry works.
- Nightly: https://cmux.com/nightly (separate app, own bundle ID, runs alongside stable).
- On stable, bind `cmux config cycle app.appearance light dark` to a global hotkey
  (Raycast / skhd / Hammerspoon / Shortcuts.app). Full CLI path:
  `/Applications/cmux.app/Contents/Resources/bin/cmux`.
- `cmd+shift+l` is taken by `openBrowser`, which is why `cmd+ctrl+l` was picked.

## Root cause of "appearance changes but colors stay dark"

cmux reads Ghostty config from several places. A **fixed `theme = X` anywhere that
loads later overrides the cmux `light:...,dark:...` override**, so the terminal
(and the sidebar, which matches the terminal background by default) never changes.

Two culprits were found, in order:

1. `~/.config/ghostty/config` had `theme = Ghostty Default Style Dark` (removed).
2. `~/Library/Application Support/com.mitchellh.ghostty/config` ends with
   `config-file = ?auto/theme.ghostty`, and
   `~/Library/Application Support/com.mitchellh.ghostty/auto/theme.ghostty`
   contains `theme = Ghostty Default Style Dark`. This file is written by the
   standalone Ghostty app's theme picker. **Fix:** comment out the include:

   ```sh
   sed -i '' 's|^config-file = ?auto/theme.ghostty|# &|' \
     ~/Library/Application\ Support/com.mitchellh.ghostty/config
   ```

Diagnostic that pointed at it: switching Appearance by hand in cmux Settings also
changed nothing, so the problem was a pinned theme, not the CLI or the action.

## Gotchas

- Ghostty config locations cmux reads:
  - `~/.config/ghostty/config`
  - `~/Library/Application Support/com.mitchellh.ghostty/config` (+ anything it
    includes via `config-file =`)
  - `~/Library/Application Support/com.cmuxterm.app/config.ghostty` (cmux theme override)
- Picking a theme in standalone Ghostty rewrites `auto/theme.ghostty`; harmless now
  that the include is commented out. Change cmux themes with `cmux themes` (live
  picker) or `cmux themes set`.
- `terminal.adaptiveDefaultTheme` (default `true`) only applies when no theme or
  colors are configured anywhere.
- Inside the Claude Code sandbox, `cmux themes list` showed `inherit` for both slots
  because it couldn't read the override file. Sandbox-blocked reads can look like
  empty config. Verify outside the sandbox.

## Useful commands

```sh
cmux themes list | head -3            # current light/dark themes
cmux config get app.appearance        # current appearance
cmux config doctor                    # validate cmux.json
cmux shortcuts                        # list bound shortcuts (check conflicts)
cmux docs settings                    # config file locations, schema URL
```
