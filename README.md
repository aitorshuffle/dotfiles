# Aitor's Dotfiles

These are my personal dotfiles, used to customize my computing environment wherever I go.

## Philosophy

This repository is heavily inspired by Eric J. Ma's [Data Science Bootstrap Notes](https://ericmjl.github.io/data-science-bootstrap-notes/), but with some key adaptations:
1. **Ubuntu/Bash over macOS/ZSH**: These configurations are written for Ubuntu with Bash in mind (perfect for WSL or native Ubuntu servers).
2. **Powered by `chezmoi`**: Instead of raw bash scripts and manual symlinks, this repo uses [chezmoi](https://chezmoi.io/) to securely template, deploy, and manage the environment.

## Installation

### For Myself (or a new machine)

Just clone the repository and run the installation script:

```bash
cd ~
git clone https://github.com/aitorshuffle/dotfiles.git
cd dotfiles
./install.sh
```

>**Note on existing configurations:**
> If you already have manual configurations on your system (e.g., an existing `~/.bashrc`), it is highly recommended to run `chezmoi diff` inside the repo before running `./install.sh`. This lets you see exactly what will be overwritten. You can integrate your manual changes into the dotfiles repo before applying.

## How to use `chezmoi`

Since this repository is managed by `chezmoi`, you shouldn't manually copy files. Instead:

- **Adding a new file:** Use `chezmoi add ~/.some_new_config_file`. It will track it in this repository.
- **Editing an existing file:** Run `chezmoi edit ~/.bashrc` to update it directly in the source repo, then just type `chezmoi apply` to apply it.
- **Seeing what will change:** Run `chezmoi diff` before applying changes on a new machine.

## Structure

Following Eric's principles, we keep the configuration compartmentalized into clear functional areas rather than dumping everything into `~/.bashrc`!

- `dot_bashrc` -> Deploys to `~/.bashrc`. The entrypoint.
- `dot_path` -> Deploys to `~/.path`. Your single source of truth for custom binary paths (`~/.local/bin`, etc.)
- `dot_shell_aliases/` -> Deploys to `~/.shell_aliases/`. Contains separated scripts for Git, general shortcuts, and other commands.
- `dot_gitconfig.tmpl` -> Deploys to `~/.gitconfig`. Templated to securely inject your email via prompt on installation.

## Inspirations

- [Eric J. Ma's Data Science Bootstrap Notes](https://ericmjl.github.io/data-science-bootstrap-notes/)
- [Eric J. Ma's .dotfiles](https://github.com/ericmjl/dotfiles)
- [Mathias' .dotfiles (recursively from Eric's)](https://github.com/mathiasbynens/dotfiles)
