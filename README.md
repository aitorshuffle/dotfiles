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

## Prerequisites & IDE Setup

This environment utilizes icons heavily for `eza` and `starship`. The Linux setup automatically downloads the **FiraCode Nerd Font** for you. However, to see these icons gracefully inside your Windows/Host IDE (like VSCode or Cursor):

1. Make sure your computer natively has [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads) installed.
2. In your IDE settings, change `Terminal > Integrated: Font Family` to `'FiraCode Nerd Font'`.

## Installation

When starting on a new machine, clone the repo anywhere you want to maintain your code natively (e.g. `~/projects/dotfiles` or `~/dev/personal/dotfiles`) and run the setup.

```bash
cd ~/dev/personal
git clone https://github.com/aitorshuffle/dotfiles.git
cd dotfiles
./install.sh
```

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

## Pending
* Add VSCode/Cursor/Antigravity settings so that they are synchronize across machines and can be used in any of them
* Reference genai-tools
## References

- [Eric J. Ma's Data Science Bootstrap Notes](https://ericmjl.github.io/data-science-bootstrap-notes/)
- [Chezmoi Reference Documentation](https://www.chezmoi.io/)
