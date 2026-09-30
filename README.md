# Aitor's Dotfiles

These are my personal dotfiles, used to customize my computing environment seamlessly wherever I go.

## Philosophy

This repository is basically Eric J. Ma's [Data Science Bootstrap Notes](https://ericmjl.github.io/data-science-bootstrap-notes/), completely modernized:
1. **Ubuntu/Bash over macOS/ZSH**: These configurations are natively optimized for Ubuntu with Bash (perfect for WSL or Native Ubuntu servers).
2. **Powered by `chezmoi`**: Instead of manually parsing raw bash scripts and symlinking aliases, this repo uses [chezmoi](https://chezmoi.io/) to explicitly manage, template, and deploy configurations safely.
3. **Painless IDE Support**: Our configuration binds `chezmoi` directly to this working directory via symlinks. You don't have to navigate hidden `.local` folders. Just open this exact repository in **VSCode, Cursor, or Vim** and make your edits! 
4. **Modern Tooling Base**: Integrated state-of-the-art tools directly into the bash architecture:
   - **[uv](https://github.com/astral-sh/uv)**: Lightning-fast Python package installer.
   - **[pixi](https://github.com/prefix-dev/pixi)**: Extremely fast C++ conda alternative.
   - **[starship](https://starship.rs/)**: Aesthetic, blazing-fast cross-shell prompt.
   - **[tldr / tealdeer](https://github.com/tealdeer-rs/tealdeer)**: Fast local command examples with auto-updating cache.
   - **[lazygit](https://github.com/jesseduffield/lazygit)**: Terminal UI for fast Git workflows.
   - **[Neovim](https://neovim.io/)**: Modern Vim-based editor for terminal-first editing.
   - **[tennis](https://github.com/gurgeous/tennis)**: Interactive terminal tables for CSV, JSON, and SQLite. `install.sh` installs it from upstream release binaries (Linux amd64/arm64, Apple Silicon); elsewhere use Homebrew or the releases page.

## Prerequisites & IDE Setup

This environment utilizes icons heavily for `eza` and `starship`. The Linux setup automatically downloads the **FiraCode Nerd Font** for you. However, to see these icons gracefully inside your Windows/Host IDE (like VSCode or Cursor):

1. Make sure your computer natively has [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads) installed.
2. In your IDE settings (Cursor/VSCode), change `Terminal > Integrated: Font Family` to `'FiraCode Nerd Font'`.
3. **If using Windows Terminal for WSL:** Go to Terminal Settings -> **Profiles > Defaults** -> **Appearance**, and change the **Font face** to `FiraCode Nerd Font` to fix all standalone `wsl` launches natively.

## Installation

When starting on a new machine, clone the repo anywhere you want to maintain your code natively (e.g. `~/projects/dotfiles` or `~/dev/personal/dotfiles`) and run the setup.

```bash
cd ~/dev/personal
git clone https://github.com/aitorshuffle/dotfiles.git
cd dotfiles
./install.sh
```

`./install.sh` installs `pixi` (if missing), then installs the base CLI toolchain globally via `pixi`, including `lazygit`. After installation, launch it with:

```bash
lazygit
```

### Pixi Global Toolchain

`install.sh` runs:

```bash
pixi global install ripgrep bat fd-find fzf croc eza mosh tmux=3.6a atuin glow-md unzip tealdeer lazygit gh nvim markdownlint-cli
```

| Tool | Description | Homepage | Example usage |
| --- | --- | --- | --- |
| `ripgrep` (`rg`) | Fast recursive text search in files. | https://github.com/BurntSushi/ripgrep | `rg "TODO" .` |
| `bat` | `cat` replacement with syntax highlighting and paging. | https://github.com/sharkdp/bat | `bat README.md` |
| `fd-find` (`fd`) | Fast and user-friendly alternative to `find`. | https://github.com/sharkdp/fd | `fd install` |
| `fzf` | Fuzzy finder for interactive selection in shell workflows. | https://github.com/junegunn/fzf | `git branch \| fzf` |
| `croc` | Secure file transfer between two machines from the terminal. | https://github.com/schollz/croc | `croc send report.csv` |
| `eza` | Modern `ls` replacement with better defaults and icons. | https://github.com/eza-community/eza | `eza -la --icons` |
| `mosh` | Mobile shell for resilient remote terminal sessions. | https://mosh.org/ | `mosh user@server` |
| `tmux` | Terminal multiplexer for persistent/split sessions. | https://github.com/tmux/tmux | `tmux new -s work` |
| `atuin` | Shell history with search, sync, and better recall UX. | https://github.com/atuinsh/atuin | `atuin search docker` |
| `glow-md` (`glow`) | Render Markdown beautifully in the terminal. | https://github.com/charmbracelet/glow | `glow README.md` |
| `unzip` | Extract `.zip` archives from the command line. | https://infozip.sourceforge.net/UnZip.html | `unzip archive.zip` |
| `tealdeer` (`tldr`) | Fast local TLDR command examples client. | https://github.com/tealdeer-rs/tealdeer | `tldr tar` |
| `markdownlint-cli` | Markdown linting command line tool. | https://github.com/igorshubovych/markdownlint-cli | `markdownlint README.md` |
| `gh` | GitHub CLI for issues, pull requests and Actions. | https://cli.github.com/ | `gh run list` |
| `lazygit` | Interactive terminal UI for Git operations. | https://github.com/jesseduffield/lazygit | `lazygit` |
| `nvim` | Hyperextensible Vim-based text editor. | https://neovim.io/ | `nvim README.md` |

>**Note on existing configurations:**
> `chezmoi` will aggressively overwrite conflicting configurations on your new machine safely. If you have active code in `~/.bashrc` on your current computer, copy it into this repository's `dot_bashrc` **before** running `install.sh`!

## How to Manage Your Dotfiles (The "IDE" Workflow)

Because our `./install.sh` script maps `chezmoi` directly back to the folder you manually specified via a symlink, managing your files is incredibly natural whether you use the terminal or an IDE like Cursor:

1. **Editing Code**: Fully edit any file (e.g., `dot_bashrc` or `dot_shell_aliases/general.sh`) directly in your code editor of choice (Cursor, VSCode, Vim).
2. **Applying Code**: Hitting save doesn't automatically map it to the active system. Whenever you are ready to update your active machine with your edits, simply type `chezmoi apply` in any terminal!
3. **Adding New Files**: Got a new `~/.tmux.conf` or a `~/.vimrc` you want to start tracking? Type `chezmoi add ~/.vimrc`. The file will immediately show up here in your repository as `dot_vimrc` to be tracked!
4. **Deploying to GitHub**: Since you are editing directly inside your classic Git repository, you can just `git add`, `git commit`, and `git push` via VSCode's GUI or the terminal natively without dealing with clunky `chezmoi cd` or separate local workspaces.

## Structure 

The architecture strictly categorizes shell responsibilities:

- `dot_bashrc` -> Deploys to `~/.bashrc`. Entrypoint config. NVM, direnv, and Starship hooks.
- `dot_inputrc` -> Deploys to `~/.inputrc`. Background GNU readline settings linking shell history to your Arrow keys natively.
- `dot_path` -> Deploys to `~/.path`. Your absolute source of truth for loading ALL binaries.
- `dot_shell_aliases/` -> Deploys to `~/.shell_aliases/`. Functional shortcut groups (`git.sh`, `general.sh`). 
- `dot_shell_functions/` -> Deploys to `~/.shell_functions/`. Enhanced functions that rebuild core commands like `cd` and `rm`.
- `dot_gitconfig.tmpl` -> Deploys to `~/.gitconfig`. Tracked Git environment (diff-so-fancy integrations, pull rebasing, and automated upstreams).
- `dot_config/starship.toml` -> Deploys to `~/.config/starship.toml`. Beautiful shell prompt definitions. 
- `dot_config/direnv/direnv.toml` -> Deploys to `~/.config/direnv/direnv.toml`. Overrides direnv background behavior (like implicitly loading generic `.env` files).
- `dot_config/tealdeer/config.toml` -> Deploys to `~/.config/tealdeer/config.toml`. Configures `tldr` cache update behavior and display defaults.

## Pending (ToDos)
NOTE: pending implementations will be managed through issues instead of this list, in https://github.com/aitorshuffle/dotfiles/issues.
You can add an issue using `gh issue create -t "issue title" -a "@me"`
* Add VSCode/Cursor/Antigravity settings so that they are synchronize across machines and can be used in any of them
* Check and install the desired tpm plugins from https://github.com/tmux-plugins/list
## References

- [Eric J. Ma's Data Science Bootstrap Notes](https://ericmjl.github.io/data-science-bootstrap-notes/)
- [Chezmoi Reference Documentation](https://www.chezmoi.io/)

## Agent and batch shell environment

`dot_path` owns user tool paths, including `~/.pixi/bin`. `dot_bashrc` loads it and the configured `CODEX_HOME` before its interactive guard. Prompts, completions, aliases and NVM stay interactive. Noninteractive login Bash on Ubuntu reads `~/.profile`, which sources `~/.bashrc`. A deliberately nonlogin shell (`bash -c`, or an agent call with login disabled) must inherit the environment or explicitly source `~/.path`.

Run `bash scripts/check-shell-environment.sh` after changes. It uses a temporary HOME and minimal PATH to verify Pixi tool discovery, repeatable PATH loading and exclusion of interactive hooks. To check the deployed setup: `env -i HOME="$HOME" USER="$USER" PATH=/usr/bin:/bin /bin/bash -lc 'command -v gh; command -v pixi'`.

Apply only the changed files with `chezmoi apply ~/.path ~/.bashrc` after reviewing `chezmoi diff ~/.path ~/.bashrc`. Preserve machine-local additions first; do not run the full installer to deploy a small shell fix.

Cross-project agent behavior and lesson capture belong in [genai-tools](../genai-tools/own/lessons/README.md). Machine topology and deployment facts belong in the infrastructure wiki (`beelink-mini-s-pro:/home/aitor/brain`).

Existing agent sessions may restore a cached PATH captured before this fix. In the current command, run `. "$HOME/.path"` before using the tool, or use the verified executable location. Refresh the agent session/app and check discovery again; do not maintain generated shell snapshots by hand. This does not address launcher failures that occur before a shell starts.
