# README specific to tmux configuration
The conf is a replication of Eric J Ma's one: https://ericmjl.github.io/blog/2025/12/27/how-i-themed-my-tmux-with-opencode-and-claude/
It also contains opensessions side bar: https://github.com/Ataraxy-Labs/opensessions/

## XDG layout (`~/.config/tmux`)

This repo pins **`TMUX_PLUGIN_MANAGER_PATH`** to `~/.config/tmux/plugins/` so TPM and opensessions always use the same tree as `tmux.conf`, even when upstream docs mention `~/.tmux/plugins/`.

There is a **`~/.tmux.conf`** in the dotfiles that only `source-file`s `~/.config/tmux/tmux.conf` so a stray empty `~/.tmux.conf` cannot shadow the XDG config (depending on tmux build, `~/.tmux.conf` can take precedence over XDG; the stub avoids that).

**Requirements:** `git`, [TPM](https://github.com/tmux-plugins/tpm) (bootstrapped on first start), **`bun`** (installed by `./install.sh`; opensessions runs `bun install` inside the plugin checkout).

**Uninstall opensessions** — use the script under your plugin path, for example:

`~/.config/tmux/plugins/opensessions/integrations/tmux-plugin/scripts/uninstall.sh`  

(not `~/.tmux/plugins/...` unless you deliberately used that layout).
