# Enhanced built-in commands
# (from https://ericmjl.github.io/data-science-bootstrap-notes/shell/aliases/)

# Background tracker to securely activate and deactivate python virtual environments globally
_auto_venv() {
    local dir="$PWD"
    local venv_path=""

    # 1. Search recursively upwards for a .venv folder (stopping at HOME or root)
    while [ "$dir" != "/" ] && [ "$dir" != "$HOME" ]; do
        if [ -f "$dir/.venv/bin/activate" ]; then
            venv_path="$dir/.venv/bin/activate"
            break
        fi
        dir="$(dirname "$dir")"
    done

    # 2. If we left the project, automatically deactivate the old environment
    if [ -n "$VIRTUAL_ENV" ]; then
        if [ "$venv_path" != "$VIRTUAL_ENV/bin/activate" ]; then
            deactivate 2>/dev/null || true
        fi
    fi

    # 3. If we entered a new project, automatically activate its environment
    if [ -z "$VIRTUAL_ENV" ] && [ -n "$venv_path" ]; then
        source "$venv_path"
    fi
}

# Automatically list contents after changing directories and inject the venv tracker
unalias cd 2>/dev/null || true
cd() { 
    command cd "$@"
    local status=$?
    if [ $status -eq 0 ]; then
        _auto_venv
        ls 
    fi
    return $status
}

# Safely print what is being deleted before executing RM entirely
# We also natively inject -i here so you don't lose that safety net!
unalias rm 2>/dev/null || true
rm() { 
    echo "Deleting: $@"
    command rm -i "$@" 
}
