#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting dotfiles setup with chezmoi..."

# 1. Install Chezmoi
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "chezmoi not found. Installing..."
    mkdir -p "$HOME/.local/bin"
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
fi

# 2. Install modern data science & terminal tools
echo "Checking and installing modern dev tools (uv, pixi, starship)..."

# Install uv (fast Python package installer)
if ! command -v uv >/dev/null 2>&1; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Install pixi (fast conda alternative)
if ! command -v pixi >/dev/null 2>&1; then
    echo "Installing pixi..."
    curl -fsSL https://pixi.sh/install.sh | bash
fi

# Install starship (fast cross-shell prompt)
if ! command -v starship >/dev/null 2>&1; then
    echo "Installing starship to ~/.local/bin..."
    mkdir -p ~/.local/bin
    sh -c "$(curl -fsLS https://starship.rs/install.sh)" -- -y --bin-dir ~/.local/bin
fi

# Install direnv (not with pixi, so as to isolate dotfiles core tools from rest)
if ! command -v direnv >/dev/null 2>&1; then
    echo "Installing direnv to ~/.local/bin..."
    export bin_path="$HOME/.local/bin"
    curl -sfL https://direnv.net/install.sh | bash
fi

# 3. Install core system software packages (Eric J Ma Setup)
echo "Installing global binaries via pixi..."
pixi global install ripgrep bat fd-find fzf croc eza mosh tmux atuin

if command -v apt-get >/dev/null 2>&1; then
    echo "Installing system packages via apt. This may prompt for your sudo password!"
    sudo apt update || echo "Apt update failed safely. Skipping."
    sudo apt install -y tree gcc || echo "Apt install failed safely. Skipping."
fi

# diff-so-fancy isn't natively in Ubuntu apt repos, so we fetch the raw executable directly
if ! command -v diff-so-fancy >/dev/null 2>&1; then
    echo "Installing diff-so-fancy to ~/.local/bin..."
    mkdir -p "$HOME/.local/bin"
    curl -sSfL https://github.com/so-fancy/diff-so-fancy/releases/latest/download/diff-so-fancy -o "$HOME/.local/bin/diff-so-fancy"
    chmod +x "$HOME/.local/bin/diff-so-fancy"
fi

# Automatically install a Linux-native Nerd Font for eza and starship
FONT_DIR="$HOME/.local/share/fonts"
if ! fc-list 2>/dev/null | grep -qi "FiraCode"; then
    echo "Installing FiraCode Nerd Font to ~/.local/share/fonts..."
    mkdir -p "$FONT_DIR"
    curl -fLo "$FONT_DIR/FiraCodeNerdFont-Regular.ttf" --create-dirs \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f -v >/dev/null
    fi
fi

# 4. Optional Heavy Daemon Installs 
# (Uncomment on a per-machine basis to install)
# echo "Installing Docker..."
# curl -fsSL https://get.docker.com | sh
# echo "Installing Ollama..."
# curl -fsSL https://ollama.com/install.sh | sh


# 5. Initialize and apply dotfiles
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Linking chezmoi natively to your active development folder ($REPO_DIR)..."
# We delete the default hidden repo if it exists and symlink it to your active workspace 
# so you can natively edit files in VSCode/Cursor and push with git!
rm -rf "$HOME/.local/share/chezmoi"
ln -s "$REPO_DIR" "$HOME/.local/share/chezmoi"

echo "Applying dotfiles to home directory..."
chezmoi apply

echo "Dotfiles successfully installed! Please restart your terminal."
