# General Shell Aliases (powered by eza)
alias ls='eza --icons --color-scale -o'
alias ll='eza -la --icons --group-directories-first --color-scale -o'
alias la='eza -a --icons --group-directories-first --color-scale -o'
alias l='eza -la --icons --group-directories-first --header --color-scale -o'
unalias ld 2>/dev/null || true

_human_size() {
    numfmt --to=iec --suffix=B --format="%.1f" "$1" 2>/dev/null || printf '%sB\n' "$1"
}

ld() {
    recursive_timeout=${L_RECURSIVE_SIZE_TIMEOUT:-5}
    recursive_timed_out=0
    entries=()

    if [ "$#" -gt 0 ]; then
        for entry in "$@"; do
            entries+=("$entry")
        done
    else
        shopt -s dotglob nullglob
        for entry in *; do
            entries+=("$entry")
        done
        shopt -u dotglob nullglob
    fi

    if [ "${#entries[@]}" -eq 0 ]; then
        printf 'Permissions Octal User Size Modified Name\n'
        return 0
    fi

    sorted_entries=$(
        for entry in "${entries[@]}"; do
            if [ -d "$entry" ] && [ ! -L "$entry" ]; then
                printf '0\t%s\n' "$entry"
            else
                printf '1\t%s\n' "$entry"
            fi
        done | sort -k1,1 -k2,2
    )

    printf 'Permissions Octal User Size Modified Name\n'

    start_time=$SECONDS
    while IFS=$'\t' read -r _sort_key entry; do
        [ -n "$entry" ] || continue

        if [ ! -e "$entry" ] && [ ! -L "$entry" ]; then
            continue
        fi

        permissions=$(stat -c '%A' -- "$entry" 2>/dev/null)
        octal_permissions=$(stat -c '%a' -- "$entry" 2>/dev/null)
        owner=$(stat -c '%U' -- "$entry" 2>/dev/null)
        byte_size=$(stat -c '%s' -- "$entry" 2>/dev/null)
        modified_epoch=$(stat -c '%Y' -- "$entry" 2>/dev/null)
        display_name=$entry

        if [ -L "$entry" ]; then
            link_target=$(readlink -- "$entry" 2>/dev/null)
            if [ -n "$link_target" ]; then
                display_name="$entry -> $link_target"
            fi
        fi

        if [ -n "$modified_epoch" ]; then
            modified_time=$(date -d "@$modified_epoch" '+%Y-%m-%d %H:%M' 2>/dev/null)
        else
            modified_time='-'
        fi

        display_size=$(_human_size "${byte_size:-0}")

        if [ -d "$entry" ] && [ ! -L "$entry" ] && [ "$recursive_timed_out" -eq 0 ]; then
            elapsed_time=$((SECONDS - start_time))
            remaining_time=$((recursive_timeout - elapsed_time))

            if [ "$remaining_time" -le 0 ]; then
                recursive_timed_out=1
            elif command -v timeout >/dev/null 2>&1; then
                recursive_size=$(timeout --foreground "${remaining_time}s" du -sh -- "$entry" 2>/dev/null | cut -f1)
                recursive_status=$?

                if [ "$recursive_status" -eq 0 ] && [ -n "$recursive_size" ]; then
                    display_size=$recursive_size
                elif [ "$recursive_status" -eq 124 ] || [ "$recursive_status" -eq 137 ]; then
                    recursive_timed_out=1
                fi
            else
                recursive_size=$(du -sh -- "$entry" 2>/dev/null | cut -f1)
                if [ -n "$recursive_size" ]; then
                    display_size=$recursive_size
                fi
            fi
        fi

        printf '%-11s %-5s %-8s %8s %16s %s\n' \
            "${permissions:--}" \
            "${octal_permissions:---}" \
            "${owner:--}" \
            "$display_size" \
            "$modified_time" \
            "$display_name"
    done <<EOF
$sorted_entries
EOF

    if [ "$recursive_timed_out" -eq 1 ]; then
        echo
        echo "Recursive size scan exceeded ${recursive_timeout}s. Remaining directories keep their regular size."
    fi
}

# File viewing
alias cat='bat'

# Safety aliases (prompts before overwriting)
alias cp='cp -i'
alias mv='mv -i'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Updates
alias update='sudo apt update && sudo apt upgrade -y'

# System shortcuts
alias please="sudo"

# port management
alias wtfport='f() { lsof -i tcp:$1; }; f'  # src: https://ericmjl.github.io/data-science-bootstrap-notes/shell/aliases/
alias killport='f() { lsof -ti:$1 | xargs kill -9; }; f'  # src: https://ericmjl.github.io/data-science-bootstrap-notes/shell/aliases/
alias ports="lsof -i -P -n | grep LISTEN"

# tmux
# ref: https://www.hardscrabble.net/2023/my-tmux-aliases/
unalias t tcd tl ta to 2>/dev/null || true

tmux_session_name() {
    current_path=$PWD
    current_name=
    existing_path=
    depth=1

    while :; do
        current_name=$(printf '%s\n' "$current_path" | awk -F/ -v depth="$depth" '
            {
                start = NF - depth + 1
                if (start < 1) {
                    start = 1
                }

                out = $start
                for (i = start + 1; i <= NF; i++) {
                    out = out "/" $i
                }

                print out
            }
        ' | tr ':' '_')

        existing_path=$(tmux list-sessions -F '#{session_name}	#{session_path}' 2>/dev/null | awk -F'	' -v name="$current_name" '$1 == name { print $2; exit }')

        if [ -z "$existing_path" ] || [ "$existing_path" = "$current_path" ]; then
            printf '%s\n' "$current_name"
            return
        fi

        if [ "$current_name" = "${current_path#/}" ]; then
            printf '%s\n' "$current_name"
            return
        fi

        depth=$((depth + 1))
    done
}

tmux_session_root() {
    session_name=${1:-$(tmux display-message -p '#S' 2>/dev/null)}

    if [ -z "$session_name" ]; then
        return 1
    fi

    root_path=$(tmux show-environment -t "$session_name" TMUX_SESSION_ROOT 2>/dev/null | sed 's/^TMUX_SESSION_ROOT=//')

    if [ -n "$root_path" ]; then
        printf '%s\n' "$root_path"
        return 0
    fi

    tmux display-message -p -t "$session_name" '#{session_path}' 2>/dev/null
}

t() {
    session_name=$(tmux_session_name)

    tmux new-session -A -s "$session_name"
    tmux set-environment -t "$session_name" TMUX_SESSION_ROOT "$PWD" >/dev/null 2>&1 || true
}

tcd() {
    root_path=$(tmux_session_root "$1")
    status=$?

    if [ $status -ne 0 ] || [ -z "$root_path" ]; then
        echo "No tmux session root found."
        return 1
    fi

    cd "$root_path"
}

#alias 'tl'="tmux list-sessions -F '#{session_name} (#{session_windows} #{?#{==:#{session_windows},1},window,windows})'"
#$ alias 'tl'="tmux list-sessions -F '#{session_name} (#{session_path})'
#alias 'tl'="tmux list-sessions -F '#{s/ [a-f0-9][a-f0-9][a-f0-9][a-f0-9]$//:session_name}' 2>/dev/null || echo 'no sessions'"
alias 'tl'="tmux list-sessions -F '#{session_name} (#{session_path})' 2>/dev/null || echo 'no sessions'"
alias 'ta'='tmux attach-session'
alias 'to'='tmux attach-session -t'
