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

# bun — required by the Ataraxy-Labs/opensessions tmux plugin (TPM runs bun install in the plugin dir)
if ! command -v bun >/dev/null 2>&1; then
    if [ -x "$HOME/.bun/bin/bun" ]; then
        export PATH="$HOME/.bun/bin:$PATH"
    else
        echo "Installing bun..."
        curl -fsSL https://bun.sh/install | bash
        export PATH="$HOME/.bun/bin:$PATH"
    fi
fi

# Install pixi (fast conda alternative)
if ! command -v pixi >/dev/null 2>&1; then
    if [ -x "$HOME/.pixi/bin/pixi" ]; then
        export PATH="$HOME/.pixi/bin:$PATH"
    else
        echo "Installing pixi..."
        curl -fsSL https://pixi.sh/install.sh | bash
        export PATH="$HOME/.pixi/bin:$PATH"
    fi
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
pixi global install ripgrep bat fd-find fzf croc eza mosh tmux=3.6a atuin glow-md unzip tealdeer lazygit

# Prime TLDR pages so the first run has docs available right away.
if command -v tldr >/dev/null 2>&1; then
    echo "Updating tldr cache..."
    tldr --update || echo "tldr cache update failed safely. Skipping."
fi

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

# tennis — https://github.com/gurgeous/tennis (CSV/JSON/SQLite tables in the terminal). Not on conda-forge, so not installable via `pixi global`; use upstream release tarballs like diff-so-fancy.
if ! command -v tennis >/dev/null 2>&1; then
    TENNIS_PLATFORM=""
    case "$(uname -s)_$(uname -m)" in
        Linux_x86_64) TENNIS_PLATFORM=linux_amd64 ;;
        Linux_aarch64|Linux_arm64) TENNIS_PLATFORM=linux_arm64 ;;
        Darwin_arm64) TENNIS_PLATFORM=darwin_arm64 ;;
    esac
    if [ -n "$TENNIS_PLATFORM" ]; then
        TENNIS_TAG=$(curl -fsSI https://github.com/gurgeous/tennis/releases/latest | tr -d '\r' | sed -n 's/^[lL]ocation:.*\/tag\///p' | head -n1)
        TENNIS_VER=$(echo "$TENNIS_TAG" | sed 's/^v//')
        if [ -z "$TENNIS_TAG" ] || [ -z "$TENNIS_VER" ]; then
            echo "Could not resolve latest tennis release tag. Skipping tennis."
        else
            echo "Installing tennis ($TENNIS_TAG) to ~/.local/bin..."
            mkdir -p "$HOME/.local/bin"
            TENNIS_TMP=$(mktemp -d)
            TENNIS_URL="https://github.com/gurgeous/tennis/releases/download/${TENNIS_TAG}/tennis_${TENNIS_VER}_${TENNIS_PLATFORM}.tar.gz"
            curl -fsSL "$TENNIS_URL" | tar -xz -C "$TENNIS_TMP"
            mv "$TENNIS_TMP/tennis_${TENNIS_VER}_${TENNIS_PLATFORM}/tennis" "$HOME/.local/bin/tennis"
            chmod +x "$HOME/.local/bin/tennis"
            rm -rf "$TENNIS_TMP"
        fi
    else
        echo "Skipping tennis: no prebuilt binary for $(uname -s)/$(uname -m). Use Homebrew on macOS or see https://github.com/gurgeous/tennis/releases"
    fi
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
chezmoi init --apply

TMUX_PLUGIN_DIR="$HOME/.config/tmux/plugins"
TPM_DIR="$TMUX_PLUGIN_DIR/tpm"
OPENSESSIONS_DIR="$TMUX_PLUGIN_DIR/opensessions"

# 6. Provision tmux TPM plugins so tmux works immediately after install.sh
echo "Provisioning tmux plugins under $TMUX_PLUGIN_DIR..."
mkdir -p "$TMUX_PLUGIN_DIR"

if [ ! -d "$TPM_DIR" ]; then
    echo "Installing tmux plugin manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

if [ ! -d "$OPENSESSIONS_DIR" ]; then
    echo "Installing opensessions tmux plugin..."
    git clone https://github.com/Ataraxy-Labs/opensessions "$OPENSESSIONS_DIR"
fi

if command -v bun >/dev/null 2>&1; then
    echo "Installing opensessions Bun dependencies..."
    (
        cd "$OPENSESSIONS_DIR"
        bun install
    )
else
    echo "bun is not available in PATH; skipping opensessions dependency install."
fi

echo "Dotfiles successfully installed! Please restart your terminal."
