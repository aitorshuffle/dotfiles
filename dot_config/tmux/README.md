# README specific to tmux configuration
The conf is a replication of Eric J Ma's one: https://ericmjl.github.io/blog/2025/12/27/how-i-themed-my-tmux-with-opencode-and-claude/
It also contains opensessions side bar: https://github.com/Ataraxy-Labs/opensessions/

## XDG layout (`~/.config/tmux`)

This repo pins **`TMUX_PLUGIN_MANAGER_PATH`** to `~/.config/tmux/plugins/` so TPM and opensessions always use the same tree as `tmux.conf`, even when upstream docs mention `~/.tmux/plugins/`.

There is a **`~/.tmux.conf`** in the dotfiles that only `source-file`s `~/.config/tmux/tmux.conf` so a stray empty `~/.tmux.conf` cannot shadow the XDG config (depending on tmux build, `~/.tmux.conf` can take precedence over XDG; the stub avoids that).

**Requirements:** `git`, [TPM](https://github.com/tmux-plugins/tpm), and **`bun`**. `./install.sh` now provisions TPM plus the `opensessions` checkout under `~/.config/tmux/plugins/` and runs `bun install` there during setup. The tmux config still keeps a first-start TPM bootstrap as a fallback.

## Shell helpers

The Bash alias/function set includes a tmux workflow:

- `t` creates or attaches to a session named from the current directory. It uses the basename by default and only widens to more path segments when another tmux session already owns that short name.
- `t` also stores the launch directory in the tmux session environment as `TMUX_SESSION_ROOT`.
- `tcd` jumps back to that stored session root from inside a tmux pane. If `TMUX_SESSION_ROOT` is missing, it falls back to tmux's built-in `session_path`.
- `tl` lists tmux sessions together with their recorded `session_path`.

## Reloading and plugins

- `prefix + r` runs `source-file ~/.config/tmux/tmux.conf`, which reloads the tmux config for the current tmux server. This updates reloadable tmux settings such as bindings, status bar options, and plugin declarations across sessions on that server, but it does not restart existing panes or shells.
- `prefix + I` is provided by TPM. It installs any plugins declared in `tmux.conf` that are not present yet. Use it after adding a new `set -g @plugin ...` entry.
- When changing plugin declarations, the usual flow is: edit `tmux.conf`, press `prefix + I` to install missing plugins, then press `prefix + r` to reload the config.

**Uninstall opensessions** — use the script under your plugin path, for example:

`~/.config/tmux/plugins/opensessions/integrations/tmux-plugin/scripts/uninstall.sh`  

(not `~/.tmux/plugins/...` unless you deliberately used that layout).
