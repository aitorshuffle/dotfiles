#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting dotfiles setup with chezmoi..."

# 1. Install Chezmoi
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "chezmoi not found. Installing..."
    sh -c "$(curl -fsLS get.chezmoi.io)"
    export PATH="./bin:$PATH"
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


# 3. Initialize and apply dotfiles
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Initializing chezmoi with source directory $REPO_DIR..."
chezmoi init "file://$REPO_DIR"

echo "Applying dotfiles to home directory..."
chezmoi apply

echo "Dotfiles successfully installed! Please restart your terminal."
