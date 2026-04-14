# General Shell Aliases (powered by eza)
alias ls='eza --icons --color-scale -o'
alias ll='eza -la --icons --group-directories-first --color-scale -o'
alias la='eza -a --icons --group-directories-first --color-scale -o'
alias l='eza -la --icons --group-directories-first --header --color-scale -o'

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
