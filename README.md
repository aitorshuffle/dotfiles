# Aitor's Dotfiles

These are my personal dotfiles, used to customize my computing environment wherever I go.

## Philosophy

This repository is heavily inspired by Eric J. Ma's [Data Science Bootstrap Notes](https://ericmjl.github.io/data-science-bootstrap-notes/), but with some key adaptations:
1. **Ubuntu/Bash over macOS/ZSH**: These configurations are optimized for Ubuntu with Bash (perfect for WSL or native Ubuntu servers).
2. **Powered by `chezmoi`**: Instead of raw bash scripts and manual symlinks, this repo uses [chezmoi](https://chezmoi.io/) to securely template, deploy, and manage the environment.
3. **Modern Data Science Tooling**: Automated integration of state-of-the-art developer tools natively embraced by Eric J Ma:
   - **[uv](https://github.com/astral-sh/uv)**: Lightning-fast Python package installer.
   - **[pixi](https://github.com/prefix-dev/pixi)**: Extremely fast C++ alternative package manager to conda.
   - **[starship](https://starship.rs/)**: Aesthetic, blazing fast cross-shell prompt.

## Installation

### For a new machine

Just clone the repository and run the installation script:

```bash
cd ~
git clone https://github.com/aitorshuffle/dotfiles.git
cd dotfiles
./install.sh
```

>**Note on existing configurations:**
> If you already have manual configurations on your system (e.g., an existing `~/.bashrc`), it is highly recommended to integrate your manual changes into this repository's files *before* applying, so you don't lose data. 

## How to manage dotfiles locally (The `chezmoi` way)

Because this repository uses `chezmoi`, the actual source truth of your dotfiles now lives securely in `~/.local/share/chezmoi` after installation! **Do not** manually edit the files in your original git clone path anymore.

- **`chezmoi cd`**: Drops you smoothly into the `~/.local/share/chezmoi` folder. Run all your `git commit` and `git push` commands here to save your dotfiles to GitHub! Type `exit` when done to go back to your normal terminal.
- **`chezmoi edit ~/.bashrc`**: Opens your `~/.bashrc` seamlessly in your configured editor for modifications.
- **`chezmoi add ~/.tmux.conf`**: Pulls an existing system file permanently into your dotfile repo.
- **`chezmoi apply`**: Instructs chezmoi to apply all configurations across your machine and apply any changes aggressively.

## Structure

Following Eric's principles, we keep the configuration compartmentalized into clear functional areas rather than dumping everything into `~/.bashrc`!

- `dot_bashrc` -> Deploys to `~/.bashrc`. The entrypoint. Handles programmable completions, NVM, and `direnv`.
- `dot_path` -> Deploys to `~/.path`. Your single source of truth for custom binary paths (`~/.local/bin`, `~/bin`, npm globals, pixi bins).
- `dot_shell_aliases/` -> Deploys to `~/.shell_aliases/`. Contains separated scripts for Git (`git.sh`) and general shortcuts (`general.sh`).
- `dot_gitconfig.tmpl` -> Deploys to `~/.gitconfig`. Templated to securely inject your email via prompt on installation.
- `dot_config/starship.toml` -> Deploys to `~/.config/starship.toml`. Controls the clean structure of the Starship prompt.

## Inspirations

- [Eric J. Ma's Data Science Bootstrap Notes](https://ericmjl.github.io/data-science-bootstrap-notes/)
- [Eric J. Ma's .dotfiles](https://github.com/ericmjl/dotfiles)
- [Mathias' .dotfiles (recursively from Eric's)](https://github.com/mathiasbynens/dotfiles)
