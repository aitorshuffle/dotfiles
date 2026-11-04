#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
fixture_home="$(mktemp -d)"
trap 'rm -rf -- "$fixture_home"' EXIT
cp "$repo_root/dot_bashrc" "$fixture_home/.bashrc"
cp "$repo_root/dot_path" "$fixture_home/.path"
mkdir -p "$fixture_home/.pixi/bin"
for tool in gh pixi; do
    printf '#!/bin/sh\nexit 0\n' > "$fixture_home/.pixi/bin/$tool"
    chmod +x "$fixture_home/.pixi/bin/$tool"
done
env -i HOME="$fixture_home" PATH=/usr/bin:/bin /bin/bash --noprofile --norc -eu -c '
    . "$HOME/.bashrc"
    for tool in gh pixi; do
        [[ "$(command -v "$tool")" == "$HOME/.pixi/bin/$tool" ]]
    done
    [[ "${CODEX_HOME:-}" == "$HOME/.codex-wsl" ]]
    [[ -z "${PROMPT_COMMAND:-}" && -z "${NVM_DIR:-}" ]]
    first_path="$PATH"
    . "$HOME/.path"
    . "$HOME/.path"
    [[ "$PATH" == "$first_path" ]]
'
printf 'Shell environment regression check passed.\n'
