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
alias 't'='tmux new-session -A -s "$(basename $PWD | tr ":" "_") $(echo $PWD | shasum -a 256 | cut -c1-4)"'
#alias 'tl'="tmux list-sessions -F '#{session_name} (#{session_windows} #{?#{==:#{session_windows},1},window,windows})'"
#$ alias 'tl'="tmux list-sessions -F '#{session_name} (#{session_path})'
#alias 'tl'="tmux list-sessions -F '#{s/ [a-f0-9][a-f0-9][a-f0-9][a-f0-9]$//:session_name}' 2>/dev/null || echo 'no sessions'"
alias 'tl'="tmux list-sessions -F '#{s/ [a-f0-9][a-f0-9][a-f0-9][a-f0-9]$//:session_name} (#{session_path})' 2>/dev/null || echo 'no sessions'"
alias 'ta'='tmux attach-session'
alias 'to'='tmux attach-session -t'
